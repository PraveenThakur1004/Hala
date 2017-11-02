//
//  halaConstants.swift
//  hala
//
//  Created by MAC on 02/10/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import Firebase

struct GlobalConstants {
    static let DEFAULT_SELECTED_YELLOW: UIColor = UIColor(red:253/255.0, green :200/255.0, blue :118/255.0,alpha :1.0)
    static let DEFAULT_COLOR_BRINJAL: UIColor = UIColor(red:65/255.0, green :4/255.0, blue :85/255.0,alpha :1.0)
    static let FB_COLOR : UIColor = UIColor(red:63/255.0, green :89/255.0, blue :150/255.0,alpha :1.0)
    static let TW_COLOR : UIColor = UIColor(red:48/255.0, green :157/255.0, blue :233/255.0,alpha :1.0)
}

struct URLConstants  {
    //App Base URL
    static let baseUrl = "http://nimbyisttechnologies.com/himanshu/hala/api/apis/"
    
    //Image Base URL
    static let imageBase = "http://nimbyisttechnologies.com/himanshu/hala/"
    
    //LoginApi
    static let loginApi = "login?"
    //Parameters : {"password":"password","username":"username"}
    
    //RegisterApi
    static let registerApi = "registerUser?"
    /*Parameters : {"email":"bb","pass":"123","type":"2","deviceToken":"adasdad","deviceType":"ios"}*/
    
    //UpdateApi
    static let updateMe = "updateProfile?"
    /*Parameters : {"id":"bb","name":"123","gender":"2","dob":"adasdad","image":"ios","bg_image":"","online":"","point":"","social_type":"","introduction":"","ethinicity":"","blood_group":"","hair_color":"","drinking":"","hobby":"","smoking":"","relationship":"","height":"","intrested":"","eye_color":""}*/
    
    //socialLoginApi
    static let socialLogin = "socialLogin?"
    //Parameters : {"user_id":"1"}
    
    //UserDetailsApi
    static let myDetailApi = "getUser?"
    //Parameters : {"user_id":"1"}
    
    //updateDeviceApi
    static let updateDeviceApi = "updateDevice?"
    /*Parameters : {"user_id":"bb","deviceToken":"adasdad","deviceType":"ios"}*/
    
    //updatePasswordApi
    static let updatePassword = "updatePassword?"
    /*Parameters : {"user_id":"bb","oldPass":"adasdad","newPass":"ios"}*/
    
    //forgotPasswordApi
    static let forgotPassword = "forgetPassword?"
    /*Parameters : {"email":"bb","type":"2"}*/
    
    //logoutApi
    static let logout = "logout?"
    /*Parameters : {"user_id":"1"}*/
    
    //locationUpdateApi
    static let updateLocation = "updateLocation?"
    /*Parameters : {"user_id":"1","lat":"30.00000","lng":"70.00000"}*/
    
    //nearbyUsersApi
    static let nearBy = "nearBy?"
    /*Parameters : {"user_id":"1","lat":"30.00000","lng":"70.00000"}*/
    
    //hotListApi
    static let hotList = "Listhotlist?"
    /*Parameters : {"user_id":"1","lang":"ar"}*/
    
    //blockListApi
    static let blockList = "blockList?"
    /*Parameters : {"user_id":"1","lang":"ar"}*/
    
    //hotOrBlockApi
    static let addHotBlocklist = "addHotBlocklist?"
    /*Parameters : {"add_by":"1","add_to":"3","lang":"en","status":""} status for block = 2 , hot = 1*/
    
    //removeFromHotOrBlockApi
    static let removeHotBlocklist = "addHotBlocklist?"
    /*Parameters : {"add_by":"1","add_to":"3","lang":"en","status":"0"}  status for both = 0*/
    
    //notificationStatusApi
    static let notificationStatus = "Setnotify?"
    /*Parameters : {"user_id":"1","lang":"ar","notify":""}  1 = off  & 0 = on*/
    
    //dailyPointsApi
    static let dailyPoints = "Listpoints?"
    /*Parameters : {"lang":"ar"}*/

    //addPointsApi
    static let addMorePoints = "Addpoint?"
    /*Parameters : {"lang":"ar","points":"55","user_id":"1"}*/
    
    //subscriptionListApi
    static let subscriptionList = "listSubscription?"
    /*Parameters : {"lang":"ar"}*/
    
    //seconPersonDetailApi
    static let secondPerson = "getOtherUser?"
    /*Parameters : {"user_id":"1","other_id":"2","lat":"1","lng":"1"}*/
    
    //Privacy
    static let privacyPolicy = "http://nimbyisttechnologies.com/himanshu/hala/app/webroot/privacy/"
    
    //Privacy
    static let getChats = "inboxUsers?"
    
    
    static let sendMessage = "sendMess?"
    
    static let getProfille = "getUser?"
    
    static let myGroups = "myCreatedGroups?"
    
    static let createGroup = "createGroup?"
    
    static let allGroups = "myJoinedGroups?"
    
    
    static let saerchPeople = "search?"
    
    static let joinGroup = "sendRequest?"
    
    static let acceptRequest = "acceptreq?"
    static let rejectRequest = "rejectreq?"
    
    static let aboutUS = "about?"
    
    static let groupInbox = "groupInbox?"
    
    static let deleteGroup = "deleteGroupowner?"
    
    static let reportUser = "report?"
    
    
    static let leaveGroup = "leaveGroup?"
    
}
struct firebaseConstant{
    static let base = Database.database().reference()
    static let child_Chat = "chat"
    static let child_ChatData = "chatData"
    static let child_Messages = "messages"
}
struct DefinedStrings  {
    static let internetError = "Internet Connectivity is Not Available"
    static let serverError = "Server Not Responding"
    static let loaderText = "Loading..."
    static let validRequired = "Please Enter Required Fields"
    static let validEmail = "Please Enter Valid Email"

    static let groupNameError = NSLocalizedString("Please enter group name", comment: "")
    
    
    static let creatingGroup = NSLocalizedString("Creating...", comment: "")
    
    static let createGroup = NSLocalizedString("Create Group", comment: "")
    static let groupCreated = NSLocalizedString("Group Created", comment: "")
    static let selecteImage = NSLocalizedString("Please Select Image", comment: "")
    static let cameraString = NSLocalizedString("Camera", comment: "")
    static let galleryString = NSLocalizedString("Gallery", comment: "")
    static let cancelString = NSLocalizedString("Cancel", comment: "")
    static let hasNoCamera = NSLocalizedString("This device has no Camera", comment: "")
    
   static let noCam = NSLocalizedString("Camera Not Found", comment: "")
    
    static let updatedProfile = NSLocalizedString("Profile Updated", comment: "")
    static let reportedUser = NSLocalizedString("User reported to the admin", comment: "")
   
    static let addedHot = NSLocalizedString("added to hotlist", comment: "")
    
    static let blockedByme = NSLocalizedString("was blocked by you", comment: "")
    
    static let years = NSLocalizedString("Years", comment: "")
}
