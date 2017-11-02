//
//  ServerData.swift
//  TextFieldValidations
//
//  Created by ok on 9/14/17.
//  Copyright © 2017 Praveen. All rights reserved.
//

import UIKit
import Alamofire
import FTIndicator
import Foundation

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

class ServerData: NSObject {

    // MARK: GETFROMSERVER
    class func getResponseFromURL(urlString: String,loaderNeed: Bool,  completion: @escaping (_ success: [String : AnyObject]) -> Void){
        if Connectivity.isConnectedToInternet {
            if loaderNeed{
                FTIndicator.showProgress(withMessage: DefinedStrings.loaderText)
            }
            print(urlString)
            Alamofire.request(urlString  , method: .get , parameters: nil).responseJSON { response in
                if loaderNeed{
                    FTIndicator.dismissProgress()
                }
                if let JSON = response.result.value {
                    //print("JSON: \(JSON)")
                    completion(JSON as! [String : AnyObject])
                }
                else{
                   // FTIndicator.showError(withMessage: DefinedStrings.serverError)
                }
            }

        }else{
            if loaderNeed{
                FTIndicator.dismissProgress()
            }
            FTIndicator.showError(withMessage: DefinedStrings.internetError)
        }
    }
    
    // MARK: POSTTOSERVER
    class func postResponseFromURL(urlString: String, showIndicator : Bool, params : [String : String],  completion: @escaping (_ success: [String : AnyObject]) -> Void){
        
        
        
        
        if Connectivity.isConnectedToInternet {
            if showIndicator == true{
               FTIndicator.showProgress(withMessage: DefinedStrings.loaderText)
            }
            
            Alamofire.request(urlString  , method: .post , parameters: params).responseJSON { response in
                
                if showIndicator{
                    FTIndicator.dismissProgress()
                }
                
                if let JSON = response.result.value {
                    //print("JSON: \(JSON)")
                
                    completion(JSON as! [String : AnyObject])
                }
                else{
                   // FTIndicator.showError(withMessage: DefinedStrings.serverError)
                }
            }
        }else{
            FTIndicator.showError(withMessage: DefinedStrings.internetError)
        }
    }
    

    
    // MARK: UPLOADTOSERVER
    class func uploadTaskFor(URLString : String , parameters : [String : String] , file : UIImage?, showIndicator : Bool , completion: @escaping (_ success: [String : AnyObject]) -> Void){
        
        if Connectivity.isConnectedToInternet{
        
        Alamofire.upload(
            multipartFormData: { MultipartFormData in
                for (key, value) in parameters {
                    MultipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
                
                if file != nil{
                     MultipartFormData.append(UIImageJPEGRepresentation(file!, 1)!, withName: "image", fileName: "group.jpg", mimeType: "image/jpg")
                }
                
//                MultipartFormData.append(UIImageJPEGRepresentation(UIImage(named: "1.png")!, 1)!, withName: "photos[2]", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
                
                
        }, to: URLString) { (result) in
            FTIndicator.dismissProgress()
            switch(result) {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    let json = response.result.value
                    completion(json as! [String : AnyObject])
                }
                break;
            case .failure(_):
          //      FTIndicator.showError(withMessage: DefinedStrings.serverError)
                break;
            }
        }
        }else{
            FTIndicator.showError(withMessage: DefinedStrings.internetError)
        }
        
    }
    
    class func uploadProfileImage(URLString : String , header : String , file : UIImage,  completion: @escaping (_ success: [String : AnyObject]) -> Void){
        let headers: HTTPHeaders = [
            "Authorization": header,
            "Accept": "application/json"
        ]
        Alamofire.upload(multipartFormData:{ multipartFormData in
            multipartFormData.append(UIImageJPEGRepresentation(file, 1)!, withName: "picture", fileName: "picture.png", mimeType: "image/png")},
                         usingThreshold:UInt64.init(),
                         to:URLString,
                         method:.post,
                         headers:headers,
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.responseJSON { response in
                                    completion(["Status" : "Completed" as AnyObject])
                                }
                            case .failure(let encodingError):
                                print(encodingError)
                                FTIndicator.showToastMessage("Error  Uploading Image")
                            }
        })
            
    }
    
    
    
    class func stopAllSessions() {
    }
 
}
