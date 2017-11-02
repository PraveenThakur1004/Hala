//
//  CreatGroupController.swift
//  hala
//
//  Created by MAC on 10/10/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import FTIndicator
import Alamofire
import JHTAlertController

class CreatGroupController: UIViewController , UITextViewDelegate{

     var picker:UIImagePickerController?=UIImagePickerController()
    @IBOutlet weak var groupNameTxtField: UITextField!
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var textter: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textter.text = NSLocalizedString("Describe a group", comment: "")
        textter.textColor = UIColor.lightGray
        
        
        let backBtn : UIButton = UIButton(frame : CGRect(x:0,y:0,width: 44, height :44))
        backBtn.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        backBtn.addTarget(self, action: #selector(CreatGroupController.backTap), for: .touchDown)
        let barButton : UIBarButtonItem = UIBarButtonItem(customView : backBtn)
        self.navigationItem.leftBarButtonItem = barButton

        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapgroupImageView(_:)))
        groupImageView.isUserInteractionEnabled = true
        groupImageView.addGestureRecognizer(tapGesture)

        groupImageView.layer.cornerRadius = groupImageView.frame.size.width / 2
        groupImageView.clipsToBounds = true

        groupImageView.layer.borderColor = GlobalConstants.DEFAULT_COLOR_BRINJAL.cgColor
        groupImageView.layer.borderWidth = 1.0
        
        
        self.title = NSLocalizedString(DefinedStrings.createGroup, comment: "")
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createAction(_ sender: Any) {
        var desc : String = textter.text
        if textter.text == NSLocalizedString("Describe a group", comment: ""){
            desc = ""
        }
        
        
        if groupNameTxtField.text?.characters.count == 0{
    FTIndicator.showToastMessage(DefinedStrings.groupNameError)
            return
        }
        
        if let userId = UserDefaults.standard.object(forKey: "user_id") as? String{
            if let lang = UserDefaults.standard.object(forKey: "lang") as? String{

            let urlString : String = URLConstants.baseUrl + URLConstants.createGroup
            let param : NSDictionary = ["user_id":userId,"lang":lang,"name":groupNameTxtField.text!,"description":desc]
            
            FTIndicator.showProgress(withMessage: DefinedStrings.creatingGroup)
            
            let imgData = UIImageJPEGRepresentation(groupImageView.image!, 1.0)
            
            
            
   
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    
                    
                    multipartFormData.append(imgData!, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")


                    multipartFormData.append(userId.data(using: .utf8)!, withName: "user_id")
              
                    multipartFormData.append(self.groupNameTxtField.text!.data(using: .utf8)!, withName: "name")
                    
                    multipartFormData.append(desc.data(using: .utf8)!, withName: "description")
               
                    let lang = "en"
                    multipartFormData.append(lang.data(using: .utf8)!, withName: "lang")
                    
            },
                to: urlString ,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _,_ ):
                        upload.responseJSON { response in
                            debugPrint(response)
                            FTIndicator.dismissProgress()
                            if response.result .isSuccess{
                                FTIndicator.showToastMessage(DefinedStrings.groupCreated)
                                self.navigationController?.popViewController(animated: true)
                            }
                            else{
                                
                            }
                            }.uploadProgress { progress in // main queue by default
                                print(Float(progress.fractionCompleted) * 100)
                        }
                    case .failure(let encodingError):
                        print(encodingError)
                    }
            }
            )
            
            
//            ServerData.uploadTaskFor(URLString: urlString, parameters: param as! [String : String], file: groupImageView.image, showIndicator: true, completion: { (dataDictionary) in
//                print(dataDictionary)
//                FTIndicator.dismissProgress()
//                FTIndicator.showToastMessage("Group Created")
//                self.navigationController?.popViewController(animated: true)
//            })
            
            
//            ServerData.postResponseFromURL(urlString: urlString, showIndicator: true, params: param as! [String : String]) { (dataDictionary) in
//
//            }
        }
        }
    }
    
    
    
    func creationMethod(){
        
       
        
       
        
        
        
    }
    
    
    
    @objc func tapgroupImageView(_ sender: UITapGestureRecognizer) {
        
        let alertController = JHTAlertController(title: "", message: DefinedStrings.selecteImage, preferredStyle: .alert)
        alertController.titleImage = #imageLiteral(resourceName: "alertHead")
        alertController.titleViewBackgroundColor =  UIColor(red:65/255.0, green :4/255.0, blue :85/255.0,alpha :1.0)
        alertController.alertBackgroundColor = UIColor(red:65/255.0, green :4/255.0, blue :85/255.0,alpha :1.0)
        alertController.setAllButtonBackgroundColors(to: UIColor(red:253/255.0, green :200/255.0, blue :118/255.0,alpha :1.0))
        alertController.hasRoundedCorners = true
        
        // Create the action.
        
        let camAction = JHTAlertAction(title: DefinedStrings.cameraString, style: .default) { _ in
            
            self.openCamera()
        }
        let galAction = JHTAlertAction(title: DefinedStrings.galleryString, style: .default) { _ in
            
            self.openGallary()
            
        }
        let cancelAction = JHTAlertAction(title: DefinedStrings.cancelString, style: .default) { _ in
            
            
        }
        alertController.addAction(camAction)
        alertController.addAction(galAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: {
            
        })
    }
    
    
    @objc func backTap(){
        self.navigationController?.popViewController(animated: true)
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
            FTIndicator.showToastMessage(DefinedStrings.hasNoCamera)
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGray
        }
    }

}
extension CreatGroupController :  UIImagePickerControllerDelegate , UINavigationControllerDelegate ,UIPopoverControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        picker.dismiss(animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.groupImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        picker.dismiss(animated: true) {
        }
    }
}
