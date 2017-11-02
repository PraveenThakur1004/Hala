//
//  DataModel.swift
//  BnkUp
//
//  Created by OSX on 04/10/16.
//  Copyright © 2016 Jaipreet. All rights reserved.
//

import Alamofire
import UIKit
import IQKeyboardManagerSwift


var Baseurl : String = "http://nimbyisttechnologies.com/himanshu/hala/api/apis/"
//var BuyerAuthUserName : String = "sandeep.orem12@gmail.com"
//var BuyerAuthUserPassword : String = "66327Jk71Yh77v384MZ51H4hQ7c06q7l"


//home?user_id=12


typealias CompletionBlock = (_ result: Any, _ error: NSError?) -> Void




class DataModel: NSObject {

    
    //blocks
    var completion: CompletionBlock = { result, error in print(error!) }
    

    
    func GetApi( Url: NSString, withCompletionHandler:@escaping (_ result:NSDictionary , _ Error : NSString ) -> Void) {
        
        IQKeyboardManager.sharedManager().resignFirstResponder()
        
    
        Alamofire.request("\(Baseurl)\(Url)").responseJSON { response in
//            print(response.request)  // original URL request
//            print(response.response) // HTTP URL response
//            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                
                
                
                withCompletionHandler( JSON as! NSDictionary , response.result.description as NSString  )
            }
            else{
                //                withCompletionHandler()
                //                let Dict : NSDictionary()
                let JSON = ["error":"data"]
                withCompletionHandler( JSON as NSDictionary , response.result.description as NSString )
                
            }
        }//
//        
            }
    
    

    
    
    func GetRegisterApi( Url: NSString, withCompletionHandler:@escaping (_ result:NSDictionary , _ Error : NSString ) -> Void) {
        
        
        var url = "\(Baseurl)\(Url)"
        
        IQKeyboardManager.sharedManager().resignFirstResponder()

        
       url = url.replacingOccurrences(of: " ", with: "%20")
        
        Alamofire.request(url as String  , method: .get).responseJSON { response in
//            print(response.request!)  // original URL request
//            print(response.response!) // HTTP URL response
//            print(response.data!)     // server data
//            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                
                
                
                withCompletionHandler( JSON as! NSDictionary , response.result.description as NSString )
            }
            else{
//                withCompletionHandler()
//                let Dict : NSDictionary()
                let JSON = ["error":"data"]
                withCompletionHandler( JSON as NSDictionary , response.result.description as NSString )

            }
        }//
        //
    }
    func GetLoginAccountApi( Url: NSString, dict: NSDictionary, withCompletionHandler:@escaping (_ result:NSDictionary , _ Error : NSString ) -> Void) {
        
        
        var url = "\(Baseurl)\(Url)"
        IQKeyboardManager.sharedManager().resignFirstResponder()

        
        
        url = url.replacingOccurrences(of: " ", with: "%20")
        
        
        
        
        
        Alamofire.request(url as String  , method: .get , parameters: dict as? Parameters ).responseJSON { response in
            // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                
                
                
                withCompletionHandler( JSON as! NSDictionary , response.result.description as NSString )
            }
            else{
                //                withCompletionHandler()
                //                let Dict : NSDictionary()
                let JSON = ["error":"data"]
                withCompletionHandler( JSON as NSDictionary , response.result.description as NSString )
                
            }
        }//
        //
    }

    func PostApi( Url: NSString, dict: NSDictionary, withCompletionHandler:@escaping (_ result:NSDictionary , _ Error : NSString ) -> Void) {
        
        
        var url = "\(Baseurl)\(Url)"
        
        IQKeyboardManager.sharedManager().resignFirstResponder()

        
        url = url.replacingOccurrences(of: " ", with: "%20")
        
        
      print(url)
        
        print(dict)
        
        
        Alamofire.request(url as String  , method: .post , parameters: dict as? Parameters ).responseJSON { response in
              // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                
                
                
                withCompletionHandler( JSON as! NSDictionary , response.result.description as NSString )
            }
            else{
                //                withCompletionHandler()
                //                let Dict : NSDictionary()
                let JSON = ["error":"data"]
                withCompletionHandler( JSON as NSDictionary , response.result.description as NSString )
                
            }
        }//
        //
    }
    func PostClearApi( Url: NSString, dict: NSDictionary, withCompletionHandler:@escaping (_ result:NSDictionary , _ Error : NSString ) -> Void) {
        
        
        var url = "\(Baseurl)\(Url)"
        IQKeyboardManager.sharedManager().resignFirstResponder()

        
        
        url = url.replacingOccurrences(of: " ", with: "%20")
        
        
        print(url)
        
        
        Alamofire.request(url as String  , method: .post , parameters: dict as? Parameters ).responseJSON { response in
            // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                
                
                
                withCompletionHandler( JSON as! NSDictionary , response.result.description as NSString )
            }
            else{
                //                withCompletionHandler()
                //                let Dict : NSDictionary()
                let JSON = ["error":"data"]
                withCompletionHandler( JSON as NSDictionary , response.result.description as NSString )
                
            }
        }//
        //
    }
    func PostLocationApi( Url: NSString, dict: NSDictionary, withCompletionHandler:@escaping (_ result:NSDictionary , _ Error : NSString ) -> Void) {
        
        
        var url = "\(Baseurl)\(Url)"
        
        IQKeyboardManager.sharedManager().resignFirstResponder()

        
        url = url.replacingOccurrences(of: " ", with: "%20")
        
        
        print(url)
        
        
        Alamofire.request(url as String  , method: .post , parameters: dict as? Parameters ).responseJSON { response in
            // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
//                print("JSON: \(JSON)")
                
                
                
                withCompletionHandler( JSON as! NSDictionary , response.result.description as NSString )
            }
            else{
                //                withCompletionHandler()
                //                let Dict : NSDictionary()
                let JSON = ["error":"data"]
                withCompletionHandler( JSON as NSDictionary , response.result.description as NSString )
                
            }
        }//
        //
    }
    func GetApi( Url: NSString, dict: NSDictionary, withCompletionHandler:@escaping (_ result:NSDictionary , _ Error : NSString ) -> Void) {
        
        IQKeyboardManager.sharedManager().resignFirstResponder()

        var url = "\(Baseurl)\(Url)"
        
        
        
        url = url.replacingOccurrences(of: " ", with: "%20")
        
        
        print(url)
        
        
        Alamofire.request(url as String  , method: .get , parameters: dict as? Parameters ).responseJSON { response in
            // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                
                
                
                withCompletionHandler( JSON as! NSDictionary , response.result.description as NSString )
            }
            else{
                //                withCompletionHandler()
                //                let Dict : NSDictionary()
                let JSON = ["error":"data"]
                withCompletionHandler( JSON as NSDictionary , response.result.description as NSString )
                
            }
        }//
        //
    }
    func GetCountApi( Url: NSString, dict: NSDictionary, withCompletionHandler:@escaping (_ result:NSDictionary , _ Error : NSString ) -> Void) {
        
        
        var url = "\(Baseurl)\(Url)"
        
        
        IQKeyboardManager.sharedManager().resignFirstResponder()

        url = url.replacingOccurrences(of: " ", with: "%20")
        
        
        print(url)
        
        
        Alamofire.request(url as String  , method: .get , parameters: dict as? Parameters ).responseJSON { response in
            // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
//                print("JSON: \(JSON)")
                
                
                
                withCompletionHandler( JSON as! NSDictionary , response.result.description as NSString )
            }
            else{
                //                withCompletionHandler()
                //                let Dict : NSDictionary()
                let JSON = ["error":"data"]
                withCompletionHandler( JSON as NSDictionary , response.result.description as NSString )
                
            }
        }//
        //
    }
    func DelectApi( Url: NSString, dict: NSDictionary, withCompletionHandler:@escaping (_ result:NSDictionary , _ Error : NSString ) -> Void) {
        
        
        var url = "\(Baseurl)\(Url)"
        
        IQKeyboardManager.sharedManager().resignFirstResponder()

        
        url = url.replacingOccurrences(of: " ", with: "%20")
        
        
        
        
        
        Alamofire.request(url as String  , method: .delete , parameters: dict as? Parameters , encoding: JSONEncoding.default).responseJSON { response in
            // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                
                
                
                withCompletionHandler( JSON as! NSDictionary , response.result.description as NSString )
            }
            else{
                //                withCompletionHandler()
                //                let Dict : NSDictionary()
                let JSON = ["error":"data"]
                withCompletionHandler( JSON as NSDictionary , response.result.description as NSString )
                
            }
        }//
        //
    }

    func PutApi( Url: NSString, dict: NSDictionary, withCompletionHandler:@escaping (_ result:NSDictionary , _ Error : NSString ) -> Void) {
        
        
        var url = "\(Baseurl)\(Url)"
        
        
        
        url = url.replacingOccurrences(of: " ", with: "%20")
        
        
        
        IQKeyboardManager.sharedManager().resignFirstResponder()

        
        Alamofire.request(url as String  , method: .put , parameters: dict as? Parameters , encoding: JSONEncoding.default).responseJSON { response in
            // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                
                
                
                withCompletionHandler( JSON as! NSDictionary , response.result.description as NSString )
            }
            else{
                //                withCompletionHandler()
                //                let Dict : NSDictionary()
                let JSON = ["error":"data"]
                withCompletionHandler( JSON as NSDictionary , response.result.description as NSString )
                
            }
        }//
        //
    }
    func UploadVideoApi( Url: NSString,movieURL : NSString ,  dict: NSDictionary, withCompletionHandler:@escaping (_ result:NSDictionary , _ Error : NSString ) -> Void) {
        
        var url = "\(Baseurl)\(Url)"
        
        
        
        url = url.replacingOccurrences(of: " ", with: "%20")
        let headers: HTTPHeaders = [
            "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
            "Accept": "application/json"
        ]

   
                
       
        
//             Alamofire.upload(movieURL, to: url, method: .post, headers: headers).uploadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
//                            print("Upload Progress: \(progress.fractionCompleted)")
//                        }
//                        .downloadProgress { progress in // called on main queue by default
//                            print("Download Progress: \(progress.fractionCompleted)")
//                        }
//                        .validate { request, response, data in
//                            // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
//                            return .success
//                        }
//                        .responseJSON { response in
//                            debugPrint(response)
//                    }

        
//        Alamofire.upload(url, to: url, method: .post , headers : headers)
//            .uploadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
//                print("Upload Progress: \(progress.fractionCompleted)")
//            }
//            .downloadProgress { progress in // called on main queue by default
//                print("Download Progress: \(progress.fractionCompleted)")
//            }
//            .validate { request, response, data in
//                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
//                return .success
//            }
//            .responseJSON { response in
//                debugPrint(response)
//        }
        

    }
    
    func GetRegApi( urlString: NSString, dict: NSDictionary , withCompletionHandler:@escaping (_ result:NSDictionary ) -> Void) {
        _ = Alamofire.request("https://httpbin.org/get", parameters: ["foo": "bar"])

//        Alamofire.request(urlString, method: .get, parameters: dict, encoding: JSONEncoding.default)
//            .downloadProgress(queue: DispatchQueue.utility) { progress in
//                print("Progress: \(progress.fractionCompleted)")
//            }
//            .validate { request, response, data in
//                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
//                return .success
//            }
//            .responseJSON { response in
//                debugPrint(response)
//        }
    }

    func OKAlertController(Message : String , alertMsg : String)  {
        let alert = UIAlertController.init(title: alertMsg, message: Message, preferredStyle: .alert)
        
        let Ok = UIAlertAction.init(title: "OK", style: .cancel) { (sender) in
            
        }
        alert.addAction(Ok)
        
        var topController = UIApplication.shared.keyWindow!.rootViewController!
        
        while ((topController.presentedViewController) != nil) {
            topController = topController.presentedViewController!;
        }
        topController.present(alert, animated:true, completion:nil)
        //        alert.present(alert, animated: true, completion: nil)
        
    }
    func ToastAlertController(Message : String , alertMsg : String)  {
        let alert = UIAlertController.init(title: alertMsg, message: Message, preferredStyle: .alert)
        
        
        let when = DispatchTime.now() + 1.5
        DispatchQueue.main.asyncAfter(deadline: when)
        {
            // your code with delay
            alert.dismiss(animated: true, completion: nil)
        }
        
        var topController = UIApplication.shared.keyWindow!.rootViewController!
        
        while ((topController.presentedViewController) != nil) {
            topController = topController.presentedViewController!;
        }
        topController.present(alert, animated:true, completion:nil)
        //        alert.present(alert, animated: true, completion: nil)
        
    }
//    func FirstLeterUpperCase(text : String) -> String {
//        
//        if text. != "" {
//        return text.substring(to: 1).uppercased()? + (text.substring(from: 1))
//        }
//        else{
//            return ""
//        }
//    }
}
