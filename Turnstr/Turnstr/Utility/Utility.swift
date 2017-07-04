//
//  Utility.swift
//  SwifPro
//
//  Created by softobiz on 4/5/16.
//  Copyright © 2016 softobiz. All rights reserved.
//

import UIKit

class Utility: NSObject {

    static let sharedInstance: Utility = {
        let instance = Utility()
        
        return instance
    }()
    
    
    //MARK: ------ View Creation Methods -------
    func createImageView(xCo: CGFloat, forY yCo: CGFloat, forWidth width: CGFloat, forHeight height: CGFloat, forImageName imageName: String, backColor backgroundColor: UIColor) -> UIImageView {
        let img: UIImageView = UIImageView(frame: CGRect.init(x: xCo, y: yCo, width: width, height: height))
        if !(imageName == "") {
            img.image = UIImage(named: imageName)
        }
        img.layer.cornerRadius = 2
        img.backgroundColor = backgroundColor
        return img
    }
    
    
    func createLable(xCo: CGFloat, forY yCo: CGFloat, forW Width: CGFloat, forH Height: CGFloat, forText text: String, textColor tClr: UIColor, wifthFont font: UIFont, backColor bcColor: UIColor, align: Int) -> UILabel {
        /*align=1=>left     =2=>center     =>3=>right     */
        let lblHeading: UILabel = UILabel(frame: CGRect.init(x: xCo, y: yCo, width: Width, height: Height))
        lblHeading.text = text
        lblHeading.textColor = tClr
        lblHeading.backgroundColor = bcColor
        if align == 1 {
            lblHeading.textAlignment = .left
        }
        else if align == 2 {
            lblHeading.textAlignment = .center
        }
        else if align == 3 {
            lblHeading.textAlignment = .right
        }
        
        lblHeading.font = font
        lblHeading.numberOfLines = 0
        return lblHeading
    }
    
    
    func createButton(xCo: CGFloat, forY yCo: CGFloat, forW Width: CGFloat, forH Height: CGFloat, forText text: String, textColor tClr: UIColor, wifthFont font: UIFont, backColor bcColor: UIColor) -> UIButton {
        let btn: UIButton = UIButton(frame: CGRect.init(x: xCo, y: yCo, width: Width, height: Height))
        btn.setTitle(text, for: .normal)
        btn.setTitleColor(tClr, for: .normal)
        btn.titleLabel!.font = font
        btn.backgroundColor = bcColor
        return btn
    }
    
    
    func createView(xCo: CGFloat, forY yCo: CGFloat, forW Width: CGFloat, forH Height: CGFloat, backColor bcColor: UIColor) -> UIView {
        let view: UIView = UIView(frame: CGRect.init(x: xCo, y: yCo, width: Width, height: Height))
        view.backgroundColor = bcColor
        return view
    }
    
    
    //MARK: ------ setFrames -------
    
    func setFrames(xCo: CGFloat, yCo: CGFloat, width: CGFloat, height: CGFloat, view: UIView) -> Void {
        var newFrame: CGRect = view.frame
        if xCo > 0 {
            newFrame.origin.x = xCo
        }
        if yCo > 0 {
            newFrame.origin.y = yCo
        }
        if width > 0 {
            newFrame.size.width = width
        }
        if height > 0 {
            newFrame.size.height = height
        }
        view.frame = newFrame
    }
    
    
    //MARK: ------ TextFields Methods -------
    
    func addPaddingToTextField(arrTextFields: Array<UITextField>)
    {
        for  textField: UITextField in arrTextFields {
            
            let spacerView: UIView = UIView(frame: CGRect.init(x: 0, y: 0, width: 10, height: 10))
            textField.leftViewMode = UITextFieldViewMode.always
            textField.leftView = spacerView;
            
        }
    }
    
    func setPlaceholderColor(textField: UITextField, colr: UIColor, placeholderText: String) -> Void {
        if textField.responds(to: #selector(setter: UITextField.attributedPlaceholder)) {
            let color: UIColor = colr
            textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSForegroundColorAttributeName: color])
        }
        else {
            textField.placeholder = placeholderText
            NSLog("Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0")
        }

    }
    
    //MARK:- ------ Create UIImage from UIcolor -------
    func imageWithColor(color: UIColor) -> UIImage {
        let rect: CGRect = CGRect.init(x: 0, y: 0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
   
    
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect.init(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    func WidthForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect.init(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.width
    }
    
    func addImgInLabel(imgName: String, text: String) -> NSAttributedString {
        let attachment: NSTextAttachment = NSTextAttachment()
        attachment.image = UIImage(named: imgName)
        attachment.bounds = CGRect.init(x: 0, y: -4, width: 20, height: 20)
        let attachmentString: NSAttributedString = NSAttributedString(attachment: attachment)
        let myString: NSMutableAttributedString = NSMutableAttributedString(attributedString: attachmentString)
        let myText: NSAttributedString = NSMutableAttributedString(string: text)
        myString.append(myText)
        return myString
    }
    
    func getImageSize(strUrl: String) -> CGSize {
        let image: UIImage = UIImage(named: strUrl)!
        return image.size
    }
    
   
    
    //MARK:- Resize image
    func RBSquareImageTo(image: UIImage, size: CGSize) -> UIImage {
        return RBResizeImage(image: RBSquareImage(image: image), targetSize: size)
    }
    
    func RBSquareImage(image: UIImage) -> UIImage {
        let originalWidth  = image.size.width
        let originalHeight = image.size.height
        
        var edge: CGFloat
        if originalWidth > originalHeight {
            edge = originalHeight
        } else {
            edge = originalWidth
        }
        
        let posX = (originalWidth  - edge) / 2.0
        let posY = (originalHeight - edge) / 2.0
        
        let cropSquare = CGRect.init(x: posX, y: posY, width: edge, height: edge)
        
        let imageRef = image.cgImage!.cropping(to: cropSquare);
        return UIImage(cgImage: imageRef!, scale: UIScreen.main.scale, orientation: image.imageOrientation)
    }
    
    func RBResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize.init(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize.init(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    //MARK: ------ Set text line height ------
    func setTextLineHeight(string: String, height: CGFloat) -> NSAttributedString {
        let parStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        parStyle.minimumLineHeight = height
        let ats: Dictionary = [NSParagraphStyleAttributeName: parStyle]
        return NSAttributedString(string: string, attributes: ats)
    }
    
    
    func setTextColor(color: UIColor, range: NSRange?, strText: String) -> NSAttributedString {
            
        let text: NSMutableAttributedString = NSMutableAttributedString.init(string: strText)
        text.addAttribute(NSForegroundColorAttributeName, value: color, range: range!)
        return text
    }
    
    func printFonts() -> Void {
        let fontFamilyNames = UIFont.familyNames
        for familyName in fontFamilyNames {
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNames(forFamilyName: familyName )
            print("Font Names = [\(names)]")
        }
    }
    
    //MARK:- ------  Days between two dates ------
    
    func dateDifferences(fromDate: String, toDate: String) -> Int {
        //var components: NSDateComponents
        
        let cal = NSCalendar.current
        // let unit:NSCalendarUnit = .CalendarUnitDay
        
        var days: Int
        let date1: NSDate = self.getDateFromString(strDate: fromDate)
        let date2: NSDate = self.getDateFromString(strDate: toDate)
        
        // *** define calendar components to use as well Timezone to UTC ***
        //let unitFlags = Set<Calendar.Component>([.hour, .year, .minute])
        //calendar.timeZone = TimeZone(identifier: "UTC")!
        
        let components = cal.dateComponents([.year, .month, .day, .hour, .minute], from: date1 as Date, to: date2 as Date)
        days = components.day!
        return days
    }
    
    
    func currentDate() -> String {
        let components: NSDateComponents = NSCalendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: Date()) as NSDateComponents //dateComponents([.Day, .Month, .Year], fromDate: NSDate())
        let day: Int = components.day
        let month: Int = components.month
        let year: Int = components.year
        return "\(Int(day)).\(Int(month)).\(Int(year))"
    }
    
    
    
    func getMonthNum(strMonth: String) -> Int {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "MMM"
        let aDate: NSDate = formatter.date(from: strMonth)! as NSDate
        let components: NSDateComponents = NSCalendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: aDate as Date) as NSDateComponents
        /* => 7 */
        return components.month
    }
    
    
    
    func getDateFromString(strDate: String) -> NSDate {
        let df: DateFormatter = DateFormatter()
        df.dateFormat = "dd.MM.yyyy"
        var date: NSDate = NSDate()
        date = df.date(from: strDate)! as NSDate
        return date
    }
    
    
    
    func convertDate(dateStr: String, sendingFormat: String, receiveFormat: String) -> String {
        // Convert string to date object
        let dateFormat: DateFormatter = DateFormatter()
        dateFormat.dateFormat = sendingFormat
        let date: NSDate = dateFormat.date(from: dateStr)! as NSDate
        let dateToFormat: DateFormatter = DateFormatter()
        dateToFormat.dateFormat = receiveFormat
        return dateToFormat.string(from: date as Date)
    }
    
    func convertStringToDate(dateStr: String, sendingFormat: String, receiveFormat: String) -> NSDate {
        // Convert string to date object
        let dateFormat: DateFormatter = DateFormatter()
        dateFormat.dateFormat = sendingFormat
        let date: NSDate = dateFormat.date(from: dateStr)! as NSDate
        return date
    }
    
    func dateFromMiliseconds(miliseconds: Double) -> NSDate {
        let foo: TimeInterval = miliseconds / 1000
        let theDate = NSDate(timeIntervalSince1970: foo)
        return theDate
    }
    
    //MARK:- ------ Validations on textfield ------
    
    func validations(fieldsText: [AnyObject]) -> Bool {
        for j in 0 ..< fieldsText.count {
            let str: String = fieldsText[j] as! String
            if (str == "") {
                return false
            }
        }
        return true
    }
    
    func validationsWithField(fields: [UITextField]) -> (Bool, String) {
        for j in 0 ..< fields.count {
            let txtField: UITextField = fields[j]
            let str: String = txtField.text!
            let placeholder: String = txtField.placeholder!
            if (str == "") {
                return (false, placeholder)
            }
        }
        return (true, "")
    }
    
    
    func validateEmailWithString(email: String) -> Bool {
        let emailRegex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    //MARK:- ------ Show Alert ------
    func showAlert(title: String, forMsg Message: String) {
        let alert: UIAlertView = UIAlertView(title: title, message: Message, delegate: nil, cancelButtonTitle: nil , otherButtonTitles: "OK")
        alert.show()
    }
    
    
    func showToast(strMsg: String) {
        let message: String = strMsg
        
        let toast = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let dispatchTime = DispatchTime.now() + DispatchTimeInterval.seconds(2)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            toast.dismiss(animated: true, completion: nil)
        }
        kAppDelegate.window?.rootViewController?.present(toast, animated: true, completion: nil)
    }
    
    
    func isStrEmpty(str: String) -> Bool {
        if str.isEmpty == true || str.characters.count == 0 || (str == "(null)") || (str == "") {
            return true
        }
        return false
    }
    
    
    func useText(strText: String) -> String {
        return self.isStrEmpty(str: strText) ? "" : strText
    }
    
    func makeString(string: AnyObject) -> String {
        return string as! String
        
    }
    
    //MARK:- Parse Dictionaries
    
    func getDictKeysValues(dataArray: NSDictionary) -> Array<String> {
        
        
        var arrValues: Array<String> = []
        
        
        for (key, value) in dataArray {
            print("Property: \"\(key as! String)\"")
            let strError: String = String(format: "%@ : %@", key as! String, value as! String)
            
            arrValues.append(strError)
        }
        
        return arrValues
    }
    
    func getDictValueForKey(dataArray: NSDictionary, compareKey: String) -> Array<String> {
        
        var arrValues: Array<String> = []
        
        
        for (key, value) in dataArray {
            
            if key as! String == compareKey {
                
                if value is String {
                    let strError: String = String(format: "%@", value as! String)
                    arrValues.append(strError)
                }
                else if value is NSArray {
                    let vals: NSArray = value as! NSArray
                    arrValues = vals as! Array<String>
                }
            }
            
        }
        
        return arrValues
    }
    
    func getDictKeys(dataArray: NSDictionary) -> Array<String> {
        
        
        var arrValues: Array<String> = []
        
        
        for (key, _) in dataArray {
            print("Property: \"\(key as! String)\"")
            let strError: String = String(format: "%@", key as! String)
            
            arrValues.append(strError)
        }
        
        return arrValues
    }
    
    func getDictValues(dataArray: NSDictionary) -> Array<String> {
        
        
        var arrValues: Array<String> = []
        
        
        for (key, value) in dataArray {
            print("Property: \"\(key as! String)\"")
            let strError: String = String(format: "%@", value as! String)
            
            arrValues.append(strError)
        }
        
        return arrValues
    }
    
    //MARK:- ------ Save data in user defaults ------
    
    func saveUserInfo(dictData: Dictionary<String, AnyObject>, forKey key: String) -> Bool {
        let defaults: UserDefaults = UserDefaults.standard
        defaults .set(dictData, forKey: key)
        defaults.synchronize()
        return true
    }
    
    func saveStringForKey(strData: String, forKey key: String) -> Bool {
        UserDefaults.standard.set(strData, forKey: key)
        UserDefaults.standard.synchronize()
        return true
    }
    
    func saveArrayToDefaults(placesArray: NSMutableArray, key: String) -> Void {
        let placesData = NSKeyedArchiver.archivedData(withRootObject: placesArray)
        UserDefaults.standard.set(placesData, forKey: key)

    }
    
    func saveDictToDefaults(placesArray: Dictionary<String, Any>, key: String) -> Void {
        let placesData = NSKeyedArchiver.archivedData(withRootObject: placesArray)
        UserDefaults.standard.set(placesData, forKey: key)
        
    }
    
    //MARK: ------ Retrieve data from user defaults ------
    
    func getArrayFromDefaults(key: String) -> NSMutableArray {
        let defaultsView: UserDefaults = UserDefaults.standard
        
        
        
        if defaultsView.object(forKey: key) != nil {
            let placesData = defaultsView.object(forKey: key) as? NSData
            let placesArray = NSKeyedUnarchiver.unarchiveObject(with: placesData! as Data) as? NSMutableArray
            return placesArray!
        }
        return NSMutableArray()
        
    }
    
    func getDictFromDefaults(key: String) -> Dictionary<String, Any> {
        let defaultsView: UserDefaults = UserDefaults.standard
        
        
        
        if defaultsView.object(forKey: key) != nil {
            let placesData = defaultsView.object(forKey: key) as? NSData
            let placesArray = NSKeyedUnarchiver.unarchiveObject(with: placesData as! Data) as? Dictionary<String, Any>
            return placesArray!
        }
        return [:]
        
    }
    
    
    func getUserInfo(key: String) -> NSMutableDictionary {
        let defaultsView: UserDefaults = UserDefaults.standard
        if defaultsView.object(forKey: key) != nil {
            let dictData: NSMutableDictionary = defaultsView.object(forKey: key) as! NSMutableDictionary
            return dictData
        }
        let dictData: NSMutableDictionary = [:]
        return dictData
    }
    
    func getUserStringFOrKey(key: String) -> String {
        let defaultsView: UserDefaults = UserDefaults.standard
        if defaultsView.object(forKey: key) != nil {
            let returnValue = defaultsView.object(forKey: key) as! String
            return returnValue
        }
        return ""
    }
    
    
    //MARK: ------ removeUserDefaults ------
    func removeUserDefaults(key: String) {
        let defaults: UserDefaults = UserDefaults.standard
        defaults.removeObject(forKey: key)
        defaults.synchronize()
    }
    
    
    
    
    //MARK:- ------ Detect device ------
    func detectDevice() -> String {
        var deviceType: String
        var height: CGFloat
        height = UIScreen.main.bounds.size.height
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            if height == 568.0 {
                //iPhone5s
                deviceType = "iPhone5s"
            }
            else if height == 667.0 {
                //iphone 6
                deviceType = "iPhone6"
            }
            else if height == 736.0 {
                //iphone 6 plus
                deviceType = "iPhone6Plus"
            }
            else if height > 736.0 {
                //iphone 6 plus
                deviceType = "iPhone6PlusPlus"
            }
            else {
                //iphone 3.5 inch screen
                deviceType = "iPhone4"
            }
        }
        else {
            //ipad
            deviceType = "iPad"
        }
        return deviceType
    }
    
    
    //MARK: ------ Get device Info ------
    func GetDeviceInfo() -> [String : String] {
        
        let device_Info: String = UIDevice.current.modelName
        let strModel = UIDevice.current.model //// e.g. @"iPhone", @"iPod touch"
        let strVersion = UIDevice.current.systemVersion // e.g. @"4.0"
        let strDevID = UIDevice.current.identifierForVendor?.uuidString
        
        let tempDict: [String : String] = ["device_version" : device_Info,
                                           "device_type" : strModel,
                                           "os_version" : strVersion,
                                           "device_id" : strDevID!,
                                           ]
        return tempDict
    }
    
    
}

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}


public extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
