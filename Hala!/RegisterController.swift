//
//  RegisterController.swift
//  hala
//
//  Created by MAC on 28/09/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import Alamofire
import FTIndicator
import JHTAlertController

class RegisterController: UIViewController  ,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate{
    
    
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnImage: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var txtFldDOB: UITextField!
    @IBOutlet weak var txtFldCaptha: UITextField!
    @IBOutlet weak var txtFldCnfrmPaswrd: UITextField!
    @IBOutlet weak var txtFldPassword: UITextField!
    @IBOutlet weak var txtFldEmail: UITextField!
    @IBOutlet weak var txtFldName: UITextField!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var captchaLabel: UILabel!

    var picker:UIImagePickerController?=UIImagePickerController()

    
    var gender: String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.captchaLabel.text = self.randomString(length: 5).uppercased()
        
        btnFemale.setImage(#imageLiteral(resourceName: "radio-uncheck"), for: .normal)
        btnMale.setImage(#imageLiteral(resourceName: "radio-uncheck"), for: .normal)
        self.navigationController?.isNavigationBarHidden = true
        imgProfile.layer.cornerRadius = 50.0
        imgProfile.layer.masksToBounds = true
        btnSignUp.layer.cornerRadius = 20.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    let datePicker = UIDatePicker()
    
    
    
    @IBAction func actionChooseDOB(_ sender: Any) {
        showDatePicker()
    }
    @IBAction func actionDOB(_ sender: Any) {
        showDatePicker()
    }
    func showDatePicker(){
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(RegisterController.donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(RegisterController.cancelDatePicker))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        txtFldDOB.inputAccessoryView = toolbar
        txtFldDOB.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        txtFldDOB.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    
    
    
    
    //MARK:- Choose Gender
    @IBAction func actionChooseMale(_ sender: Any)
    {
        gender = ""
        btnMale.setImage(#imageLiteral(resourceName: "radio-check"), for: .normal)
        btnFemale.setImage(#imageLiteral(resourceName: "radio-uncheck"), for: .normal)
        gender = "1"
    }
    @IBAction func actionChooseFemale(_ sender: Any)
    {
        gender = ""
        btnMale.setImage(#imageLiteral(resourceName: "radio-uncheck"), for: .normal)
        btnFemale.setImage(#imageLiteral(resourceName: "radio-check"), for: .normal)
        gender = "2"
    }
    
    
    
    
    // MARK:- Choose Image
    @IBAction func actionChooseImage(_ sender: Any) {
        
        
        let alertController = JHTAlertController(title:  "", message:DefinedStrings.selecteImage , preferredStyle: .alert)
        alertController.titleImage = #imageLiteral(resourceName: "alertHead")
        alertController.titleViewBackgroundColor =  UIColor(red:65/255.0, green :4/255.0, blue :85/255.0,alpha :1.0)
        alertController.alertBackgroundColor = UIColor(red:65/255.0, green :4/255.0, blue :85/255.0,alpha :1.0)
        alertController.setAllButtonBackgroundColors(to: UIColor(red:253/255.0, green :200/255.0, blue :118/255.0,alpha :1.0))
        alertController.hasRoundedCorners = true
        let galAction = JHTAlertAction(title: DefinedStrings.galleryString, style: .default) { _ in
            self.openGallary()

        }
        let camAction = JHTAlertAction(title:DefinedStrings.cameraString, style: .default) { _ in
            self.openCamera()

        }
        let cancelAction = JHTAlertAction(title: DefinedStrings.cancelString, style: .cancel) { _ in
        }
        alertController.addAction(galAction)
        alertController.addAction(camAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: {
        })
        
    

    }
    func openGallary()
    {
        picker!.allowsEditing = false
        picker?.delegate = self
        picker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(picker!, animated: true, completion: nil)
    }
    
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            picker!.allowsEditing = false
            picker?.delegate = self
            picker!.sourceType = UIImagePickerControllerSourceType.camera
            picker!.cameraCaptureMode = .photo
            present(picker!, animated: true, completion: nil)
        }else{
            
            
            let alertController = JHTAlertController(title:  DefinedStrings.noCam, message:DefinedStrings.hasNoCamera , preferredStyle: .alert)
            alertController.titleImage = #imageLiteral(resourceName: "alertHead")
            alertController.titleViewBackgroundColor =  UIColor(red:65/255.0, green :4/255.0, blue :85/255.0,alpha :1.0)
            alertController.alertBackgroundColor = UIColor(red:65/255.0, green :4/255.0, blue :85/255.0,alpha :1.0)
            alertController.setAllButtonBackgroundColors(to: UIColor(red:253/255.0, green :200/255.0, blue :118/255.0,alpha :1.0))
            alertController.hasRoundedCorners = true

            let cancelAction = JHTAlertAction(title: DefinedStrings.cancelString, style: .cancel) { _ in
            }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: {
            })
            

        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imgProfile.contentMode = .scaleAspectFit
            imgProfile.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    //Mark:- SignUp
    @IBAction func actionSignUp(_ sender: Any)
    {
        
        let value = self.txtFldEmail.text!
        let boolFirst =  self.isValidEmail(testStr: value )
        print(boolFirst)
        
        if (txtFldName.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            alert(title: "Name")
        }
        else if (txtFldEmail.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            alert(title: "Email")
        }
        else if (boolFirst == false) {
            alert(title: "valid email")
        }
        else if (txtFldPassword.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            alert(title: "Password")
        }
        else if (txtFldCnfrmPaswrd.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            alert(title: "Confirm Password")
        }
        else if (txtFldPassword.text != txtFldCnfrmPaswrd.text) {
            alert(title: "comfirm passowrd correct")
        }
        else if (txtFldCaptha.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            alert(title: "captha")
        }
        else if (captchaLabel.text! != txtFldCaptha.text!){
            alert(title: "captha")
        }
        else {
            signUp()
        }
    }
    func alert(title:String)
    {
        
        let alertController = JHTAlertController(title:  "Alert", message:"Enter \(title)" , preferredStyle: .alert)
        alertController.titleImage = #imageLiteral(resourceName: "alertHead")
        alertController.titleViewBackgroundColor =  UIColor(red:65/255.0, green :4/255.0, blue :85/255.0,alpha :1.0)
        alertController.alertBackgroundColor = UIColor(red:65/255.0, green :4/255.0, blue :85/255.0,alpha :1.0)
        alertController.setAllButtonBackgroundColors(to: UIColor(red:253/255.0, green :200/255.0, blue :118/255.0,alpha :1.0))
        alertController.hasRoundedCorners = true
        
        let cancelAction = JHTAlertAction(title: "Ok", style: .cancel) { _ in
        }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: {
        })

    }
    func isValidEmail(testStr:String) -> Bool
    {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
  

    
    // Mark:- Function SignUp
    func signUp() {
        
        FTIndicator.showProgress(withMessage: "Uploading")
        
        //var dict : NSDictionary!
        //let imageData = UIImagePNGRepresentation(imgProfile!.image!) as! Data!
        let imgData = UIImageJPEGRepresentation(imgProfile!.image!, 0.5)
        
        var url : String = "http://nimbyisttechnologies.com/himanshu/hala/api/apis/registerUser"
        
        
        url = url.replacingOccurrences(of: " ", with: "%20")
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                //                for (key, value) in dict {
                //                    print("\(value)--------\(key)")
                //                    multipartFormData.append((value as! String).data(using: .utf8)!, withName: key as! String)
                //                }
                
 
                
                multipartFormData.append(self.txtFldName.text!.data(using: .utf8)!, withName: "name")
                multipartFormData.append(self.txtFldEmail.text!.data(using: .utf8)!, withName: "email")
                multipartFormData.append(self.txtFldPassword.text!.data(using: .utf8)!, withName: "password")
                multipartFormData.append("\(self.gender )".data(using: .utf8)!, withName: "gender")
                multipartFormData.append(self.txtFldDOB.text!.data(using: .utf8)!, withName: "dob")
                multipartFormData.append(imgData!, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
                let lang : String = "en"
                multipartFormData.append(lang.data(using: .utf8)!, withName: "lang")
                
                
                
                
                //                multipartFormData.append((name.data(using: .utf8)!) , withName: "name")
                
        },
            to: url ,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _,_ ):
                    upload.responseJSON { response in
                        debugPrint(response)
                        
                       FTIndicator.dismissProgress()
                        
                        if response.result .isSuccess{
                            
                            FTIndicator.showToastMessage("You are registered successfully. \n Please login to continue")
                            
                            self.dismiss(animated: true, completion: nil)
//                            let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
//                            self.navigationController?.pushViewController(secondVC, animated: true)
                        }
                        else{
                            
                        }
                        
                        
                        
                        
                        }.uploadProgress { progress in // main queue by default
                            //  print("Upload Progress: \(progress.fractionCompleted)")
                            //                        CircularSpinner.frame
                            
                            print(Float(progress.fractionCompleted) * 100)
                            
                            //let per = Int(Float(progress.fractionCompleted) * 100)
                            
                            
                            //    NVActivityIndicatorPresenter.sharedInstance.setMessage("  \(per)%")
                            //                          let alert = UIAlertController(title: "", message: "\(per)", preferredStyle: UIAlertControllerStyle.alert)
                            //
                            //                        self.present(alert, animated: true, completion: nil)
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    FTIndicator.dismissProgress()
                    
                }
        }
        )
        
        
    }
    
    
    
}
