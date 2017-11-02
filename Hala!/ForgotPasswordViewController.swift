//
//  ForgotPasswordViewController.swift
//  hala
//
//  Created by OSX on 20/09/17.
//  Copyright © 2017 OSX. All rights reserved.
//
import FTIndicator
import UIKit
class ForgotPasswordViewController: UIViewController {
    
    var dataModel = DataModel()
    
    @IBOutlet weak var txt_Email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        txt_Email.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                   attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Submit(_ sender: Any) {
        if let lang = UserDefaults.standard.object(forKey: "lang") as? String{

        let param = ["email" : txt_Email.text! , "type" : "2" ,"lang" : lang]
        let urlString : String = URLConstants.baseUrl + URLConstants.forgotPassword
        ServerData.postResponseFromURL(urlString: urlString, showIndicator: true, params: param) { (dataDictionary) in
            if let response = dataDictionary["response"] as? String{
                if response == "1"{
                    self.navigationController?.popViewController(animated: true)
                }
            }
            if let mess = dataDictionary["mesg"] as? String{
                FTIndicator.showToastMessage(mess)
            }
        }
        }
    }
    
    @IBAction func Back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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

