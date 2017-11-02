//
//  LoginController.swift
//  hala
//
//  Created by MAC on 28/09/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import IQKeyboardManagerSwift
import FTIndicator
import TwitterKit

class LoginController: UIViewController  , FBSDKLoginButtonDelegate ,UITextFieldDelegate{
    
    @IBOutlet weak var txtFldEmail: UITextField!
    @IBOutlet weak var txtFldPassword: UITextField!
    @IBOutlet weak var btnlogin: UIButton!
    @IBOutlet weak var btnFb: UIButton!
    @IBOutlet weak var btnTwitter: UIButton!
    
    var dataModel = DataModel()
    
    let graphRequestParameters = ["fields": "name, birthday, first_name, last_name, gender, location, hometown, relationship_status, email, work, education, photos"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        
        
        let emailString = NSLocalizedString("Email", comment: "")
        let passString = NSLocalizedString("Password", comment: "")

        
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        txtFldEmail.attributedPlaceholder = NSAttributedString(string: emailString,
                                                               attributes: [NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.6)])
        txtFldPassword.attributedPlaceholder = NSAttributedString(string: passString,
                                                                  attributes: [NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.6)])
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func actionSignUp(_ sender: Any) {
        self.performSegue(withIdentifier: "Register", sender: self)
    }
    
    //Mark: Fb Login
    @IBAction func actionLoginFB(_ sender: Any) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                
                self.getFBUserData()
                
            }
        }
    }
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    //everything works print the user data
                    print(result!)
                    let data = result as! NSDictionary
                    
                    var email : String = ""
                    if data.value(forKey: "email") is String{
                        email = data.value(forKey: "email") as! String
                    }
                    
                    self.FbTwittLogin(name: data.value(forKey: "name") as! String, email: email, id: data.value(forKey: "id") as! String, fName: "", lName: "",type: "fb")
                }
            })
        }
    }
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
 
        
        if (error != nil) {
            NSLog("Error in Facebook Login \(error.localizedDescription)")
        } else if result.isCancelled {
            NSLog("User Canceled The Login")
        } else {
            if result.grantedPermissions.contains("email")
            {
                print(result.grantedPermissions)
                NSLog("Got email access")
                graphRequestToReturnUserData(graphParameters: graphRequestParameters)
            }
        }
    }
    func graphRequestToReturnUserData(graphParameters: [String:String])
    {
        let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: graphParameters)
        graphRequest.start(completionHandler: {
            (connection, result, error) -> Void in
            if ((error) != nil) {
                NSLog("Error For Facebook: \(error?.localizedDescription)") //Error Handling
            } else {
                print(result!) //or assign it to a variable using facebookData = result as! Dictionary
                
                
                
            }
        })
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!)
    {
        print("User Logged Out")
    }
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                
            }
        })
    }
    
    // Mark:- Twitter Login
    @IBAction func actionLoginTwitter(_ sender: Any) {
        Twitter.sharedInstance().logIn(completion: { (session, error) in
            if (session != nil) {
                self.FbTwittLogin(name: (session?.userName)!, email: "", id: (session?.userID)!, fName: "", lName: "" , type: "twitter")
            } else{
                print("error: \(error?.localizedDescription)");
            }
        })
    }
    
    func FbTwittLogin(name : String , email: String , id : String ,  fName : String  ,lName : String , type : String)  {
        
        
        
        var DToken : String = "123456"
        if let token = UserDefaults.standard.object(forKey: "DToken") as? String{
            DToken = token
        }
        
        if let lang = UserDefaults.standard.object(forKey: "lang") as? String{

        
        let param = ["id" : id ,"name": name , "type": type ,"deviceToken":DToken  , "deviceType":"ios", "email" : email, "dob" : "", "gender" :  "","lang": lang] as [String : Any]
        let urlString = URLConstants.baseUrl + URLConstants.socialLogin
        ServerData.postResponseFromURL(urlString: urlString, showIndicator: true, params: param as! [String : String]) { (dataDictionary) in
            print(dataDictionary)
            
            if let status = dataDictionary["response"] as? String{
                if status == "1"{
                    let data = dataDictionary["data"] as! NSDictionary
                    UserDefaults.standard.set(data["id"]!, forKey: "user_id")
                    UserDefaults.standard.synchronize()
                    
                    let dict : NSDictionary = data.RemoveNullValueFromDic()
                    UserDefaults.standard.set(dict, forKey: "User")
                    UserDefaults.standard.synchronize()
                    
                    let app : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    app.goHomeController()
                }
            }
        }
    }
    }
    
    @IBAction func ForgotPassword(_ sender: Any) {
        self.performSegue(withIdentifier: "ForgotPasswordViewController", sender: self)

    }
    
    //Mark:- Login
    @IBAction func actionLogin(_ sender: Any)
    {
        if txtFldEmail.text!.isEmpty || txtFldPassword.text!.isEmpty{
            FTIndicator.showToastMessage("Please Enter the required credentials")
            return
        }
        if txtFldEmail.text!.isEmail == false{
            FTIndicator.showToastMessage("Please Enter the valid email")
            return
        }
        if txtFldPassword.text!.characters.count < 6{
            FTIndicator.showToastMessage("Password must have 6 characters")
            return
        }
        self.view.endEditing(true)
        signIn()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
    }
    
    override var prefersStatusBarHidden: Bool{
        return false
    }
    
    func signIn() {
        
        var DToken : String = "123456"
        if let token = UserDefaults.standard.object(forKey: "DToken") as? String{
            DToken = token
        }
        
        var langParam : String = "en"
        if let lang = UserDefaults.standard.object(forKey: "lang") as? String{
            langParam = lang
            
        }
        
        
        let urlString = URLConstants.baseUrl + URLConstants.loginApi
        let param = ["email" : txtFldEmail.text! ,"pass": txtFldPassword.text! , "type": "2" ,"deviceToken":DToken  , "deviceType":"ios" ,"lang":langParam]
        
        ServerData.postResponseFromURL(urlString: urlString, showIndicator: true, params: param) { (dataDictionary) in
            
            if let response = dataDictionary["response"] as? String{
                if response == "1"{
                    let data = dataDictionary["data"] as! NSDictionary
                    
                    let dict : NSDictionary = data.RemoveNullValueFromDic()
                    UserDefaults.standard.set(dict, forKey: "user_profile")
                    UserDefaults.standard.set(data["id"]!, forKey: "user_id")
                    UserDefaults.standard.synchronize()
                    
                    
                    UserDefaults.standard.set(dict, forKey: "User")
                    UserDefaults.standard.synchronize()
                    
                    
                    let app : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    app.goHomeController()
                    
                }else{
                    if let mesg = dataDictionary["mesg"] as? String{
                        FTIndicator.showToastMessage(mesg)
                    }
                }
            }
            
            
        }
        
        
        
        
        
       
        
        
    }
    
}
