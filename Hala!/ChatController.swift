//
//  ChatController.swift
//  hala
//
//  Created by MAC on 28/09/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
import FTIndicator
import JSQMessagesViewController
import SDWebImage




class ChatController: JSQMessagesViewController {
    
    var friend : UserDetail!
    var mySelf : UserDetail!
    var isGroup : Bool = false
    
    var profileImage : UIImageView!
    
    
    @IBOutlet weak var uploadingView:UIView!
    @IBOutlet weak var showprogess:UIProgressView!
    @IBOutlet weak var labelProgess:UILabel!
    @IBOutlet weak var uploadingBackgroundView: UIView!
    // MARK: Properties
    var firbaseKeyId: String?
    var otherUserImageUrl: String?
    var otherUserImge : UIImage?
    var otherUserID : String?
    var otherUserName : String?
    var boolDeleteChat = false
    private let imageURLNotSetKey = "NOTSET"
    private var newMessageRefHandle: DatabaseHandle?
    private var updatedMessageRefHandle: DatabaseHandle?
    private var messages: [JSQMessage] = []
    fileprivate lazy var storageRef: StorageReference = Storage.storage().reference()
    private var localTyping = false
    //    var channel: Channel? {
    //        didSet {
    //            title = channel?.name
    //        }
    //    }
    
    var isTyping: Bool {
        get {
            return localTyping
        }
        set {
            localTyping = newValue
            // userIsTypingRef.setValue(newValue)
        }
    }
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    // lazy var outgoingAvtarImageView: JSQMessagesAvatarImage = self.setupIncomingAvtar()
    //   lazy var incomingAvtarImageView: JSQMessagesAvatarImage = self.setupIncomingAvtar()
    
    func getTheChatId(myId : String , friendId : String) -> String{
        let mid : Int = Int(myId)!
        let fid : Int = Int(friendId)!
        var chatId : String = ""
        if fid > mid{
            chatId = "\(mid)_\(fid)"
        }else{
            chatId = "\(fid)_\(mid)"
        }
        return chatId
    }
    
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // FTIndicator.showProgress(withMessage: "loading")
        
        if let user = UserDefaults.standard.object(forKey: "User") as? NSDictionary{
            mySelf = UserDetail.init(user: user)
        }
        
        if isGroup == true{
            firbaseKeyId  = friend.uid + "G"
        }else{
            firbaseKeyId  = getTheChatId(myId: mySelf.uid, friendId: friend.uid)
        }
        
        
        
        self.senderId = mySelf.uid
        self.senderDisplayName = mySelf.name
        otherUserImageUrl = URLConstants.imageBase + friend.image
        otherUserID = friend.uid
        otherUserName = friend.name
        
        self.inputToolbar.contentView.leftBarButtonItemWidth = 0
        
        self.title = friend.name
        
        let backBtn : UIButton = UIButton(frame : CGRect(x:0,y:0,width: 44, height :44))
        backBtn.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        backBtn.addTarget(self, action: #selector(ChatController.backTap), for: .touchDown)
        
        
        let leftView : UIView = UIView()
        leftView.frame = CGRect(x:0, y:0 , width :100 , height :44)
        leftView.backgroundColor = UIColor.clear
        leftView.addSubview(backBtn)
        
        
        profileImage  = UIImageView()
        profileImage.image = #imageLiteral(resourceName: "user_default")
        if let imageURL = URL(string : friend.image){
            profileImage.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "user_default"))
        }
        profileImage.frame = CGRect(x:46, y:2 , width :40 , height :40)
        profileImage.layer.cornerRadius = 22
        profileImage.clipsToBounds = true
        leftView.addSubview(profileImage)
        
        let barButton : UIBarButtonItem = UIBarButtonItem(customView : leftView)
        self.navigationItem.leftBarButtonItem = barButton
        

        
        
        let tlabel = UILabel(frame: CGRect(x:0, y:0, width:200, height:40))
        tlabel.text = self.title
        tlabel.textColor = UIColor.white
        tlabel.textAlignment = .left
        tlabel.font = UIFont(name: "Avenir", size: 18)
        tlabel.backgroundColor = UIColor.clear
        tlabel.adjustsFontSizeToFitWidth = true
        self.navigationItem.titleView = tlabel
        
        
        
        
        
        
        
        ChatMessage.downloadAllMessages(forFirebaseID: firbaseKeyId!, completion:{(message,sucess)-> Void in
            FTIndicator.dismissProgress()
            if sucess == true{
                let isImage = message.isImage
                if !isImage {
                    
                    self.addMessage(withId: message.fromID! , name: "", text: message.content as! String, time: message.time!, senderImage: message.senderImage!)
                    self.finishReceivingMessage()}
            }
        })
        
    }
    
    @objc func backTap(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
    // MARK: Collection view data source (and related) methods
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId { // 2
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        
     
        cell.avatarImageView.layer.cornerRadius = cell.avatarImageView.frame.size.width / 2
        cell.avatarImageView.clipsToBounds = true
        cell.avatarImageView.contentMode = .scaleAspectFill
        
        if message.senderId == senderId { // 1
            if let url = URL(string : mySelf.image){
                cell.avatarImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "user_default"))
            }
            cell.textView?.textColor = UIColor.white // 2

        } else {
            if let url = URL(string : message.senderImageURL){
                cell.avatarImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "user_default"))
            }
            cell.textView?.textColor = UIColor.black // 3
        }
        
        return cell
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = messages[indexPath.item] // 1
        print(message.senderImageURL)
        var userImage2 = UIImage(named : "user_default")
       return JSQMessagesAvatarImageFactory.avatarImage(with: userImage2, diameter: 50)

        
        
        
//        if message.senderId == senderId {
//
//
//
//
//
////            SDWebImageManager.shared().downloadImage(with: NSURL(string: mySelf.image) as URL!, options: .continueInBackground, progress: {
////                (receivedSize :Int, ExpectedSize :Int) in
////            }, completed: {
////                (image : UIImage?, error : Error?, cacheType : SDImageCacheType, finished : Bool, url : URL?) in
////
//               var userImage2 = UIImage(named : "user_default")
////
////                if error == nil{
////                    userImage2 = image!
////                }
//
//                 return JSQMessagesAvatarImageFactory.avatarImage(with: userImage2, diameter: 50)
//
//
////            })
//
//
//
//
//        }else{
//
//
//
////            SDWebImageManager.shared().downloadImage(with: NSURL(string: friend.image) as URL!, options: .continueInBackground, progress: {
////                (receivedSize :Int, ExpectedSize :Int) in
////            }, completed: {
////                (image : UIImage?, error : Error?, cacheType : SDImageCacheType, finished : Bool, url : URL?) in
//
//                var userImage2 = UIImage(named : "user_default")
//
////                if error == nil{
////                    userImage2 = image!
////                }
////
//
//
//                return JSQMessagesAvatarImageFactory.avatarImage(with: userImage2, diameter: 50)
////
////
////            })
////
//
//        }
//
    }
    
    
    

    
    
    override  func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAt indexPath: IndexPath!) -> CGFloat {
        return 5
    }
    override  func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item]
        return NSAttributedString(string:"")
    }
    
    // MARK: Firebase related methods
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        // 1
        
        //    JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        self.updateInbox(text: text)

        
        //2
        
        let imageUrl : String = URLConstants.imageBase + mySelf.image
        
        let message =   ChatMessage( content: text, time:CommonUtility.getCurrentDate(), isImage: false,fromID:self.senderId, senderImage: imageUrl, friendImage: friend.image)
        ChatMessage.send(message: message, underId:firbaseKeyId!, toId: otherUserID! , completion: {(sucess) in
        })
        // 4
        finishSendingMessage()
        
        isTyping = false
    }
    
    func updateInbox(text : String){
        if let lang = UserDefaults.standard.object(forKey: "lang") as? String{

        var param : [String : String]!
        
        if isGroup == true{
            param = ["from_id":self.senderId!,"to_id":"0","mess":text,"lang":lang,"group_id":friend.uid]
        }else{
            param = ["from_id":self.senderId!,"to_id":friend.uid!,"mess":text,"lang":lang,"group_id":"0"]
        }
        
        let urlString = URLConstants.baseUrl + URLConstants.sendMessage
        
        print(urlString)
        print(param)
        
        
        ServerData.postResponseFromURL(urlString: urlString, showIndicator: false, params: param ) { (data) in
            print(data)
        }
    }
    }
    
    // MARK: UI and User Interaction
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: GlobalConstants.DEFAULT_COLOR_BRINJAL)
    }
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor(red:209/255.0,green:209/255.0,blue:209/255.0 , alpha : 1))
    }
    
    
    private func addMessage(withId id: String, name: String, text: String,time:String, senderImage : String) {
        var value:Date
        if !time.isEmpty{
            value = CommonUtility.getCurrentDate(time)
        }
        else{
            let currentDate = CommonUtility.getCurrentDate()
            value = CommonUtility.getCurrentDate(currentDate)
        }
        
        
        if let message = JSQMessage(senderId : id , senderDisplayName : name , date : value ,text :text , senderImageURL: senderImage)
        {
            messages.append(message)
        }
    }
    
    
    
    // MARK: UITextViewDelegate methods
    override func textViewDidChange(_ textView: UITextView) {
        super.textViewDidChange(textView)
        // If the text is not empty, the user is typing
        isTyping = textView.text != ""
    }
    
    
}
