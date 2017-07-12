//
//  EditProfileViewController.swift
//  Turnstr
//
//  Created by Mr X on 27/06/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit

class EditProfileViewController: ParentViewController, UITableViewDelegate, UITableViewDataSource, EditProfileHeaderDelegate {
    
    var tblMainTable: UITableView?
    var objHeader: EditProfileHeader?
    var showBack: showBack = .no
    
    
    var txtName = UITextField()
    var txtUserName = UITextField()
    var txtWeb = UITextField()
    var txtBio = IQTextView()
    var txtMail = UITextField()
    var txtPhone = UITextField()
    var lblOnline = UILabel()
    var lblContactMe = UILabel()
    var swtOnline = UISwitch()
    var btnContactMe = UIButton()
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = kLightGray
        
        /*
         * Navigation Bar
         */
        let uvNavBar = MenuBar.init(frame: self.view.frame)
        self.view.addSubview(uvNavBar)
        objNav.navTitle(title: "Edit Profile", inView: uvNavBar)
        objNav.lblTitle.textColor = kBlueColor
        uvNavBar.addSubview(objNav.rightButton(title: "Done"))
        objNav.btnRightMenu.setTitleColor(kBlueColor, for: .normal)
        
        objNav.btnRightMenu.addTarget(self, action: #selector(DoneClicked(sender:)), for: .touchUpInside)
        
        if showBack == .yes {
            uvNavBar.addSubview(objNav.backButonMenu())
            objNav.btnBack.setTitle("Cancel", for: .normal)
            objNav.btnBack.setTitleColor(kBlueColor, for: .normal)
            objNav.btnBack.addTarget(self, action: #selector(goBack), for: .touchUpInside)
            
        }
        createTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Prefill DATA
    
    func PrefillData() -> Void {
        txtName.text = objSing.strUserName
        txtUserName.text = objSing.strUserName
        txtWeb.text = objSing.strUserWebsite
        txtBio.text = objSing.strUserBio
        txtMail.text = objSing.strUserEmail
        txtPhone.text = objSing.strUserPhone
        
        swtOnline.isOn = objSing.strUserOnline
        
        if objSing.strUserContactMe == "" {
            btnContactMe.setTitle("All", for: .normal)
        }
        else{
            btnContactMe.setTitle("\(objSing.strUserContactMe)", for: .normal)
        }
        
        
        objHeader?.arrImageUrls.append(objSing.strUserPic1)
        objHeader?.arrImageUrls.append(objSing.strUserPic2)
        objHeader?.arrImageUrls.append(objSing.strUserPic3)
        objHeader?.arrImageUrls.append(objSing.strUserPic4)
        objHeader?.arrImageUrls.append(objSing.strUserPic5)
        objHeader?.arrImageUrls.append(objSing.strUserPic6)
        
        
        objHeader?.uvCollectionView.reloadData()
    }
    
    //MARK:- Table View
    func createTableView() -> Void {
        
        btnContactMe.setTitle("All", for: .normal)
        
        tblMainTable = UITableView.init(frame: CGRect.init(x: 0, y: kNavBarHeight, width: kWidth, height: kHeight-kNavBarHeight), style: .grouped)
        tblMainTable?.delegate = self
        tblMainTable?.dataSource = self
        tblMainTable?.backgroundColor = kLightGray
        tblMainTable?.separatorColor = krgbClear
        self.view.addSubview(tblMainTable!)
        
        PrefillData()
    }
    
    //MARK:**********************************************************************************
    //MARK: TableView Data Source
    //MARK:**********************************************************************************
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        switch section {
        case 0:
            return 4
        default:
            break
        }
        return 2
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return sectionHeight(section: section)
    }
    
    func sectionHeight(section: Int) -> CGFloat {
        switch section {
        case 0:
            return 240
        case 1:
            return 5
        case 2:
            return 5
        default:
            break
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return rowHeight(indexPath: indexPath as NSIndexPath)
    }
    
    func rowHeight(indexPath: NSIndexPath) -> CGFloat
    {
        switch indexPath.section {
        case 0:
            if indexPath.row == 3 {
                return 120
            }
        default:
            break
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let identifier = "Cell"
        var cell: EditProfileCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? EditProfileCell
        if cell == nil {
            tableView.register(UINib(nibName: "EditProfileCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? EditProfileCell
        }
        
        let frame: CGRect = CGRect.init(x: 5, y: 5, width: kWidth-60, height: rowHeight(indexPath: indexPath as NSIndexPath)-10)
        let font = UIFont.systemFont(ofSize: 14.0)
        
        cell.imgPic.isHidden = false
        cell.uvSeparator.isHidden = false
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                cell?.imgPic?.image = #imageLiteral(resourceName: "ic_id")
                txtName.frame = frame
                txtName.placeholder = "Full Name"
                txtName.textColor = kOrangeColor
                txtName.font = font
                cell.uvContent.addSubview(txtName)
            case 1:
                cell?.imgPic?.image = #imageLiteral(resourceName: "ic_user")
                txtUserName.frame = frame
                txtUserName.placeholder = "User Name"
                txtUserName.textColor = kOrangeColor
                txtUserName.font = font
                cell.uvContent.addSubview(txtUserName)
            case 2:
                cell?.imgPic?.image = #imageLiteral(resourceName: "ic_web")
                txtWeb.frame = frame
                txtWeb.placeholder = "Website"
                txtWeb.textColor = kBlueColor
                txtWeb.font = font
                cell.uvContent.addSubview(txtWeb)
            case 3:
                cell?.imgPic?.image = #imageLiteral(resourceName: "ic_info")
                txtBio.frame = frame
                txtBio.placeholder = "About you"
                txtBio.textColor = kOrangeColor
                txtBio.font = font
                cell.uvContent.addSubview(txtBio)
                cell.contentView.addSubview(objUtil.createView(xCo: 0, forY: rowHeight(indexPath: indexPath as NSIndexPath)-2, forW: kWidth, forH: 2, backColor: kSeperatorColor))
            default:
                break
            }
            
        }
        else if indexPath.section == 1 {
            cell.uvSeparator.isHidden = true
            let font1 = UIFont.boldSystemFont(ofSize: 13.0)
            
            switch indexPath.row {
            case 0:
                cell.imgPic.isHidden = true
                lblOnline.frame = CGRect.init(x: 8, y: 0, width: 60, height: rowHeight(indexPath: indexPath as NSIndexPath))
                lblOnline.text = "Online"
                lblOnline.textColor = kBlueColor
                lblOnline.font = font1
                cell.contentView.addSubview(lblOnline)
                
                
                //
                //Switch for online offline
                //
                swtOnline.frame = CGRect.init(x: frame.width-60, y: 15, width: 40, height: 25)
                swtOnline.tintColor = kBlueColor
                swtOnline.onTintColor = kBlueColor
                cell.uvContent.addSubview(swtOnline)
                
                
            case 1:
                cell.imgPic.isHidden = true
                lblContactMe.frame = CGRect.init(x: 8, y: 0, width: 80, height: rowHeight(indexPath: indexPath as NSIndexPath))
                lblContactMe.text = "Contact Me"
                lblContactMe.textColor = kBlueColor
                lblContactMe.font = font1
                cell.contentView.addSubview(lblContactMe)
                
                //
                //Contact me label
                //
                btnContactMe.frame = CGRect.init(x: frame.width-120, y: 0, width: 115, height: rowHeight(indexPath: indexPath as NSIndexPath))
                btnContactMe.setTitleColor(kBlueColor, for: .normal)
                btnContactMe.setImage(#imageLiteral(resourceName: "blue_arrow"), for: .normal)
                btnContactMe.semanticContentAttribute = .forceRightToLeft
                btnContactMe.contentHorizontalAlignment = .right
                btnContactMe.titleLabel?.font = font1
                btnContactMe.isEnabled = false
                cell.uvContent.addSubview(btnContactMe)
                
                cell.contentView.addSubview(objUtil.createView(xCo: 0, forY: rowHeight(indexPath: indexPath as NSIndexPath)-2, forW: kWidth, forH: 2, backColor: kSeperatorColor))
            default:
                break
            }
            
        }
        else if indexPath.section == 2 {
            switch indexPath.row {
            case 0:
                cell?.imgPic?.image = #imageLiteral(resourceName: "ic_mail")
                txtMail.frame = frame
                txtMail.placeholder = "Email"
                txtMail.textColor = kOrangeColor
                txtMail.font = font
                txtMail.keyboardType = .emailAddress
                cell.uvContent.addSubview(txtMail)
            case 1:
                cell?.imgPic?.image = #imageLiteral(resourceName: "ic_phone")
                txtPhone.frame = frame
                txtPhone.placeholder = "Phone Number"
                txtPhone.textColor = kOrangeColor
                txtPhone.font = font
                txtPhone.keyboardType = .phonePad
                cell.uvContent.addSubview(txtPhone)
                cell.contentView.addSubview(objUtil.createView(xCo: 0, forY: rowHeight(indexPath: indexPath as NSIndexPath)-2, forW: kWidth, forH: 2, backColor: kSeperatorColor))
            default:
                break
            }
            
            
        }
        
        
        
        cell.selectionStyle = .none
        return cell!
        
    }
    
    //MARK:- Header Footer of Table
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if section == 0 {
            
            if objHeader == nil {
                objHeader = EditProfileHeader.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: sectionHeight(section: section)))
                objHeader?.delegateEditHeader = self
                objHeader?.btnChangePhoto.addTarget(self, action: #selector(ChangeProfilePhoto(sender:)), for: .touchUpInside)
            }
            
            return objHeader
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?{
        return UIView()
    }
    
    
    //MARK:- TableView Delegate Methods
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        
        IQKeyboardDismiss()
        
        if indexPath.section == 1 {
            switch indexPath.section {
            case 1:
                LoadPickerView()
                pickerView.lblHEading.text = "Who Can Conatact Me?"
                pickerView.lblHEading.textColor = kBlueColor
                pickerView.lblHEading.backgroundColor = kLightGray
                pickerView.arrRows = ["All", "Family", "Friends"]
                pickerView.loadPIcker()
            default:
                break
            }
        }
    }
    
    //MARK:- ACtion Methods
    
    func DoneClicked(sender: UIButton) -> Void {
        
        IQKeyboardDismiss()
        
        let (status, field) = objUtil.validationsWithField(fields: [txtName, txtUserName, txtWeb, txtMail, txtPhone])
        
        if status == false {
            objUtil.showToast(strMsg: "Please enter "+field)
            return
        }
        
        if txtMail.text?.isEmail == false {
            objUtil.showToast(strMsg: "Please enter a valid email")
            return
        }
        
        if (objHeader?.arrImage.count)! < 6 {
            objUtil.showToast(strMsg: "Please choose six profile Images.")
            return
        }
        
        kAppDelegate.loadingIndicationCreationMSG(msg: "Saving...")
        APIRequest(sType: kAPIUpdateProfile, data: [:])
    }
    
    func ChangeProfilePhoto(sender: UIButton) -> Void {
        
        IQKeyboardDismiss()
        
        CameraImage.shared.captureImage(from: self, captureOptions: [.camera, .photoLibrary], allowEditting: true, fromView: sender) {[weak self] (image) in
            if image != nil {
                
                if (self?.objHeader?.arrImage.count)! < 6 {
                    self?.objHeader?.arrImage.append(image!)
                    self?.objHeader?.uvCollectionView.reloadData()
                }
                
            }
        }
        
    }
    
    func UvCollectionViewDidSelectRow(collectionView: UICollectionView, selectedINdex: Int) {
        
        IQKeyboardDismiss()
        
        let alertController = UIAlertController(title: "Choose Action", message: "", preferredStyle: .actionSheet)
        
        let sendButton = UIAlertAction(title: "Edit", style: .default, handler: { (action) -> Void in
            
            CameraImage.shared.captureImage(from: self, captureOptions: [.camera, .photoLibrary], allowEditting: true, fromView: self.objHeader?.btnChangePhoto) {[weak self] (image) in
                if image != nil {
                    
                    self?.objHeader?.arrImage.remove(at: selectedINdex)
                    self?.objHeader?.arrImage.insert(image!, at: selectedINdex)
                    self?.objHeader?.uvCollectionView.reloadData()
                    
                }
            }
            
        })
        
        let  deleteButton = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
            self.objHeader?.arrImage.remove(at: selectedINdex)
            self.objHeader?.uvCollectionView.reloadData()
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        
        
        alertController.addAction(sendButton)
        alertController.addAction(deleteButton)
        alertController.addAction(cancelButton)
        
        self.navigationController!.present(alertController, animated: true, completion: nil)
    }
    
    //
    //MARK:- PickerView Delegates
    //
    override func MyPIckerViewdidselectRow(controller: PickerView, selectedINdex: Int) {
        btnContactMe.setTitle(pickerView.arrRows[selectedINdex] as? String, for: .normal)
        pickerView = nil
    }
    
    
    //MARK:- APIS Handling
    
    func APIRequest(sType: String, data: Dictionary<String, Any>) -> Void {
        
        if kAppDelegate.checkNetworkStatus() == false {
            kAppDelegate.hideLoadingIndicator()
            return
        }
        
        DispatchQueue.global().async {
            
            if sType == kAPIUpdateProfile {
                let dictAction: NSDictionary = [
                    "action": kAPIUpdateProfile,
                    "user[username]": "\(self.txtUserName.text!)",
                    "user[first_name]": "\(self.txtName.text!)",
                    "user[website]" : "\(self.txtWeb.text!)",
                    "user[bio]" : "\(self.txtBio.text!)",
                    "user[email]" : "\(self.txtMail.text!)",
                    "user[online]" : self.swtOnline.isOn == true ? "true" : "false",
                    "user[phone]" : "\(self.txtPhone.text!)",
                    "user[contact_me]" : "All"
                    
                ]
                
                let arrResponse = self.objDataS.uploadFilesToServer(dictAction: dictAction, arrImages: (self.objHeader?.arrImage)!)
                
                if (arrResponse.count) > 0 {
                    DispatchQueue.main.async {
                        
                        self.objDataS.saveLoginData(data: arrResponse)
                        if self.objDataS.isLoginData() == true {
                            self.LoadHomeScreen()
                        }
                        
                        self.objUtil.showToast(strMsg: "User updated successfully")
                        
                        
                        kAppDelegate.hideLoadingIndicator()
                    }
                }
            }
            
        }
        
        
    }
    
    
}
