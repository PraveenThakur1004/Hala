//
//  ChatMessage.swift
//  hala
//
//  Created by MAC on 11/10/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FTIndicator

class ChatMessage: NSObject {
    //MARK: Properties
    
    var content: Any
    var time: String?
    var isImage: Bool
    var image: UIImage?
    var fromID: String?
    var senderImage: String?
    var friendImage: String?
    private var firebaseID: String?
    
    
    class func downloadAllMessages(forFirebaseID: String, completion: @escaping (_ message:ChatMessage, _ sucess: Bool) -> Swift.Void) {
        firebaseConstant.base.child(firebaseConstant.child_Chat).child(forFirebaseID).observe(.childAdded, with: { (snapshot) in
            var message:ChatMessage?
            var sucess:Bool?
            if snapshot.exists() {
                sucess = true
                let receivedMessage = snapshot.value as! [String: Any]
                
                print(receivedMessage)
                
                let content = receivedMessage["message"] as! String
                let fromID = receivedMessage["sender_id"] as! String
                let timestamp = receivedMessage["timeStamp"] as! String
                 let senderImage = receivedMessage["senderImage"] as! String
                 let friendImage = receivedMessage["friendImage"] as! String
                let isImage = receivedMessage["img"] as? Bool
                
                
                message = ChatMessage.init( content: content, time: timestamp, isImage: isImage!, fromID: fromID ,senderImage: senderImage , friendImage: friendImage)
                completion(message!,sucess!)
            }
                
            else{
            }
        })
        
    }
    
    
    
    
    
    
    
    class func send(message: ChatMessage, underId: String,toId:String, completion: @escaping (Bool) -> Swift.Void)  {
        
        
        let values = ["img": message.isImage, "message": message.content, "sender_id": message.fromID ?? "", "timeStamp": message.time ?? "","senderImage" : message.senderImage ?? "" , "friendImage" : message.friendImage ?? ""]
        ChatMessage.uploadMessage(withValues: values, underId: underId, completion: { (status) in
            if status{
              
            }
        })
    }
    
    class func uploadMessage(withValues: [String: Any], underId: String, completion: @escaping (_ status:Bool) -> Swift.Void) {
        
        
        
        
        
        firebaseConstant.base.child(firebaseConstant.child_Chat).child(underId).childByAutoId().updateChildValues(withValues, withCompletionBlock: { (error, _) in
            var sucess = false
            if error == nil {
                sucess = true
                completion(sucess)
            } else {
                completion(sucess)
            }
        })
    }
    
    
    
    
    
    //MARK: Inits
    init(content: Any, time: String, isImage: Bool , fromID: String?,senderImage : String? , friendImage : String?) {
        self.senderImage = senderImage
        self.friendImage = friendImage
        self.content = content
        self.time = time
        self.isImage = isImage
        self.fromID = fromID
    }
}
