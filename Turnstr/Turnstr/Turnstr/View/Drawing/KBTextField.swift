//
//  KBTextField.swift
//  TURNSTR
//
//  Created by Apple on 21/02/16.
//  Copyright © 2016 Neophyte. All rights reserved.
//

import UIKit

@IBDesignable

class KBTextField: UITextField {
    
    enum InputTypes {
        case date(Date)
        case string
        case normal
    }
    
    
    var txfInputType: InputTypes = .normal
    
    /*
     Padding to text field on left side, Default it is zero.
     */
    @IBInspectable var padding : CGFloat = 0.0
    
    /*
     * normalBorderColor
     * This will add border color to text field.
     * This is border color when text field is not first responder.
     */
    @IBInspectable var normalBorderColor  : UIColor?{
      didSet{
        guard let borderColor = normalBorderColor else {
            return
        }
        borderStyle = .none
        layer.borderColor = borderColor.cgColor;
        }
    }
    
    /*
     * selectedBorderColor
     * This is border color when text field is first responder.
     */
    @IBInspectable var selectedBorderColor: UIColor?
  
    /*
     * borderWidth
     * This will draw the border of value border width.
     */
    @IBInspectable var borderWidth  : CGFloat = 0.0{
        didSet{
            layer.borderWidth = borderWidth;
        }
    }
    
    /*
     * cornerRadius
     * This will curve the corners of text field by value of cornerRadius
     */
    @IBInspectable var cornerRadius : CGFloat = 1.0{
        didSet{
            layer.cornerRadius = cornerRadius;
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    /*
     * placeholderTextColor
     * Text field will appear with custom text color of placeholer.
     * Attributed placehoilder text color will added to text field.
     */
    @IBInspectable var placeholderTextColor : UIColor? = UIColor.white{
        didSet{
          guard let pColor = placeholderTextColor, let strPlaceholder = placeholder else {
            return
          }
            let color: UIColor = pColor
            attributedPlaceholder = NSAttributedString(string: strPlaceholder, attributes: [NSAttributedString.Key.foregroundColor : color]);
            tintColor = placeholderTextColor
        }
    }
    
    /*
    * image
    * Text fieled will appear with image on left side in text field.
    */
    @IBInspectable var image : UIImage? = UIImage(named: "username"){
        didSet{
            leftViewMode = .always
            let imageView : UIImageView = UIImageView(image: image)
            imageView.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 30.0)
            imageView.contentMode = .right
            leftView = imageView
        }
    }
    
    /*
     * placeholder
     * Function will override the property .placeholder to custom placeholder color.
     */
    override public var placeholder: String?{
        didSet{
          guard let pColor = placeholderTextColor, let strPlaceholder = placeholder else {
            return
          }
            attributedPlaceholder = NSAttributedString(string: strPlaceholder, attributes: [NSAttributedString.Key.foregroundColor : pColor]);
            tintColor = placeholderTextColor
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        
        NotificationCenter.default.addObserver(self, selector: #selector(KBTextField.textFieldEndEditing(_:)), name:  UITextField.textDidEndEditingNotification, object:self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(KBTextField.textFieldBeginEditing(_:)), name:  UITextField.textDidBeginEditingNotification, object:self)
        
        self.clearButtonMode = .always
        var imgWidth = padding
        if let _ = image {
            imgWidth = padding + 35//image x + width
        }
        
        if self.keyboardType == .emailAddress {
            self.autocorrectionType = .no
            self.autocapitalizationType = .none
        }
        
        return CGRect(x: imgWidth + bounds.origin.x,
                      y: bounds.origin.y,
                      width: bounds.size.width - imgWidth,
                      height: bounds.size.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    @objc func textFieldEndEditing(_ notification: Notification){
     
      layer.borderColor = normalBorderColor?.cgColor
    }
    
    @objc func textFieldBeginEditing(_ notification: Notification){
        
        guard let borderColor = selectedBorderColor else {
            return
        }
        layer.borderColor = borderColor.cgColor
        if text == "" {
            prefillForInputType()
        }
    }
    
    func prefillForInputType() {
        switch txfInputType {
            
        case .string:
            guard let option = self.inputOptions.first else { return }
            text = option
            
        case .date(let minDate):
            self.text = minDate.string(.MMM_dd_yyyy)
            self.restorationIdentifier = minDate.utcString
            
        default:
            text = ""
        }
    }
    
    //MARK: Custom Input Views
    /**
     * Picker Input View
     */
    var inputOptions = [String]()
    func pickerInputView(_ options: [String]) {
        let picker = UIPickerView(frame: CGRect(x: 0.0, y: 0.0, width: Screen.width.value, height: 225.0))
        inputOptions = options
        txfInputType = .string
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = .lightText
        self.inputView = picker
    }
    /**
     * Date Picker
     */
    func datePickerView(_ maximumDate: Date?, _ minimumDate: Date?) {
        let picker = UIDatePicker()
        if let mDate = maximumDate {
            picker.maximumDate = mDate
            txfInputType = .date(mDate)
        }
        if let mDate = minimumDate {
            picker.minimumDate = mDate
            txfInputType = .date(mDate)
        }
        if text == "" {
            picker.date = minimumDate ?? (maximumDate ?? Date())
        }
        else {
            let date = Date.init(.utc, self.restorationIdentifier)
            picker.date = date ?? Date()
        }
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        self.inputView = picker
    }
    
    @objc func dateChanged(_ picker: UIDatePicker) {
        let date = picker.date
        self.text = date.string(.MMM_dd_yyyy)
        self.restorationIdentifier = date.utcString
    }
}


extension KBTextField: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return inputOptions.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return inputOptions[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.text = inputOptions[row]
    }
    
}
