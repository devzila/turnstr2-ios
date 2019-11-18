//
//  PickerView.swift
//  ConetBook
//
//  Created by softobiz on 9/13/16.
//  Copyright © 2016 Ankit_Saini. All rights reserved.
//

import UIKit

@objc protocol PickerDelegate {
    @objc optional func MyPIckerViewdidselectRow(controller: PickerView, selectedINdex: Int) -> Void
}

class PickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {

    
    var keyboardToolbar1 = UIToolbar()
    var arrRows = NSArray()
    
    var lblHEading = UILabel()
    
    //Declaring delegate
    var delegatePicker: PickerDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.delegate = self;
        self.showsSelectionIndicator = true
        self.backgroundColor=UIColor.white;
        lblHEading.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: 25)
        lblHEading.textAlignment = .center
        lblHEading.backgroundColor = UIColor.white
        lblHEading.font = UIFont.systemFont(ofSize: 15.0)
        //lblHEading.textColor = kHEadColor
        self.addSubview(lblHEading)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
    func loadPIcker() -> Void {
        
        self .reloadAllComponents()
    }
    
    //MARK:- Picker view Data Source & Delegates
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrRows.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40.0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrRows[row] as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var tView = view as! UILabel?
        
        if tView == nil {
            tView = UILabel.init()
        }
        tView?.textAlignment = .center
        tView?.adjustsFontSizeToFitWidth = true
        tView?.textColor = UIColor.black
        
        tView?.text = arrRows[row] as? String;
        return tView!;
    }
    
    func addDoneAndCancelButton(inView: UIView, yCo: CGFloat) -> Void {
        self.keyboardToolbar1.removeFromSuperview()
        self.resignFirstResponder()
        keyboardToolbar1 = UIToolbar.init(frame: CGRect.init(x: 0, y: yCo, width: kWidth, height: 44))
        keyboardToolbar1.barStyle = .blackTranslucent
        keyboardToolbar1.sizeToFit()
        
        let flexButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        
        let doneButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(closePicker))
        doneButton.tintColor = UIColor.white
        
        let itemsArray:Array = [flexButton, doneButton]
        keyboardToolbar1.items = itemsArray
        inView.addSubview(keyboardToolbar1)
        
    }

    @objc func closePicker() -> Void {
        self.keyboardToolbar1.removeFromSuperview()
        self.removeFromSuperview()
        
        delegatePicker?.MyPIckerViewdidselectRow!(controller: self, selectedINdex: self.selectedRow(inComponent: 0))
    }
    
    func cancelPicker() -> Void {
        self.keyboardToolbar1.removeFromSuperview()
        self.removeFromSuperview()
    }
}

