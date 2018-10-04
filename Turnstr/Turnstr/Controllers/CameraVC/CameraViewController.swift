//
//  CameraViewController.swift
//  Turnstr
//
//  Created by Mr X on 08/07/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit
import Photos

enum controllerType {
    case newStory
    case myStory
}

class CameraViewController: ParentViewController, CameraViewDelegates, VideoDelegate, StoriesVCDelegate {
    
    var kScreenType: controllerType = .myStory
    
    //Library outlets
    var uvCollectionView: UICollectionView?
    var flowLayout: UICollectionViewFlowLayout?
    
    var fetchResult: PHFetchResult<PHAsset>!
    var smartAlbums: PHFetchResult<PHAssetCollection>!
    lazy var imageOption = PHImageRequestOptions()
    lazy var videoOption = PHVideoRequestOptions()
    fileprivate let imageManager = PHCachingImageManager()
    fileprivate var thumbnailSize: CGSize!
    fileprivate var previousPreheatRect = CGRect.zero
    
    
    //Others
    var uvContent = UIView()
    var selectedTab: Int = 1
    var arrSelectedImages = [NewStoryMedia]()
    
    
    
    @IBOutlet weak var btnLibrary: UIButton!
    @IBOutlet weak var btnPhotos: UIButton!
    @IBOutlet weak var btnVideos: UIButton!
    
    
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var img5: UIImageView!
    @IBOutlet weak var img6: UIImageView!
    
    var btnCross1 = UIButton()
    var btnCross2 = UIButton()
    var btnCross3 = UIButton()
    var btnCross4 = UIButton()
    var btnCross5 = UIButton()
    var btnCross6 = UIButton()
    
    @IBOutlet weak var uvImages: UIView!
    var uvPopUP: NewStoryPopUp?
    var objPopupAlert:CustomAlertView?
    var uvCamera: CameraView?
    var uvVideo: VideoView?
    
    
    @IBOutlet weak var uvImagesHeight: NSLayoutConstraint!
    
    
    
    //MARK:- View Life Cycle
    
    override func viewDidLayoutSubviews() {
        SetCrossButtons()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if kScreenType == .newStory {
            uvImagesHeight.constant = 0
            uvImages.layoutIfNeeded()
        }
        
        
        /*
         * Navigation Bar
         */
        LoadNavBar()
        objNav.btnBack.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        objNav.btnRightMenu.setImage(nil, for: .normal)
        if kScreenType == .newStory {
            objNav.btnRightMenu.isHidden = true
        } else {
            objNav.btnRightMenu.setTitle("NEXT", for: .normal)
        }
        
        //objUtil.setFrames(xCo: 0, yCo: 0, width: 60, height: 0, view: objNav.btnBack)
        objUtil.setFrames(xCo: kWidth-50, yCo: kNavBarHeightWithLogo-40, width: 45, height: 40, view: objNav.btnRightMenu)
        objNav.btnBack.addTarget(self, action: #selector(actBackClicked), for: .touchUpInside)
        objNav.btnRightMenu.addTarget(self, action: #selector(nextClicked), for: .touchUpInside)
        
        
        //
        //Content View Center
        //
        //uvContent.frame = CGRect.init(x: 0, y: kNavBarHeightWithLogo, width: kWidth, height: kHeight-kNavBarHeightWithLogo-40-75)
        uvContent.frame = CGRect.init(x: 0, y: kNavBarHeightWithLogo, width: kWidth, height: kHeight-kNavBarHeightWithLogo-uvImages.frame.height)
        uvContent.backgroundColor = UIColor.black
        self.view.addSubview(uvContent)
        
        
        
        //
        //Load gallery content
        //
        thumbnailSize = CGSize(width: (screenWidth/3)-10, height: (screenWidth/3)-10)
        
        createCollectionView()
        //
        //Get all library photos and videos
        //
        getAllPhotos()
        
        
        HideCrossButtons()
        //TODO: getAllPhotos()
        
        createCameraView()
        
        //
        //OPen Camera controller first
        //
        VideosClicked(btnPhotos)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:-
    //MARK: GET ALL PHOTOS OF GALLERY
    //MARK:
    
    func getAllPhotos() {
        
        
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status
            {
            case .authorized:
                print("Good to proceed")
                DispatchQueue.main.async {
                    self.smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
                    var collection: PHCollection?
                    for i in 0..<self.smartAlbums.count{
                        let album = self.smartAlbums.object(at: i)
                        if album.localizedTitle == "Camera Roll"{
                            collection = self.smartAlbums.object(at: i)
                        }
                    }
                    
                    if self.fetchResult == nil {
                        let fetchOptions = PHFetchOptions()
                        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                        if collection == nil{
                            self.fetchResult = PHAsset.fetchAssets(with: fetchOptions)
                        }
                        else{
                            guard let assetCollection = collection as? PHAssetCollection
                                else { fatalError("expected asset collection") }
                            self.fetchResult = PHAsset.fetchAssets(in: assetCollection, options: fetchOptions)
                        }
                    }
                    self.uvCollectionView?.reloadData()
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
    //MARK:- Create Custom Views
    
    func createCameraView() -> Void {
        
        if uvVideo == nil {
            uvVideo = VideoView.init(frame: uvContent.frame)
            uvVideo?.kScreenType = kScreenType
            uvVideo?.delegate = self
            uvVideo?.btnGallery.addTarget(self, action: #selector(LibraryClicked(_:)), for: .touchUpInside)
            uvVideo?.btnMyStoriesIcon.addTarget(self, action: #selector(openMyStories), for: .touchUpInside)
        }
        uvVideo?.isHidden = true
        uvContent.addSubview(uvVideo!)
        uvVideo?.StopSession()
    }
    //MARK:- Set selected Images
    
    func reloadSelectedImages() -> Void {
        if kScreenType == .newStory {
            nextClicked()
            return
        }
        
        LoadPlaceHolders()
        let arrImg: [UIImageView] = [img1, img2, img3, img4, img5, img6]
        let arrBtns: [UIButton] = [btnCross1, btnCross2, btnCross3, btnCross4, btnCross5, btnCross6]
        var j=0
        
        for dict in arrSelectedImages {
            
            let story = dict
            
            let imgV = arrImg[j]
            
            if story.type == .image {
                imgV.image = story.image
            }
            else {
                
                imgV.image = story.image
            }
            
            let btn = arrBtns[j]
            btn.isHidden = false
            j = j+1
        }
    }
    
    func LoadPlaceHolders() -> Void {
        let arrImg: [UIImageView] = [img1, img2, img3, img4, img5, img6]
        let arrBtns: [UIButton] = [btnCross1, btnCross2, btnCross3, btnCross4, btnCross5, btnCross6]
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
    
    //MARK:- ----------------------------------
    //MARK:---------Upload media actions-------
    
    func PopupCancel(sender: UIButton) -> Void {
        if kScreenType == .newStory {
            arrSelectedImages.removeAll()
            reloadSelectedImages()
            return
        }
        
        objPopupAlert?.close()
        uvPopUP = nil
    }
    
    func PopupNext(sender: UIButton) -> Void {
        if kScreenType == .newStory {
            print("Print Next")
            
            kAppDelegate.loadingIndicationCreation()
            APIRequest(sType: kAPIMyStoryUpload, data: [:])
            return
        }
        
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
        
        
        btnCross5.frame = CGRect.init(x: img5.frame.maxX-30, y: 0, width: 30, height: 30)
        btnCross5.setImage(#imageLiteral(resourceName: "close_1"), for: .normal)
        uvImages.addSubview(btnCross5)
        btnCross5.tag = 4
        btnCross5.addTarget(self, action: #selector(DeleteImage(sender:)), for: .touchUpInside)
        
        
        btnCross6.frame = CGRect.init(x: img6.frame.maxX-30, y: 0, width: 30, height: 30)
        btnCross6.setImage(#imageLiteral(resourceName: "close_1"), for: .normal)
        uvImages.addSubview(btnCross6)
        btnCross6.tag = 5
        btnCross6.addTarget(self, action: #selector(DeleteImage(sender:)), for: .touchUpInside)
        
    }
    
    func HideCrossButtons() -> Void {
        btnCross1.isHidden = true
        btnCross2.isHidden = true
        btnCross3.isHidden = true
        btnCross4.isHidden = true
        btnCross5.isHidden = true
        btnCross6.isHidden = true
    }
    
    
    // MARK: - Action Methods
    
    func openMyStories() {
        uvCamera?.StopSession()
        uvVideo?.StopSession()
        
        //Open My stories
        let storyboard = UIStoryboard(name: Storyboards.storyStoryboard.rawValue, bundle: nil)
        let homeVC: StoriesViewController = storyboard.instantiateViewController(withIdentifier: "StoriesViewController") as! StoriesViewController
        homeVC.screenType = .myStories
        homeVC.delegate = self
        topVC?.navigationController?.pushViewController(homeVC, animated: true)
    }
    
    func actBackClicked() {
        if selectedTab == 1 {
            //            PhotosClicked(btnPhotos)
            VideosClicked(btnVideos)
            return
        }
        self.goBack()
    }
    
    @IBAction func LibraryClicked(_ sender: UIButton) {
        objNav.btnBack.setImage(#imageLiteral(resourceName: "cameraicon"), for: .normal)
        selectedTab = 1
        TabHandling()
        uvCollectionView?.isHidden = false
        
        uvCamera?.isHidden = true
        uvVideo?.isHidden = true
        
        uvCamera?.StopSession()
        uvVideo?.StopSession()
    }
    @IBAction func PhotosClicked(_ sender: UIButton) {
        objNav.btnBack.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        objNav.btnBack.setTitle(nil, for: .normal)
        selectedTab = 2
        TabHandling()
        uvCollectionView?.isHidden = true
        
        uvVideo?.StopSession()
        uvCamera?.StartSession()
        
        
        uvCamera?.isHidden = false
        uvVideo?.isHidden = true
        
    }
    @IBAction func VideosClicked(_ sender: UIButton) {
        objNav.btnBack.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        objNav.btnBack.setTitle(nil, for: .normal)
        selectedTab = 3
        TabHandling()
        uvCollectionView?.isHidden = true
        uvCamera?.StopSession()
        uvVideo?.StartSession()
        uvCamera?.isHidden = true
        uvVideo?.isHidden = false
    }
    
    func TabHandling() {
        
        let arrButtons: [UIButton] = [btnLibrary, btnPhotos, btnVideos]
        
        for i in 0..<3 {
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
        if arrSelectedImages.count < 1 {
            return
        }
        if kScreenType == .newStory {
            PopupNext(sender: UIButton())
            return
        }
        NextPopUp()
    }
    
    
    
    //MARK:- Collection Grid for Library Setup
    
    
    //MARK:- Stories Delegates
    
    func StoriesVCBackClicked() {
        
        //
        //OPen Camera controller first
        //
        VideosClicked(btnPhotos)
    }
    
    //MARK:- Camera Delegates
    
    func CameraImageClicked(view: UIView, image: UIImage) {
        if arrSelectedImages.count == 6 {
            objUtil.showToast(strMsg: "You can select maximum six files")
            return
        }
        
        let vc = SHViewController(image: image)
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    func CameraImageClicked(image: UIImage) {
        if arrSelectedImages.count == 6 {
            objUtil.showToast(strMsg: "You can select maximum six files")
            return
        }
        
        let vc = SHViewController(image: image)
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    //MARK:- Video Delegates
    
    func VideoPicked(url: URL) {
        if arrSelectedImages.count == 6 {
            objUtil.showToast(strMsg: "You can select maximum six files")
            return
        }
        let thumb = url.getThumbnailOfURL()
        
        arrSelectedImages.append(NewStoryMedia.init(image: thumb, url: url, type: .video))
        reloadSelectedImages()
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
                    "story[caption]": self.uvPopUP?.ttxtCaption.text ?? "",
                    "story[likes_count]" : "0"
                    
                ]
                
                let arrResponse = self.objDataS.createNewStory(dictAction: dictAction, arrImages: self.arrSelectedImages)
                
                if (arrResponse.count) > 0 {
                    DispatchQueue.main.async {
                        
                        //
                        //Remove all files from temprary directory
                        //
                        let tempDirPath = FileManager.default.pathFor(.temprary)
                        if tempDirPath != nil {
                            _ = FileManager.removeAllItemsInsideDirectory(atPath: tempDirPath!)
                        }
                        
                        
                        //self.objUtil.showToast(strMsg: "Story created successfully")
                        self.uvPopUP = nil
                        //self.goBack()
                        kAppDelegate.hideLoadingIndicator()
                        //                        self.objUtil.showToast(strMsg: "Story created successfully")
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
//                            self.openMyStories()
                            self.homeScreen()
                        })
                    }
                }
            } else if sType == kAPIMyStoryUpload {
                let dictAction: NSDictionary = [
                    "action": kAPIMyStoryUpload
                ]
                
                let arrResponse = self.objDataS.createNewMyStory(dictAction: dictAction, arrImages: self.arrSelectedImages)
                
                if (arrResponse.count) > 0 {
                    DispatchQueue.main.async {
                        
                        //
                        //Remove all files from temprary directory
                        //
                        let tempDirPath = FileManager.default.pathFor(.temprary)
                        if tempDirPath != nil {
                            _ = FileManager.removeAllItemsInsideDirectory(atPath: tempDirPath!)
                        }
                        
                        
                        //self.objUtil.showToast(strMsg: "Story created successfully")
                        self.uvPopUP = nil
                        //self.goBack()
                        kAppDelegate.hideLoadingIndicator()
                        //                        self.objUtil.showToast(strMsg: "Story created successfully")
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
                            self.goBack()
                        })
                    }
                }
            }
            
        }
        
        
    }
    
}

struct NewStoryMedia {
    var image: UIImage?
    var url: URL?
    var type: enumMediaType
    
    init(image: UIImage?, url: URL?, type: enumMediaType) {
        
        self.url = url
        self.image = image
        self.type = type
    }
    
}

extension CameraViewController: SHViewControllerDelegate {
    
    func shViewControllerImageDidFilter(image: UIImage) {
        arrSelectedImages.append(NewStoryMedia.init(image: image, url: nil, type: .image))
        reloadSelectedImages()
        
    }
    
    func shViewControllerDidCancel() {
        //        dismissVC()
    }
}

//MARK: ------ UICollectionViewDelegate/DataSource Methods
extension CameraViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
{
    
    //MARK:- Collection Grid for Library Setup
    
    func createCollectionView() -> Void {
        
        if flowLayout == nil {
            flowLayout = UICollectionViewFlowLayout.init()
            flowLayout?.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
            flowLayout?.itemSize = thumbnailSize
            
        }
        
        if uvCollectionView == nil {
            uvCollectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: uvContent.frame.height), collectionViewLayout: flowLayout!)
            uvCollectionView?.dataSource = self
            uvCollectionView?.delegate = self
            uvCollectionView?.backgroundColor = UIColor.white
            uvContent.addSubview(uvCollectionView!)
        }
        
        uvCollectionView?.register(UINib(nibName: "ImagesCell", bundle: nil), forCellWithReuseIdentifier: "ImagesCell")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if fetchResult == nil{
            return 0
        }
        return fetchResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //let cell: ImagesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCell", for: indexPath) as! ImagesCell
        
        let cell : ImagesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCell", for: indexPath) as! ImagesCell
        
        
        let asset = fetchResult.object(at: indexPath.item)
        cell.videoIcon.isHidden = asset.mediaType != .video
        cell.representedAssetIdentifier = asset.localIdentifier
        imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            // The cell may have been recycled by the time this handler gets called;
            // set the cell's thumbnail image only if it's still showing the same asset.
            
            if cell.representedAssetIdentifier == asset.localIdentifier {
                cell.image.image = image
                cell.image.contentMode = .scaleAspectFill
            }
        })
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = fetchResult[indexPath.row]
        if asset.mediaType == .image {
            imageOption.isSynchronous = true
            imageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: imageOption, resultHandler: {(result, info)->Void in
                debugPrint("Image from asset === \(result)")
                
                if self.arrSelectedImages.count == 6 {
                    self.objUtil.showToast(strMsg: "You can select maximum six files")
                }
                else{
                    if result != nil {
                        let vc = SHViewController(image: result!)
                        vc.delegate = self
                        self.present(vc, animated: true, completion: nil)
                    }
                }
                
            })
        }
        else if asset.mediaType == .video {
            videoOption.version = .current
            imageManager.requestAVAsset(forVideo: asset, options: videoOption, resultHandler: { (asset, audioMix, nil) in
                if let urlAsset = asset as? AVURLAsset {
                    DispatchQueue.main.async {
                        debugPrint("Image from asset === \(urlAsset.url)")
                        
                        do {
                            let data = try Data.init(contentsOf: urlAsset.url)
                            print(data.count)
                            //FileName in string
                            //
                            let name = urlAsset.url.lastPathComponent
                            let fileName = String.randomString(len: 10).appending(name)
                            //
                            //File path where the file is stored on local directory
                            //
                            let filePath = FileManager.default.save(file: "\(fileName)", in: .temprary, content: data)
                            //
                            //File size in KB
                            let size = data.count/1024
                            print("Path: \(filePath), \n Size: \(size)")
                            
                            if FileManager.default.fileExists(atPath: filePath){
                                self.VideoPicked(url: URL.init(fileURLWithPath: filePath))
                            }
                            
                            
                        } catch let error as Error {
                            print(error.localizedDescription)
                        }
                        
                        
                        //self.VideoPicked(url: urlAsset.url)
                    }
                }
            })
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return thumbnailSize
    }
    
    // MARK: UIScrollView
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateCachedAssets()
    }
    
    // MARK: Asset Caching
    
    fileprivate func resetCachedAssets() {
        imageManager.stopCachingImagesForAllAssets()
        previousPreheatRect = .zero
    }
    
    fileprivate func updateCachedAssets() {
        // Update only if the view is visible.
        guard isViewLoaded && view.window != nil else { return }
        
        // The preheat window is twice the height of the visible rect.
        let preheatRect = view!.bounds.insetBy(dx: 0, dy: -0.5 * view!.bounds.height)
        
        // Update only if the visible area is significantly different from the last preheated area.
        let delta = abs(preheatRect.midY - previousPreheatRect.midY)
        guard delta > view.bounds.height / 3 else { return }
        
        // Compute the assets to start caching and to stop caching.
        let (addedRects, removedRects) = differencesBetweenRects(previousPreheatRect, preheatRect)
        let addedAssets = addedRects
            .flatMap { rect in uvCollectionView!.indexPathsForElements(in: rect) }
            .map { indexPath in fetchResult.object(at: indexPath.item) }
        let removedAssets = removedRects
            .flatMap { rect in uvCollectionView!.indexPathsForElements(in: rect) }
            .map { indexPath in fetchResult.object(at: indexPath.item) }
        
        // Update the assets the PHCachingImageManager is caching.
        imageManager.startCachingImages(for: addedAssets,
                                        targetSize: thumbnailSize, contentMode: .aspectFill, options: nil)
        imageManager.stopCachingImages(for: removedAssets,
                                       targetSize: thumbnailSize, contentMode: .aspectFill, options: nil)
        
        // Store the preheat rect to compare against in the future.
        previousPreheatRect = preheatRect
    }
    fileprivate func differencesBetweenRects(_ old: CGRect, _ new: CGRect) -> (added: [CGRect], removed: [CGRect]) {
        if old.intersects(new) {
            var added = [CGRect]()
            if new.maxY > old.maxY {
                added += [CGRect(x: new.origin.x, y: old.maxY,
                                 width: new.width, height: new.maxY - old.maxY)]
            }
            if old.minY > new.minY {
                added += [CGRect(x: new.origin.x, y: new.minY,
                                 width: new.width, height: old.minY - new.minY)]
            }
            var removed = [CGRect]()
            if new.maxY < old.maxY {
                removed += [CGRect(x: new.origin.x, y: new.maxY,
                                   width: new.width, height: old.maxY - new.maxY)]
            }
            if old.minY < new.minY {
                removed += [CGRect(x: new.origin.x, y: old.minY,
                                   width: new.width, height: new.minY - old.minY)]
            }
            return (added, removed)
        } else {
            return ([new], [old])
        }
    }
}

private extension UICollectionView {
    func indexPathsForElements(in rect: CGRect) -> [IndexPath] {
        let allLayoutAttributes = collectionViewLayout.layoutAttributesForElements(in: rect)!
        return allLayoutAttributes.map { $0.indexPath }
    }
}

