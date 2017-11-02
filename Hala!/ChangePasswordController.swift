//
//  ChangePasswordController.swift
//  hala
//
//  Created by MAC on 03/10/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import FTIndicator

class ChangePasswordController: UIViewController {
    @IBOutlet weak var txt_oldPasswors: UITextField!
    @IBOutlet weak var txt_NewPassword: UITextField!
    @IBOutlet weak var txt_ConfirmPassword: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txt_oldPasswors.attributedPlaceholder = NSAttributedString(string: "Old Password",
                                                                   attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        txt_NewPassword.attributedPlaceholder = NSAttributedString(string: "New Password",
                                                                   attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        txt_ConfirmPassword.attributedPlaceholder = NSAttributedString(string: "Confirm Password",
                                                                   attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        // Do any additional setup after loading the view.
        
        let backBtn : UIButton = UIButton(frame : CGRect(x:0,y:0,width: 44, height :44))
        backBtn.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        backBtn.addTarget(self, action: #selector(SettingsController.backTap), for: .touchDown)
        let barButton : UIBarButtonItem = UIBarButtonItem(customView : backBtn)
        self.navigationItem.leftBarButtonItem = barButton
        
        self.title = "Change Password"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func backTap(){
        navigationController?.popViewController(animated: true)
    }
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    @IBAction func Submit(_ sender: Any) {

        if txt_oldPasswors.text?.characters.count == 0 {
            FTIndicator.showToastMessage("Please enter old password")
            return
        }
        if txt_NewPassword.text?.characters.count == 0 {
            FTIndicator.showToastMessage("Please enter new password")
            return
        }
       
        if txt_ConfirmPassword.text?.characters.count == 0{
            FTIndicator.showToastMessage("Please confirm new password")
            return
        }
        
        
        if txt_ConfirmPassword.text! != txt_NewPassword.text!{
            FTIndicator.showToastMessage("Password not confirmed")
            return
        }

        
        self.view.endEditing(true)
       if let userId = UserDefaults.standard.object(forKey: "user_id") as? String{
        if let lang = UserDefaults.standard.object(forKey: "lang") as? String{

        
            let param = ["user_id":userId,"oldPass":txt_oldPasswors.text!,"newPass":txt_NewPassword.text!,"lang":lang]
        let urlString : String = URLConstants.baseUrl + URLConstants.updatePassword
            ServerData.postResponseFromURL(urlString: urlString, showIndicator: true, params: param, completion: { (dataDictionary) in
                if let msg = dataDictionary["mesg"] as? String{
                    FTIndicator.showToastMessage(msg)
                }
            })
        }
        }
        
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
