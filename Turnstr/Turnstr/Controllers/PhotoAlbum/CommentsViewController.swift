//
//  CommentsViewController.swift
//  Turnstr
//
//  Created by Ketan Saini on 19/07/17.
//  Copyright © 2017 Ankit Saini. All rights reserved.
//

import UIKit


protocol CommentsDelegate {
        func btnCancelTapped()
}

class CommentsViewController: UIViewController, UITextViewDelegate, ServiceUtility {
    @IBOutlet weak var tblViewComments: UITableView!
    @IBOutlet weak var imgViewBackground: UIImageView!
    @IBOutlet weak var txtViewAddComment: UITextView!
    @IBOutlet weak var btnAddComment: UIButton!
    
    var objPhoto: Photos?
    var arrComments = [CommentModel]()
    var isLoadNext = false
    var pageNumber = 0
    var delegate: CommentsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        imgViewBackground.alpha = 0.0
        btnAddComment.isEnabled = false
        
        tblViewComments.rowHeight = UITableViewAutomaticDimension
        tblViewComments.estimatedRowHeight = 40
        self.tblViewComments.tableFooterView = UIView(frame: CGRect.zero)
        
        getComments(page: pageNumber)
    }
    
    func getComments(page: Int) {
        guard objPhoto != nil else { return }
        kAppDelegate.loadingIndicationCreationMSG(msg: "Loading...")
        getPhotoComment(id: (objPhoto?.id)!, page: page) { (response, dict) in
            if let commentsArray = response?.response {
                print(commentsArray)
                for object in commentsArray {
                    self.arrComments.append(object)
                }
                self.tblViewComments.reloadData()
                
                if let _ = dict["next_page"] as? Int {
                    self.isLoadNext = true
                } else {
                    self.isLoadNext = false
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UIView.animate(withDuration: 0.5, animations: {
            self.imgViewBackground.alpha = 0.4
        }, completion: {
            finished in
        })
    }
    
    @IBAction func backgroundViewTapped(_ sender: UITapGestureRecognizer) {
        delegate?.btnCancelTapped()
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btnTappedAddComment(_ sender: Any) {
        self.view.endEditing(true)
        guard objPhoto != nil else { return }
        
        if txtViewAddComment.text.trimmingCharacters(in: .whitespacesAndNewlines) == "Write a comment" || txtViewAddComment.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return
        }
        kAppDelegate.loadingIndicationCreationMSG(msg: "Posting...")
        self.postPhotoComment(id: (objPhoto?.id)!, comment: txtViewAddComment.text.encode()) { (response) in
            if let comment = response?.response {
                self.arrComments.append(comment)
                self.txtViewAddComment.text = ""
                self.view.endEditing(true)
                self.tblViewComments.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // UITextView Delegates
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Write a comment" {
            btnAddComment.isEnabled = true
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.view.endEditing(true)
        if textView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" {
            btnAddComment.isEnabled = false
            textView.text = "Write a comment"
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        guard let textStr = textView.text else { return true }
        let newLength = textStr.characters.count + text.characters.count - range.length
        // Set keynot max limit
        return newLength <= 1000
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension CommentsViewController: UITableViewDelegate, UITableViewDataSource {
    //MARK: - UITableView Delegate/Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Check whether to show settings section or not.
        return arrComments.count
    }
    // TableView cell for row at index
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellComments", for: indexPath)
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        if let lblName = cell.viewWithTag(1001) as? UILabel {
            lblName.text = arrComments[indexPath.row].user?.username
        }
        
        if let lblComment = cell.viewWithTag(1003) as? UILabel {
            lblComment.text = arrComments[indexPath.row].body?.decode()
        }
        
        if let lblTime = cell.viewWithTag(1002) as? UILabel {
            lblTime.text = self.convertStringToDate(dateString: arrComments[indexPath.row].created_at!)?.timeAgoDisplay()
        }
        
        var cube = cell.contentView.viewWithTag(indexPath.item) as? AITransformView
        if cube == nil {
            
            cube = AITransformView.init(frame: CGRect.init(x: 0, y: 0, width: 48, height: 48), cube_size: 30)
            cube?.tag = indexPath.item
            cube?.backgroundColor = UIColor.clear
            cube?.isUserInteractionEnabled = false
            let objComment = arrComments[indexPath.row].user
            let arrFaces = [objComment?.avatar_face1 ?? "", objComment?.avatar_face2 ?? "", objComment?.avatar_face3 ?? "", objComment?.avatar_face4 ?? "", objComment?.avatar_face5 ?? "", objComment?.avatar_face6 ?? ""]
            cube?.setup(withUrls: arrFaces)
            cell.contentView.addSubview(cube!)
            cube?.setScroll(CGPoint.init(x: 0, y: 48/2), end: CGPoint.init(x: 2.5, y: 48/2))
            cube?.setScroll(CGPoint.init(x: 48/2, y: 0), end: CGPoint.init(x: 48/2, y: 1))

        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == arrComments.count - 1, isLoadNext {
            pageNumber = pageNumber+1
            self.getComments(page: pageNumber)
        }
    }
    
    func convertStringToDate(dateString: String) -> Date? {
        let dateFormatter = DateFormatter() //2017-07-10T05:39:31.000Z
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale.init(identifier: "en_US_POSIX")
        
        if let dateObj = dateFormatter.date(from: dateString) {
            return dateObj
        }
        return nil
    }
}
