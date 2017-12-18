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
    
    
    var txtFName = UITextField()
    var txtLName = UITextField()
    var txtUserName = UITextField()
    var txtWeb = UITextField()
    var txtBio = IQTextView()
    var txtMail = UITextField()
    var txtPhone = UITextField()
    var txtAddress = UITextField()
    
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
        objNav.lblTitle.font = UIFont.boldSystemFont(ofSize: 16.0)
        objNav.lblTitle.textColor = kBlueColor
        uvNavBar.addSubview(objNav.rightButton(title: "Done"))
        objNav.btnRightMenu.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        objNav.btnRightMenu.setTitleColor(kBlueColor, for: .normal)
        
        objNav.btnRightMenu.addTarget(self, action: #selector(DoneClicked(sender:)), for: .touchUpInside)
        
        if showBack == .yes {
            uvNavBar.addSubview(objNav.backButonMenu())
            objNav.btnBack.setTitle("Cancel", for: .normal)
            objNav.btnBack.setTitleColor(kBlueColor, for: .normal)
            objNav.btnBack.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
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
        txtFName.text = objSing.strUserFname
        txtLName.text = objSing.strUserLName
        txtUserName.text = objSing.strUserName
        txtWeb.text = objSing.strUserWebsite
        txtBio.text = objSing.strUserBio
        txtMail.text = objSing.strUserEmail
        txtPhone.text = objSing.strUserPhone
        txtAddress.text = objSing.address
        
        swtOnline.isOn = objSing.strUserOnline
        
        if objSing.strUserContactMe == "" {
            btnContactMe.setTitle("All", for: .normal)
        }
        else{
            btnContactMe.setTitle("\(objSing.strUserContactMe)", for: .normal)
        }
        
        PrefillImages()
        
    }
    
    func PrefillImages() {
        
        if objHeader != nil {
            let arrImgs = [objSing.strUserPic1, objSing.strUserPic2, objSing.strUserPic3, objSing.strUserPic4, objSing.strUserPic5, objSing.strUserPic6]
            
            for url in arrImgs {
                if url.isEmpty == false {
                    objHeader?.arrImageUrls.append(url)
                }
            }
            
            let transformView = AITransformView.init(frame: CGRect.init(x: 0, y: 0, width: 110, height: 88), cube_size: 70)
            transformView?.backgroundColor = UIColor.clear
            
            if (objHeader?.arrImageUrls.count)! > 0 {
                transformView?.setup(withUrls: objHeader?.arrImageUrls)
                
            }
            else{
                transformView?.setup(withUrls: ["", "", "", "", "", ""])
            }
            
            objHeader?.uvCube.addSubview(transformView!)
            transformView?.setScroll(CGPoint.init(x: 0, y: 88/2), end: CGPoint.init(x: 15, y: 88/2))
            transformView?.setScroll(CGPoint.init(x: 110/2, y: 0), end: CGPoint.init(x: 110/2, y: 1))
            
            objHeader?.uvCube.backgroundColor = UIColor.clear
            objHeader?.imgCube.isHidden = true
            
        }
        
        objHeader?.uvCollectionView.reloadData()
    }
    
    func SetFieldsSetting() -> Void {
        let font = UIFont.systemFont(ofSize: 14.0)
        
        txtFName.placeholder = "First Name"
        txtFName.textColor = kOrangeColor
        txtFName.font = font
        
        txtLName.placeholder = "Last Name"
        txtLName.textColor = kOrangeColor
        txtLName.font = font
        
        txtUserName.placeholder = "User Name"
        txtUserName.textColor = kOrangeColor
        txtUserName.font = font
        
        txtWeb.placeholder = "Website"
        txtWeb.textColor = kBlueColor
        txtWeb.font = font
        
        txtBio.placeholder = "About you"
        txtBio.textColor = kOrangeColor
        txtBio.font = font
        
        let font1 = UIFont.boldSystemFont(ofSize: 13.0)
        
        lblContactMe.text = "Contact Me"
        lblContactMe.textColor = kBlueColor
        lblContactMe.font = font1
        
        txtMail.placeholder = "Email"
        txtMail.textColor = kOrangeColor
        txtMail.font = font
        
        txtPhone.placeholder = "Phone Number"
        txtPhone.textColor = kOrangeColor
        txtPhone.font = font
        
        txtAddress.placeholder = "Address"
        txtAddress.textColor = kOrangeColor
        txtAddress.font = font
        
    }
    //MARK:- Table View
    func createTableView() -> Void {
        
        btnContactMe.setTitle("All", for: .normal)
        
        tblMainTable = UITableView.init(frame: CGRect.init(x: 0, y: kNavBarHeight, width: kWidth, height: kHeight-kNavBarHeight-40), style: .grouped)
        tblMainTable?.delegate = self
        tblMainTable?.dataSource = self
        tblMainTable?.backgroundColor = kLightGray
        tblMainTable?.separatorColor = krgbClear
        self.view.addSubview(tblMainTable!)
        
        SetFieldsSetting()
        
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
            return 5
        case 2:
            return 3
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
            if indexPath.row == 1 {
                txtLName.isHidden = true
                return 0
            }
            if indexPath.row == 4 {
                return 90
            }
        default:
            break
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let identifier = "Cell\(indexPath.section)_\(indexPath.row)"
        var cell: EditProfileCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? EditProfileCell
        if cell == nil {
            tableView.register(UINib(nibName: "EditProfileCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? EditProfileCell
        }
        
        let frame: CGRect = CGRect.init(x: 5, y: 5, width: kWidth-60, height: rowHeight(indexPath: indexPath as NSIndexPath)-10)
        
        cell.imgPic.isHidden = false
        cell.uvSeparator.isHidden = false
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                cell?.imgPic?.image = #imageLiteral(resourceName: "ic_id")
                txtFName.frame = frame
                cell.uvContent.addSubview(txtFName)
            case 1:
                //cell?.imgPic?.image = #imageLiteral(resourceName: "ic_id")
                //txtLName.frame = frame
                //cell.uvContent.addSubview(txtLName)
                break
            case 2:
                cell?.imgPic?.image = #imageLiteral(resourceName: "ic_user")
                txtUserName.frame = frame
                cell.uvContent.addSubview(txtUserName)
            case 3:
                cell?.imgPic?.image = #imageLiteral(resourceName: "ic_web")
                txtWeb.frame = frame
                txtWeb.autocapitalizationType = .none
                cell.uvContent.addSubview(txtWeb)
            case 4:
                cell?.imgPic?.image = #imageLiteral(resourceName: "ic_info")
                txtBio.frame = frame
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
                txtMail.keyboardType = .emailAddress
                cell.uvContent.addSubview(txtMail)
            case 1:
                cell?.imgPic?.image = #imageLiteral(resourceName: "ic_phone")
                txtPhone.frame = frame
                txtPhone.keyboardType = .phonePad
                cell.uvContent.addSubview(txtPhone)
                //cell.contentView.addSubview(objUtil.createView(xCo: 0, forY: rowHeight(indexPath: indexPath as NSIndexPath)-2, forW: kWidth, forH: 2, backColor: kSeperatorColor))
            case 2:
                cell?.imgPic?.image = #imageLiteral(resourceName: "ic_id")
                txtAddress.frame = frame
                cell.uvContent.addSubview(txtAddress)
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
                
                PrefillImages()
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
                pickerView.arrRows = ["Everyone", "Family", "Friends"]
                pickerView.loadPIcker()
            default:
                break
            }
        }
    }
    
    //MARK:- ACtion Methods
    
    func DoneClicked(sender: UIButton) -> Void {
        
        IQKeyboardDismiss()
        
        let (status, field) = objUtil.validationsWithField(fields: [txtFName, txtUserName, txtWeb, txtMail])
        
        if status == false {
            objUtil.showToast(strMsg: "Please enter "+field)
            return
        }
        
        if txtMail.text?.isEmail == false {
            objUtil.showToast(strMsg: "Please enter a valid email")
            return
        }
        
        //        if ((objHeader?.arrImage.count)! < 6) && ((objHeader?.arrImageUrls.count)! < 6) {
        //            objUtil.showToast(strMsg: "Please choose six profile Images.")
        //            return
        //        }
        //
        kAppDelegate.loadingIndicationCreationMSG(msg: "Saving")
        APIRequest(sType: kAPIUpdateProfile, data: [:])
    }
    
    func ChangeProfilePhoto(sender: UIButton) -> Void {
        
        IQKeyboardDismiss()
        
        if (objHeader?.arrImage.count)! > 5 {
            objUtil.showToast(strMsg: "You can upload maximum six Images.")
            return
        }
        
        CameraImage.shared.captureImage(from: self, captureOptions: [.camera, .photoLibrary], allowEditting: true, fileTypes: [.image]) {[weak self] (image, url) in
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
        
        if selectedINdex < (objHeader?.arrImage.count)! {
            //
            // Edit Old
            //
            
            let alertController = UIAlertController(title: "Choose Action", message: "", preferredStyle: .actionSheet)
            
            let sendButton = UIAlertAction(title: "Edit", style: .default, handler: { (action) -> Void in
                
                CameraImage.shared.captureImage(from: self, captureOptions: [.camera, .photoLibrary], allowEditting: true, fileTypes: [.image]) {[weak self] (image, url) in
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
        else{
            //
            // Insert new
            //
            
            
            CameraImage.shared.captureImage(from: self, captureOptions: [.camera, .photoLibrary], allowEditting: true, fileTypes: [.image]) {[weak self] (image, url) in
                if image != nil {
                    
                    self?.objHeader?.arrImage.append(image!)
                    self?.objHeader?.uvCollectionView.reloadData()
                    
                }
            }
        }
        
        
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
        
        if sType == kAPIUpdateProfile {
            
            let dictAction: NSDictionary = [
                "action": kAPIUpdateProfile,
                "user[username]": "\(self.txtUserName.text!)",
                "user[first_name]": "\(self.txtFName.text!)",
                "user[last_name]": " ",//"\(self.txtLName.text!)",
                "user[website]" : "\(self.txtWeb.text!)",
                "user[bio]" : "\(self.txtBio.text!)",
                "user[email]" : "\(self.txtMail.text!)",
                "user[online]" : self.swtOnline.isOn == true ? "true" : "false",
                "user[phone]" : "\(self.txtPhone.text!)",
                "user[address]" : "\(self.txtAddress.text ?? "")",
                "user[contact_me]" : self.btnContactMe.titleLabel?.text ?? "Everyone"
                
            ]
            
            DispatchQueue.global().async {
                
                let arrResponse = self.objDataS.uploadFilesToServer(dictAction: dictAction, arrImages: (self.objHeader?.arrImage)!)
                
                if (arrResponse.count) > 0 {
                    DispatchQueue.main.async {
                        
                        self.objDataS.saveLoginData(data: arrResponse)
                        if self.objDataS.isLoginData() == true {
                            self.goBack()
                        }
                        
                        self.objUtil.showToast(strMsg: "User updated successfully")
                        
                        
                        kAppDelegate.hideLoadingIndicator()
                    }
                }
                
            }
            
        }
        
        
    }
    
    
}
