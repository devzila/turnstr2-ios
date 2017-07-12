//
//  CameraViewController.swift
//  Turnstr
//
//  Created by Mr X on 08/07/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit
import Photos


class CameraViewController: ParentViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    var uvContent = UIView()
    var selectedTab: Int = 1
    
    var library: PHPhotoLibrary?
    var photoArray : [UIImage] = []
    var arrSelectedImages: [UIImage] = []
    
    
    var uvCollectionView: UICollectionView?
    var flowLayout: UICollectionViewFlowLayout?
    
    @IBOutlet weak var btnLibrary: UIButton!
    @IBOutlet weak var btnPhotos: UIButton!
    @IBOutlet weak var btnVideos: UIButton!
    
    
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    
    var btnCross1 = UIButton()
    var btnCross2 = UIButton()
    var btnCross3 = UIButton()
    var btnCross4 = UIButton()
    
    @IBOutlet weak var uvImages: UIView!
    var uvPopUP: NewStoryPopUp?
    var objPopupAlert:CustomAlertView?
    var uvCamera: CameraView?
    var uvVideo: VideoView?
    
    
    
    
    
    //MARK:- View Life Cycle
    
    override func viewDidLayoutSubviews() {
        SetCrossButtons()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*
         * Navigation Bar
         */
        LoadNavBar()
        objNav.btnBack.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        objNav.btnRightMenu.setImage(nil, for: .normal)
        objNav.btnRightMenu.setTitle("NEXT", for: .normal)
        objUtil.setFrames(xCo: kWidth-50, yCo: kNavBarHeightWithLogo-40, width: 45, height: 40, view: objNav.btnRightMenu)
        objNav.btnRightMenu.addTarget(self, action: #selector(nextClicked), for: .touchUpInside)
        
        
        //
        //Content View Center
        //
        uvContent.frame = CGRect.init(x: 0, y: kNavBarHeightWithLogo, width: kWidth, height: kHeight-kNavBarHeightWithLogo-40-75)
        uvContent.backgroundColor = UIColor.black
        self.view.addSubview(uvContent)
        
        createCollectionView()
        
        HideCrossButtons()
        getAllPhotos()
        
        createCameraView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Create Custom Views
    
    func createCameraView() -> Void {
        
        if uvCamera == nil {
            uvCamera = CameraView.init(frame: uvContent.frame)
        }
        uvCamera?.isHidden = true
        uvContent.addSubview(uvCamera!)
        
        
        //if uvVideo == nil {
            //uvVideo = VideoView.init(frame: uvContent.frame)
        //}
        //uvVideo?.isHidden = true
        //uvContent.addSubview(uvVideo!)
    }
    //MARK:- Set selected Images
    
    func reloadSelectedImages() -> Void {
        
        LoadPlaceHolders()
        let arrImg: [UIImageView] = [img1, img2, img3, img4]
        let arrBtns: [UIButton] = [btnCross1, btnCross2, btnCross3, btnCross4]
        var j=0
       
        for image in arrSelectedImages {
            
            let imgV = arrImg[j]
            imgV.image = image
            
            let btn = arrBtns[j]
            btn.isHidden = false
            j = j+1
        }
    }
    
    func LoadPlaceHolders() -> Void {
        let arrImg: [UIImageView] = [img1, img2, img3, img4]
        let arrBtns: [UIButton] = [btnCross1, btnCross2, btnCross3, btnCross4]
        var j=0
        
        for imgV in arrImg {
            imgV.image = #imageLiteral(resourceName: "placeholder_1")
            let btn = arrBtns[j]
            btn.isHidden = true
            j = j+1
        }
    }
    
    //MARK:- Set next Popup
    
    func NextPopUp() -> Void {
        
        if uvPopUP == nil {
            uvPopUP = NewStoryPopUp.init(frame: CGRect.init(x: 0, y: 0, width: 310, height: 220))
            uvPopUP?.btnCancel.addTarget(self, action: #selector(PopupCancel(sender:)), for: .touchUpInside)
            uvPopUP?.btnNext.addTarget(self, action: #selector(PopupNext(sender:)), for: .touchUpInside)
        }
        
        uvPopUP?.arrMedia = arrSelectedImages
        uvPopUP?.setCube()
        
        if objPopupAlert == nil {
            objPopupAlert = CustomAlertView()
            objPopupAlert!.delegate = self
        }
        
        
        // Set a custom container view
        objPopupAlert!.containerView = uvPopUP
        // Set self as the delegate
        
        
        objPopupAlert?.showCloseButton = false
        objPopupAlert!.alertBGColor = ["#FFFFFF", "#FFFFFF"]
        objPopupAlert?.buttonTitles = []
        objPopupAlert?.buttonHeight = 0
        // Or, use a closure
        //alertView.onButtonTouchUpInside = { (alertView: CustomAlertView, buttonIndex: Int) -> Void in
        //}
        
        objPopupAlert!.show()
        
    }
    
    func PopupCancel(sender: UIButton) -> Void {
        objPopupAlert?.close()
        uvPopUP = nil
    }
    
    func PopupNext(sender: UIButton) -> Void {
        objPopupAlert?.close()
        
        kAppDelegate.loadingIndicationCreation()
        APIRequest(sType: kAPIPOSTStories, data: [:])
    }
    
    //MARK:- Set Delete Buttons
    
    func SetCrossButtons() -> Void {
        btnCross1.frame = CGRect.init(x: img1.frame.maxX-30, y: 0, width: 30, height: 30)
        btnCross1.setImage(#imageLiteral(resourceName: "close_1"), for: .normal)
        btnCross1.tag = 0
        btnCross1.addTarget(self, action: #selector(DeleteImage(sender:)), for: .touchUpInside)
        uvImages.addSubview(btnCross1)
        
        btnCross2.frame = CGRect.init(x: img2.frame.maxX-30, y: 0, width: 30, height: 30)
        btnCross2.setImage(#imageLiteral(resourceName: "close_1"), for: .normal)
        uvImages.addSubview(btnCross2)
        btnCross2.tag = 1
        btnCross2.addTarget(self, action: #selector(DeleteImage(sender:)), for: .touchUpInside)
        
        
        btnCross3.frame = CGRect.init(x: img3.frame.maxX-30, y: 0, width: 30, height: 30)
        btnCross3.setImage(#imageLiteral(resourceName: "close_1"), for: .normal)
        uvImages.addSubview(btnCross3)
        btnCross3.tag = 2
        btnCross3.addTarget(self, action: #selector(DeleteImage(sender:)), for: .touchUpInside)
        
        
        btnCross4.frame = CGRect.init(x: img4.frame.maxX-30, y: 0, width: 30, height: 30)
        btnCross4.setImage(#imageLiteral(resourceName: "close_1"), for: .normal)
        uvImages.addSubview(btnCross4)
        btnCross4.tag = 3
        btnCross4.addTarget(self, action: #selector(DeleteImage(sender:)), for: .touchUpInside)
        
    }
    
    func HideCrossButtons() -> Void {
        btnCross1.isHidden = true
        btnCross2.isHidden = true
        btnCross3.isHidden = true
        btnCross4.isHidden = true
    }

    
    // MARK: - Action Methods

    @IBAction func LibraryClicked(_ sender: UIButton) {
        selectedTab = 1
        TabHandling()
        uvCollectionView?.isHidden = false
        
        uvCamera?.isHidden = true
        uvVideo?.isHidden = true
    }
    @IBAction func PhotosClicked(_ sender: UIButton) {
        selectedTab = 2
        TabHandling()
        uvCollectionView?.isHidden = true
        
        uvCamera?.isHidden = false
        uvVideo?.isHidden = true
        
    }
    @IBAction func VideosClicked(_ sender: UIButton) {
        selectedTab = 3
        TabHandling()
        uvCollectionView?.isHidden = true
        
        uvCamera?.isHidden = true
        uvVideo?.isHidden = false
    }
    
    func TabHandling() {
        
        let arrButtons: [UIButton] = [btnLibrary, btnPhotos, btnVideos]
        
        for var i in 0..<3 {
            let btn = arrButtons[i]
            if i == selectedTab-1 {
                btn.isSelected = true
            }
            else{
                btn.isSelected = false
            }
        }
    }
    
    func DeleteImage(sender: UIButton) -> Void {
        arrSelectedImages.remove(at: sender.tag)
        reloadSelectedImages()
    }
    
    func nextClicked() -> Void {
        if arrSelectedImages.count != 4 {
            return
        }
        
        NextPopUp()
    }
    
    
    
    
    //MARK:- Collection Grid for Library Setup
    
    func createCollectionView() -> Void {
        
        if flowLayout == nil {
            flowLayout = UICollectionViewFlowLayout.init()
            flowLayout?.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
            flowLayout?.itemSize = PhotoSize()
            
        }
        
        if uvCollectionView == nil {
            uvCollectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: uvContent.frame.height), collectionViewLayout: flowLayout!)
            uvCollectionView?.dataSource = self
            uvCollectionView?.delegate = self
            uvCollectionView?.backgroundColor = UIColor.white
            uvContent.addSubview(uvCollectionView!)
            uvCollectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        }
        
    }
    
    func PhotoSize() -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.photoArray.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        cell.backgroundColor = UIColor.init("F3F3F3")
        
        let frame: CGRect = CGRect.init(x: 0, y: 0, width: PhotoSize().width, height: PhotoSize().height)
        
        
        var imgBigImage = cell.contentView.viewWithTag(-111) as? UIImageView
        if imgBigImage == nil {
            imgBigImage = UIImageView.init(frame: frame)
            imgBigImage?.tag = -111
            imgBigImage?.contentMode = .scaleToFill
            
        }
        imgBigImage?.image = nil
        cell.contentView.addSubview(imgBigImage!)
       
        imgBigImage?.image = photoArray[indexPath.item]
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if arrSelectedImages.count == 4 {
            objUtil.showToast(strMsg: "You can select maximum four files")
        }
        else{
            arrSelectedImages.append(photoArray[indexPath.item])
            reloadSelectedImages()
        }
    }
    
    //MARK:- Get All Photos From Library
    
    func getAllPhotos() -> Void {
        
        self.objLoader.start(inView: self.view)
        
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status
            {
            case .authorized:
                print("Good to proceed")
                
                DispatchQueue.main.async {
                    let allPhotosOptions = PHFetchOptions()
                    allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
                    
                    let allPhotosResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: allPhotosOptions)
                    let totalImages = allPhotosResult.count
                    
                    // Now if you want you can get assets from the PHFetchResult object:
                    allPhotosResult.enumerateObjects({
                        self.photoArray.append(self.getAssetThumbnail(asset: $0.0))
                        self.uvCollectionView?.reloadData()
                        if self.photoArray.count == totalImages {
                            self.objLoader.stop()
                        }
                    })
                }
            case .denied, .restricted:
                print("Not allowed")
                self.objLoader.stop()
            case .notDetermined:
                print("Not determined yet")
                self.objLoader.stop()
            }
        }
    }
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }

    
    //MARK:- APIS Handling
    
    func APIRequest(sType: String, data: Dictionary<String, Any>) -> Void {
        
        if kAppDelegate.checkNetworkStatus() == false {
            kAppDelegate.hideLoadingIndicator()
            return
        }
        
        DispatchQueue.global().async {
            
            if sType == kAPIPOSTStories {
                let dictAction: NSDictionary = [
                    "action": kAPIPOSTStories,
                    "story[caption]": "\(self.uvPopUP?.ttxtCaption.text)",
                    "story[likes_count]" : "0"
                    
                ]
                
                let arrResponse = self.objDataS.uploadFilesToServer(dictAction: dictAction, arrImages: self.arrSelectedImages)
                
                if (arrResponse.count) > 0 {
                    DispatchQueue.main.async {
                        
                        self.objUtil.showToast(strMsg: "Story created successfully")
                        self.uvPopUP = nil
                        
                        kAppDelegate.hideLoadingIndicator()
                    }
                }
            }
            
        }
        
        
    }

    
}
