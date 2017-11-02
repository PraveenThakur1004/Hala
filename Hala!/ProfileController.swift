//
//  ProfileController.swift
//  hala
//
//  Created by MAC on 28/09/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import Alamofire
import FTIndicator
import FTPopOverMenu_Swift
import JHTAlertController


class ProfileController: UIViewController,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate {
    
    var universalTextField : UITextField!
    var universalPickerView = UIPickerView()
    var pickerArray : [String] = []
    var editingMode : Bool = false
    var itsMe : Bool = false
    var passedUser : UserDetail!
     var mySelf : UserDetail!
    
    @IBOutlet weak var kmLabel: UILabel!
    @IBOutlet weak var fbImage: UIImageView!
    @IBOutlet weak var maleFemale: UIImageView!
    @IBOutlet weak var starImage: UIImageView!


    var isUserImage : Bool = true

    @IBOutlet weak var chatBtn: UIButton!
    
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var imgProfileBG: UIImageView!
    
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var lblPoints: UILabel!
    @IBOutlet weak var c_introduction_h: NSLayoutConstraint!
    
    @IBOutlet weak var c_scroll_h: NSLayoutConstraint!
    @IBOutlet weak var ViewimgOuter: UIView!
    
    @IBOutlet weak var txtFldHeight: UITextField!
    
    @IBOutlet weak var txtFldAge: UITextField!
    @IBOutlet weak var txtFldId: UITextField!
    @IBOutlet weak var txtFldIntrestedIn: UITextField!
    @IBOutlet weak var txtFldEyeColor: UITextField!
    @IBOutlet weak var txtFldHairColor: UITextField!
    
    @IBOutlet weak var txtFldEthinicity: UITextField!
    @IBOutlet weak var txtVwIntro: UITextView!
    var editBtn : UIButton!
    @IBOutlet weak var txtFldBloodType: UITextField!
    @IBOutlet weak var txtFldSmoking: UITextField!
    @IBOutlet weak var txtFldDrinking: UITextField!
    @IBOutlet weak var txtFldHobby: UITextField!
    @IBOutlet weak var txtFldRelation: UITextField!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnChooseImage: UIButton!
    @IBOutlet weak var btnChooseBGImage: UIButton!
    @IBOutlet weak var reportBtn: UIButton!
    @IBOutlet weak var chatHeight: NSLayoutConstraint!
    @IBOutlet weak var viewIntro: UIView!
    
        @IBOutlet weak var onlineImageView: UIImageView!
        @IBOutlet weak var earnBtn: UIButton!
    
    //    let dict = UserDefaults.standard.value(forKey: "user_profile") as! NSDictionary
    var dataModel = DataModel()
  
    
    var picker:UIImagePickerController?=UIImagePickerController()
    
    var imgVar = Bool()

    var datePickerView = UIDatePicker()
    var Gender_array = [NSLocalizedString("Male", comment: ""),NSLocalizedString("Female", comment: ""),NSLocalizedString("Both", comment: ""),NSLocalizedString("Other", comment: "")]
    var smoking_array = [NSLocalizedString("Yes", comment: ""),NSLocalizedString("No", comment: ""),NSLocalizedString("Ocassionally", comment: "")]
    var drink_array = [NSLocalizedString("Yes", comment: ""),NSLocalizedString("No", comment: ""),NSLocalizedString("Ocassionally", comment: "")]
    var Hobby_array = [NSLocalizedString("Cricket", comment: ""),NSLocalizedString("Music", comment: ""),NSLocalizedString("Football", comment: ""),NSLocalizedString("Reading", comment: ""),NSLocalizedString("Sports", comment: "")]
    
        
        
    var relation_array = [NSLocalizedString("Single", comment: ""),NSLocalizedString("Married", comment: ""),NSLocalizedString("It's Complicated", comment: ""),NSLocalizedString("In a Relationship", comment: ""),NSLocalizedString("Engaged", comment: ""),NSLocalizedString("In a Domestic Partnership", comment: "")]
        
    var menuOptionArray = [NSLocalizedString("Add to hotlist", comment: ""),NSLocalizedString("View on map", comment: ""),NSLocalizedString("Block", comment: "")]
    
    var bloodArray = ["A+","A-","B+","B-","AB-","AB+","O+","O-"]
    var feetArray = [NSLocalizedString("4.0", comment: ""),NSLocalizedString("4.1", comment: ""),NSLocalizedString("4.2", comment: ""),NSLocalizedString("4.3", comment: ""),NSLocalizedString("4.4", comment: ""),NSLocalizedString("4.5", comment: ""),NSLocalizedString("4.6", comment: ""),NSLocalizedString("4.7", comment: ""),NSLocalizedString("4.8", comment: ""),NSLocalizedString("4.9", comment: ""),NSLocalizedString("4.10", comment: ""),NSLocalizedString("4.11", comment: ""),NSLocalizedString("5.0", comment: ""),NSLocalizedString("5.1", comment: ""),NSLocalizedString("5.2", comment: ""),NSLocalizedString("5.3", comment: ""),NSLocalizedString("5.4", comment: ""),NSLocalizedString("5.5", comment: ""),NSLocalizedString("5.6", comment: ""),NSLocalizedString("5.7", comment: ""),NSLocalizedString("5.8", comment: ""),NSLocalizedString("5.9", comment: ""),NSLocalizedString("5.10", comment: ""),NSLocalizedString("5.11", comment: ""),NSLocalizedString("6.0", comment: ""),NSLocalizedString("6.2", comment: ""),NSLocalizedString("6.1", comment: ""),NSLocalizedString("6.3", comment: ""),NSLocalizedString("6.4", comment: ""),NSLocalizedString("6.5", comment: ""),NSLocalizedString("6.6", comment: ""),NSLocalizedString("6.7", comment: ""),NSLocalizedString("6.8", comment: ""),NSLocalizedString("6.9", comment: ""),NSLocalizedString("6.10", comment: ""),NSLocalizedString("6.11", comment: ""),NSLocalizedString("7.0", comment: ""),NSLocalizedString("7.1", comment: ""),NSLocalizedString("7.2", comment: ""),NSLocalizedString("7.3", comment: ""),NSLocalizedString("7.4", comment: ""),NSLocalizedString("7.5", comment: ""),NSLocalizedString("7.6", comment: ""),NSLocalizedString("7.8", comment: ""),NSLocalizedString("7.9", comment: ""),NSLocalizedString("7.10", comment: "")]
    
    var ageArray : [String] = []

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        reportBtn.setTitle(NSLocalizedString("Report", comment: ""), for: .normal)
        
        self.title = "Profile"
          imgProfile.contentMode = .scaleToFill
        
        if let user = UserDefaults.standard.object(forKey: "User") as? NSDictionary{
            mySelf = UserDetail.init(user: user)
        }
        
        for i in 12 ..< 90 {
         ageArray.append("\(i)")
        }
        
        
        
        self.txtVwIntro.isUserInteractionEnabled = false
        self.txtFldBloodType.isUserInteractionEnabled = false
        self.txtFldEthinicity.isUserInteractionEnabled = false
        self.txtFldEyeColor.isUserInteractionEnabled = false
        self.txtFldHairColor.isUserInteractionEnabled = false
        self.txtFldHeight.isUserInteractionEnabled = false
        self.txtFldHobby.isUserInteractionEnabled = false
        self.txtFldRelation.isUserInteractionEnabled = false
        self.txtFldAge.isUserInteractionEnabled = false
        self.txtFldIntrestedIn.isUserInteractionEnabled = false
        self.txtFldDrinking.isUserInteractionEnabled = false
        self.txtFldSmoking.isUserInteractionEnabled = false
        self.txtFldBloodType.isUserInteractionEnabled = false
        
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        
        txtFldIntrestedIn.inputView = pickerView
        
        

        self.createPicker(textField: txtFldHeight)
        self.createPicker(textField: txtFldBloodType)
        self.createPicker(textField: txtFldHobby)
        self.createPicker(textField: txtFldSmoking)
        self.createPicker(textField: txtFldDrinking)
        self.createPicker(textField: txtFldRelation)
        self.createPicker(textField: txtFldRelation)
        self.createPicker(textField: txtFldAge)





//        txtFldAge.inputView = datePickerView
//        datePickerView.datePickerMode = .date
//        datePickerView.addTarget(self, action: #selector(ProfileController.handleDatePicker1), for: UIControlEvents.valueChanged)
        
        
        
        txtFldId.isUserInteractionEnabled = false
        imgProfile.layer.cornerRadius = imgProfile.frame.size.width / 2
        imgProfile.layer.masksToBounds = true
        ViewimgOuter.layer.cornerRadius = 40.0
        viewName.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        
        let backImage : UIImage = #imageLiteral(resourceName: "back")
        let backBtn : UIButton = UIButton(frame : CGRect(x:0,y:0,width: 44, height :44))
        if Locale.preferredLanguages[0].contains("ar"){
            backBtn.setImage(backImage.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
        }else{
            backBtn.setImage(backImage, for: .normal)
        }
        backBtn.addTarget(self, action: #selector(ProfileController.actionBack(_:)), for: .touchUpInside)
        let barButton1 : UIBarButtonItem = UIBarButtonItem(customView : backBtn)
        self.navigationItem.leftBarButtonItem = barButton1
        
        if itsMe == true{
            reportBtn.isHidden = true
            chatHeight.constant  = 0
            
            editBtn  = UIButton(frame : CGRect(x:0,y:0,width: 44, height :44))
            editBtn.setImage(#imageLiteral(resourceName: "nav_edit"), for: .normal)
            editBtn.addTarget(self, action: #selector(ProfileController.actionEdit(_:)), for: .touchUpInside)
            let barButton2 : UIBarButtonItem = UIBarButtonItem(customView : editBtn)
            self.navigationItem.rightBarButtonItem = barButton2
            
            
            earnBtn.isHidden = false
            lblPoints.isHidden = false
            btnChooseImage.isHidden = true
            btnChooseBGImage.isHidden = true
            onlineImageView.isHidden = true

            
        }else{

            reportBtn.isHidden = false
            chatHeight.constant  = 44

            
             let profileBtn : UIButton  = UIButton(frame : CGRect(x:0,y:0,width: 34, height :34))
            profileBtn.setImage(#imageLiteral(resourceName: "nav_menu"), for: .normal)
            profileBtn.setImage(#imageLiteral(resourceName: "menu"), for: .selected)
            profileBtn.setImage(#imageLiteral(resourceName: "menu"), for: .highlighted)
            profileBtn.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            profileBtn.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            profileBtn.addTarget(self, action: #selector(ProfileController.profileAction(_:)), for: .touchDown)
            let barButton3 : UIBarButtonItem = UIBarButtonItem(customView : profileBtn)
            self.navigationItem.rightBarButtonItems = [barButton3]
            
            earnBtn.isHidden = true
            lblPoints.isHidden = true
            btnChooseImage.isHidden = true
            btnChooseBGImage.isHidden = true
                     lblPoints.isHidden = true
            if passedUser.online == true{
                onlineImageView.isHidden = false
            }else{
                onlineImageView.isHidden = true
            }
            
            self.chatBtn.setBackgroundImage(#imageLiteral(resourceName: "create_group"), for: .normal)
            self.chatBtn.setTitle(NSLocalizedString("Chat", comment: ""), for: .normal)
            self.chatBtn.backgroundColor = UIColor.clear

            let favStatus : String = passedUser.favourate
            if favStatus == "1"{
                menuOptionArray = [NSLocalizedString("Remove from hotlist", comment: ""),NSLocalizedString("View on map", comment: ""),NSLocalizedString("Block", comment: "")]
                
            }
            if favStatus == "2"{
                
                self.chatBtn.setBackgroundImage(UIImage(named : ""), for: .normal)
                self.chatBtn.setTitle(NSLocalizedString("Blocked", comment: ""), for: .normal)
                self.chatBtn.backgroundColor = UIColor.red
                
                menuOptionArray = [NSLocalizedString("Unblock", comment: "")]
            }
        }
        
        
     
        lblName.text = passedUser.name
        txtFldId.text! = passedUser.uid
        txtFldDrinking.text! = passedUser.drinks
        txtFldIntrestedIn.text! = passedUser.intrested
        
        lblPoints.text = passedUser.point
        
        kmLabel.text = passedUser.distance
        if itsMe == true{
            kmLabel.isHidden = true
        }
        
        
        if passedUser.gender == true{
            maleFemale.image = #imageLiteral(resourceName: "male")
        }else{
            maleFemale.image = #imageLiteral(resourceName: "female")
        }
        
        if passedUser.online == true{
            onlineImageView.isHidden = false
        }else{
            onlineImageView.isHidden = true
        }
        
        
        let origImageFB = #imageLiteral(resourceName: "home_fb")
        let tintedImage = origImageFB.withRenderingMode(.alwaysTemplate)
        
        let origImageTW = #imageLiteral(resourceName: "home_tw")
        let tintedImageTW = origImageTW.withRenderingMode(.alwaysTemplate)
        
        
   
        if passedUser.social_type == "twitter"{
            fbImage.image = tintedImageTW
            fbImage.tintColor =  GlobalConstants.FB_COLOR
        }
        else if passedUser.social_type == "fb"{
            fbImage.image = tintedImage
            fbImage.tintColor =  GlobalConstants.TW_COLOR

        }else{
            fbImage.image = UIImage(named : "")
            fbImage.tintColor = UIColor.clear
        }
        
        let origImageHot = #imageLiteral(resourceName: "ic_hotlist")
        let tintedImageHot = origImageHot.withRenderingMode(.alwaysTemplate)
        
        if let fav = passedUser.favourate{
            if fav == "0"{
                print("None")
                starImage.image = tintedImageHot
                starImage.tintColor = UIColor.clear
            }else if fav == "1"{
                print("Favorite")
                starImage.image = #imageLiteral(resourceName: "hotter")
            }else if fav == "2"{
                print("Blocked")
                starImage.image = tintedImageHot
                starImage.tintColor = UIColor.clear
            }
        }else{
            starImage.image = tintedImageHot
            starImage.tintColor = UIColor.clear
        }
        
        
        
        
        
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        let startTime = Date()
         let endTime = dateFormatter.date(from: passedUser.dob)
        
        if endTime == nil{
            txtFldAge.text! = "0"
            lblAge.text = "0 Years"
            
            let components : NSArray  = passedUser.ethinicity.components(separatedBy: "-") as NSArray
                if components.count == 2{
                    txtFldAge.text! = components[1] as! String
                    lblAge.text = "\(components[1]) \(DefinedStrings.years)"
                }
            
        }else{
            let calender:Calendar = Calendar.current
            let components: DateComponents = calender.dateComponents([.year, .month, .day, .hour, .minute, .second], from: endTime!, to: startTime)
            txtFldAge.text! = "\(components.year!)"
            lblAge.text = txtFldAge.text! + " \(DefinedStrings.years)"
        }
        
        if txtFldAge.text! == "0"{
            let components : NSArray  = passedUser.ethinicity.components(separatedBy: "-") as NSArray
            if components.count > 1{
                txtFldAge.text! = components.lastObject as! String
                lblAge.text = "\(components.lastObject as! String) \(DefinedStrings.years)"
                txtFldEthinicity.text! = components.firstObject as! String
            }else{
                txtFldEthinicity.text! = passedUser.ethinicity
            }
        }
        
        

        txtFldRelation.text! = passedUser.relationship
        txtFldHobby.text! = passedUser.hobby
        txtFldHeight.text! = passedUser.height
        txtFldHairColor.text! = passedUser.hairColor
        txtFldEyeColor.text! = passedUser.eyeColor
        txtFldBloodType.text! = passedUser.bloodGroup
        txtVwIntro.text! = passedUser.introduction
        
        
        
        
        
        
        
        let drinkValue : String = passedUser.smoke
        let smokeValue : String = passedUser.drinks
        
        
        switch drinkValue {
        case "0":
            txtFldDrinking.text = NSLocalizedString("No", comment: "")

            break;

              case "1":
                txtFldDrinking.text = NSLocalizedString("Yes", comment: "")

                break;
              case "2":
                txtFldDrinking.text = NSLocalizedString("Ocassionally", comment: "")

                break;
        default:
            txtFldDrinking.text = NSLocalizedString("No", comment: "")

            break;
        }
        
        
        switch smokeValue {
        case "0":
            txtFldSmoking.text = NSLocalizedString("No", comment: "")
            break;
        case "1":
            txtFldSmoking.text = NSLocalizedString("Yes", comment: "")


            break;
        case "2":
            txtFldSmoking.text = NSLocalizedString("Ocassionally", comment: "")

            break;
        default:
            txtFldSmoking.text = NSLocalizedString("No", comment: "")

            break;
        }
        
      
        
        if let imageURL = URL(string : URLConstants.imageBase + passedUser.image){
            imgProfile.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "user_default"))
        }
        if let backimageURL = URL(string : URLConstants.imageBase + passedUser.backgroundImage){
            imgProfileBG.sd_setImage(with: backimageURL, placeholderImage: #imageLiteral(resourceName: "user_default"))
        }

    }
    
    func createPicker(textField : UITextField){
        universalPickerView = UIPickerView()
        universalPickerView.delegate = self
        textField.inputView = universalPickerView
    }
    
    
    
    @IBAction func chatAction(_ sender: UIButton)
    {
        let str : String = (sender.titleLabel?.text!)!
        if str == "Chat"{
            self.performSegue(withIdentifier: "Chat", sender: self)
            
            UserDefaults.standard.set("Update", forKey: "ChatUpdate")
            UserDefaults.standard.synchronize()
            
        }else{
            FTIndicator.showToastMessage("\(passedUser.name!) \(DefinedStrings.blockedByme)")
        }
    }
    
    

    
    

    
    
    func removeFromList(){
        
        
        var langParam : String = "en"
        if let lang = UserDefaults.standard.object(forKey: "lang") as? String{
            langParam = lang
        }
        
        let param  = ["add_by":mySelf.uid!,"add_to":passedUser.uid!,"lang":langParam,"status":"0"]
        let urlString = URLConstants.baseUrl + URLConstants.addHotBlocklist
        
        self.chatBtn.setBackgroundImage(#imageLiteral(resourceName: "create_group"), for: .normal)
        
        self.chatBtn.setTitle(NSLocalizedString("Chat", comment: ""), for: .normal)
        self.chatBtn.backgroundColor = UIColor.clear
        
        
        menuOptionArray = [NSLocalizedString("Add to hotlist", comment: ""),NSLocalizedString("View on map", comment: ""),NSLocalizedString("Block", comment: "")]
        ServerData.postResponseFromURL(urlString: urlString, showIndicator: true, params: param ) { (data) in
        }
    }
    
    
    func makeHotList(){
        var langParam : String = "en"
        if let lang = UserDefaults.standard.object(forKey: "lang") as? String{
            langParam = lang
        }
        let param  = ["add_by":mySelf.uid!,"add_to":passedUser.uid!,"lang":langParam,"status":"1"]
        let urlString = URLConstants.baseUrl + URLConstants.addHotBlocklist
        
        menuOptionArray = [NSLocalizedString("Remove from hotlist", comment: ""),NSLocalizedString("View on map", comment: ""),NSLocalizedString("Block", comment: "")]
        
        self.chatBtn.setBackgroundImage(#imageLiteral(resourceName: "create_group"), for: .normal)
        self.chatBtn.setTitle(NSLocalizedString("Chat", comment: ""), for: .normal)
        self.chatBtn.backgroundColor = UIColor.clear
        
        ServerData.postResponseFromURL(urlString: urlString, showIndicator: true, params: param ) { (data) in
            FTIndicator.showToastMessage("\(self.passedUser.name!) \(DefinedStrings.addedHot)")
        }
    }
    
    func blockUser(){
        
        var langParam : String = "en"
        if let lang = UserDefaults.standard.object(forKey: "lang") as? String{
            langParam = lang
        }
        
        let param  = ["add_by":mySelf.uid!,"add_to":passedUser.uid!,"lang":langParam,"status":"2"]
        let urlString = URLConstants.baseUrl + URLConstants.addHotBlocklist
        
        menuOptionArray = [NSLocalizedString("Unblock", comment: "")]
        
        self.chatBtn.setBackgroundImage(UIImage(named : ""), for: .normal)
        self.chatBtn.setTitle(NSLocalizedString("Blocked", comment: ""), for: .normal)
        self.chatBtn.backgroundColor = UIColor.red
        
        ServerData.postResponseFromURL(urlString: urlString, showIndicator: true, params: param ) { (data) in
            FTIndicator.showToastMessage("\(self.passedUser.name!) \(NSLocalizedString("Blocked", comment: ""))")
        }
    }
    
    func showMap(){
        let controller : MapController = self.storyboard?.instantiateViewController(withIdentifier: "MapController") as! MapController
        controller.userArray = [passedUser]
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    @IBAction func profileAction(_ sender: UIButton)
    {
        FTPopOverMenu.showForSender(sender: sender, with: menuOptionArray, done: { (selectedIndex) in
            
            
            let str : String = self.menuOptionArray[selectedIndex]
            
            if str == NSLocalizedString("Add to hotlist", comment: ""){
                self.makeHotList()
            }
            if str == NSLocalizedString("View on map", comment: ""){
                self.showMap()
            }
            if str == NSLocalizedString("Block", comment: ""){
                self.blockUser()
            }
            if str == NSLocalizedString("Unblock", comment: ""){
                self.removeFromList()
            }
            if str == NSLocalizedString("Remove from hotlist", comment: ""){
                self.removeFromList()
            }
            
        }, cancel: {
            
        })
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @objc func handleDatePicker1()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        txtFldAge.text = dateFormatter.string(from: datePickerView.date)
        //Txt_Date.resignFirstResponder()
        //View_Down_Button.isHidden = false
        datePickerView.maximumDate = NSDate() as Date
    }
    //MARK: Uitextfield delegate methods
    
    public func textFieldDidBeginEditing(_ textField: UITextField)
    {
        universalTextField = textField
        if textField == txtFldHeight{
            pickerArray = feetArray
        }
        else if textField == txtFldAge{
            pickerArray = ageArray
        }
        else if textField == txtFldIntrestedIn{
                pickerArray = Gender_array
        }
        else if textField == txtFldDrinking
        {
            pickerArray = drink_array
        }
        else if textField == txtFldSmoking
        {
            pickerArray = smoking_array
        }
        else if textField == txtFldHobby
        {
            pickerArray = Hobby_array
        }
        else if textField == txtFldRelation
        {
            pickerArray = relation_array
        }
        else if textField == txtFldBloodType
        {
            pickerArray = bloodArray
        }
        universalPickerView.reloadAllComponents()
    }

    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    //MARK: UIPickerView  Delegates/DataSource
    public func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return pickerArray.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
       return pickerArray[row]
    }
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        universalTextField.text = pickerArray[row]
        if universalTextField == txtFldAge{
            lblAge.text = universalTextField.text!
        }
    }
    
    
    
    //MARK: Method of label set height
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRect(x:0, y:0, width:width, height:CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    @IBAction func actionBack(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "Chat"{
            let controller = segue.destination as! ChatController
            controller.friend = passedUser
            controller.isGroup = false
        }
        
        
    }
    
    
    @IBAction func actionEdit(_ sender: Any)
    {
        btnChooseImage.isHidden = false
        btnChooseBGImage.isHidden = false

        txtFldId.isUserInteractionEnabled = false
        txtFldIntrestedIn.isUserInteractionEnabled = true
        txtFldAge.isUserInteractionEnabled = true
        txtFldHeight.isUserInteractionEnabled = true
        txtVwIntro.isUserInteractionEnabled = true
        txtFldEthinicity.isUserInteractionEnabled = true
        txtFldBloodType.isUserInteractionEnabled = true
        txtFldSmoking.isUserInteractionEnabled = true
        txtFldDrinking.isUserInteractionEnabled = true
        txtFldHobby.isUserInteractionEnabled = true
        txtFldRelation.isUserInteractionEnabled = true
        txtFldEyeColor.isUserInteractionEnabled = true
        txtFldHairColor.isUserInteractionEnabled = true
        btnChooseImage.isHidden = false
        btnChooseBGImage.isHidden = false
        
        
        if editingMode == false{
            editBtn.setImage(#imageLiteral(resourceName: "checkBox"), for: .normal)
            editingMode = true

        }else{
            
            
            let alertController = JHTAlertController(title: "", message: "Are you sure you want to make changes", preferredStyle: .alert)
            alertController.titleImage = #imageLiteral(resourceName: "alertHead")
            alertController.titleViewBackgroundColor =  UIColor(red:65/255.0, green :4/255.0, blue :85/255.0,alpha :1.0)
            alertController.alertBackgroundColor = UIColor(red:65/255.0, green :4/255.0, blue :85/255.0,alpha :1.0)
            alertController.setAllButtonBackgroundColors(to: UIColor(red:253/255.0, green :200/255.0, blue :118/255.0,alpha :1.0))
            alertController.hasRoundedCorners = true
            
            // Create the action.
            
            let cancelAction = JHTAlertAction(title: "Discard", style: .default) { _ in
                self.editBtn.setImage(#imageLiteral(resourceName: "nav_edit"), for: .normal)
                self.editingMode = false
                self.txtVwIntro.isUserInteractionEnabled = false
                self.txtFldBloodType.isUserInteractionEnabled = false
                self.txtFldEthinicity.isUserInteractionEnabled = false
                self.txtFldEyeColor.isUserInteractionEnabled = false
                self.txtFldHairColor.isUserInteractionEnabled = false
                self.txtFldHeight.isUserInteractionEnabled = false
                self.txtFldHobby.isUserInteractionEnabled = false
                self.txtFldRelation.isUserInteractionEnabled = false
                self.txtFldAge.isUserInteractionEnabled = false
                self.txtFldIntrestedIn.isUserInteractionEnabled = false
                self.txtFldDrinking.isUserInteractionEnabled = false
                self.txtFldSmoking.isUserInteractionEnabled = false
                self.txtFldBloodType.isUserInteractionEnabled = false
            }
            
            
            let okAction = JHTAlertAction(title: "Update", style: .default) { _ in
                self.updateProfile()
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            
            // Show alert
            present(alertController, animated: true, completion: nil)
            
            

            
            
           
        }
        
    }
    
  
    
    
   
    
    
    @IBAction func actionEarnPoints(_ sender: Any) {
        self.performSegue(withIdentifier: "Points", sender: self)
    }
    
    // http://nimbyisttechnologies.com/himanshu/hala/api/apis/updateProfile?
    //id&name&gender=1(male)/2(female)&dob=0000-00-00&image
    //key&bg_image,&online,&point,&social_type,&introduction,&ethinicity,&blood_group,&hair_color,&drinking,&hobby,&smoking,&relationship,&height,&intrested
    
    
    
    
    @IBAction func reportAction(_ sender: Any)
    {
        
        var langParam : String = "en"
        if let lang = UserDefaults.standard.object(forKey: "lang") as? String{
            langParam = lang
        }
        
        let urlString : String = URLConstants.baseUrl + URLConstants.reportUser
        let param = ["from_user":mySelf.uid,"lang":langParam,"to_user":passedUser.uid,"message":""]
        ServerData.postResponseFromURL(urlString: urlString, showIndicator: true, params: param as! [String : String]) { (dataDictionary) in
            print(dataDictionary)
            FTIndicator.showToastMessage(DefinedStrings.reportedUser)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    
    
    @IBAction func actionUpdate(_ sender: Any)
    {
        
        if (txtFldId.text?.trimmingCharacters(in: .whitespaces).isEmpty)!
        {
            FTIndicator.showToastMessage(NSLocalizedString("Name", comment: ""))

        }
        else if (txtFldIntrestedIn.text?.trimmingCharacters(in: .whitespaces).isEmpty)!
        {
            FTIndicator.showToastMessage(NSLocalizedString("IntrestedIn", comment: ""))

        }
        else if (txtFldAge.text?.trimmingCharacters(in: .whitespaces).isEmpty)!
        {
              FTIndicator.showToastMessage(NSLocalizedString("Age", comment: ""))
        }
        else if (txtFldHeight.text?.trimmingCharacters(in: .whitespaces).isEmpty)!
        {
            FTIndicator.showToastMessage(NSLocalizedString("Height", comment: ""))
        }
        else if (txtVwIntro.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
                  FTIndicator.showToastMessage(NSLocalizedString("Introduction", comment: ""))
        }
        else if (txtFldEthinicity.text?.trimmingCharacters(in: .whitespaces).isEmpty)!
        {
                  FTIndicator.showToastMessage(NSLocalizedString("Ethinicity", comment: ""))
        }
        else if (txtFldBloodType.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            
             FTIndicator.showToastMessage(NSLocalizedString("BloodType", comment: ""))
            
        }
        else if (txtFldSmoking.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
                FTIndicator.showToastMessage(NSLocalizedString("Smoking", comment: ""))
        }
        else if (txtFldHobby.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
                  FTIndicator.showToastMessage(NSLocalizedString("Hobby", comment: ""))
        }
        else if (txtFldRelation.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
             FTIndicator.showToastMessage(NSLocalizedString("Relationship", comment: ""))
        }
        else if (txtFldDrinking.text?.trimmingCharacters(in: .whitespaces).isEmpty)!
        {
            FTIndicator.showToastMessage(NSLocalizedString("Drinking", comment: ""))
        }
        else
        {
            
            if imgProfileBG.image == UIImage(named:"fall-autumn-red-season.jpg")
            {
                FTIndicator.showToastMessage("Please Add your Photo.")
            }
            else
            {
                if imgProfile.image == UIImage(named:"profile_user.jpg")
                {
                    FTIndicator.showToastMessage("Please Add your Photo.")
                }
                else
                {
                    updateProfile()
                }
            }
        }
    }
    //MARK: Update Profile
    
    func updateProfile()
    {
        
        FTIndicator.showProgress(withMessage: "Updating")
        var myImage : UIImage = #imageLiteral(resourceName: "user_default")
        var otherImage : UIImage = #imageLiteral(resourceName: "user_default")
        if imgProfile.image != nil{
            myImage = imgProfile.image!
        }
        if imgProfileBG.image != nil{
            otherImage = imgProfileBG.image!
        }
        
        
        let imgData = UIImageJPEGRepresentation(myImage, 0.5)
        let imgData2 = UIImageJPEGRepresentation(otherImage, 0.5)
        
        var drinkValue : String = "0"
        var smokeValue : String = "0"

        
        if txtFldSmoking.text == "Yes"{
            smokeValue = "1"
        }
        if txtFldSmoking.text == "No"{
            smokeValue = "0"

        }
        if txtFldSmoking.text == "Ocassionally"{
            smokeValue = "2"

        }
    
    if txtFldDrinking.text == "Yes"{
        drinkValue = "1"

    }
    if txtFldDrinking.text == "No"{
        drinkValue = "0"

}
if txtFldDrinking.text == "Ocassionally"{
    drinkValue = "2"

}
        
        let ethenic = txtFldEthinicity.text! + "-" + self.txtFldAge.text!
        
        

        var url : String = "http://nimbyisttechnologies.com/himanshu/hala/api/apis/updateProfile"
        url = url.replacingOccurrences(of: " ", with: "%20")
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                
                
                if UserDefaults.standard.value(forKey: "user_profile") != nil
                {
                    let user_data = UserDefaults.standard.value(forKey: "user_profile") as! NSDictionary
                    
                    let user_id = user_data.value(forKey: "id") as! String
                    
                    multipartFormData.append(user_id.data(using: .utf8)!, withName: "id")
                    
                    
                }
                else
                {
                    
                }
                
                
                
                multipartFormData.append(self.lblName.text!.data(using: .utf8)!, withName: "name")
                
                multipartFormData.append("\(self.txtFldIntrestedIn.text!)".data(using: .utf8)!, withName: "gender")
                
                multipartFormData.append("49".data(using: .utf8)!, withName: "dob")
                
                multipartFormData.append("\(1)".data(using: .utf8)!, withName: "online")
                
                multipartFormData.append(self.lblPoints.text!.data(using: .utf8)!, withName: "point")
                
                multipartFormData.append("fb".data(using: .utf8)!, withName: "social_type")
                
                multipartFormData.append(self.txtVwIntro.text!.data(using: .utf8)!, withName: "introduction")
                
                multipartFormData.append(ethenic.data(using: .utf8)!, withName: "ethinicity")
                
                var langParam : String = "en"
                if let lang = UserDefaults.standard.object(forKey: "lang") as? String{
                    langParam = lang
                }
                
                multipartFormData.append(langParam.data(using: .utf8)!, withName: "lang")
                
                multipartFormData.append(self.txtFldBloodType.text!.data(using: .utf8)!, withName: "blood_group")
                
                multipartFormData.append(self.txtFldHairColor.text!.data(using: .utf8)!, withName: "hair_color")
                
                multipartFormData.append(drinkValue.data(using: .utf8)!, withName: "drinking")
                
                multipartFormData.append((self.txtFldHobby.text?.data(using: .utf8)!)!, withName: "hobby")
                
                multipartFormData.append(smokeValue.data(using: .utf8)!, withName: "smoking")
                
                multipartFormData.append(self.txtFldRelation.text!.data(using: .utf8)!, withName: "relationship")
                
                multipartFormData.append(self.txtFldHeight.text!.data(using: .utf8)!, withName: "height")
                
                multipartFormData.append(self.txtFldIntrestedIn.text!.data(using: .utf8)!, withName: "intrested")
                multipartFormData.append(self.txtFldEyeColor.text!.data(using: .utf8)!, withName: "eye_color")
                
                
                
                
                let imageName : String = self.mySelf.uid! + ".jpg"
                
                
                multipartFormData.append(imgData!, withName: "image", fileName: imageName, mimeType: "image/jpeg")
                
                multipartFormData.append(imgData2!, withName: "bg_image", fileName: "bg_image.jpg", mimeType: "image/jpeg")
                
                
        },
            to: url ,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _,_ ):
                    upload.responseJSON { response in
                        debugPrint(response)
                        FTIndicator.dismissProgress()
                        if response.result .isSuccess{
                    
                            self.imgVar = false
                            
                            self.getProfile()
                            
                            
                            
                            let alertController = JHTAlertController(title: "", message: "Profile updated successfully", preferredStyle: .alert)
                            alertController.titleImage = #imageLiteral(resourceName: "alertHead")
                            alertController.titleViewBackgroundColor =  UIColor(red:65/255.0, green :4/255.0, blue :85/255.0,alpha :1.0)
                            alertController.alertBackgroundColor = UIColor(red:65/255.0, green :4/255.0, blue :85/255.0,alpha :1.0)
                            alertController.setAllButtonBackgroundColors(to: UIColor(red:253/255.0, green :200/255.0, blue :118/255.0,alpha :1.0))
                            alertController.hasRoundedCorners = true
                            
                            // Create the action.
                            
                            let cancelAction = JHTAlertAction(title: "OK", style: .default) { _ in
                                
                                self.editBtn.setImage(#imageLiteral(resourceName: "nav_edit"), for: .normal)
                                self.editingMode = false
                                
                                self.txtVwIntro.isUserInteractionEnabled = false
                                self.txtFldBloodType.isUserInteractionEnabled = false
                                self.txtFldEthinicity.isUserInteractionEnabled = false
                                self.txtFldEyeColor.isUserInteractionEnabled = false
                                self.txtFldHairColor.isUserInteractionEnabled = false
                                self.txtFldHeight.isUserInteractionEnabled = false
                                self.txtFldHobby.isUserInteractionEnabled = false
                                self.txtFldRelation.isUserInteractionEnabled = false
                                self.txtFldAge.isUserInteractionEnabled = false
                                self.txtFldIntrestedIn.isUserInteractionEnabled = false
                                self.txtFldDrinking.isUserInteractionEnabled = false
                                self.txtFldSmoking.isUserInteractionEnabled = false
                                self.txtFldBloodType.isUserInteractionEnabled = false
                                self.btnChooseImage.isHidden = true
                                self.btnChooseBGImage.isHidden = true
                                
                                
                            }
                            
                            alertController.addAction(cancelAction)
                            
                            self.present(alertController, animated: true, completion: {
                                
                            })
                           
                            
                            
                        }
                        else{
                          FTIndicator.showToastMessage("Server Error")
                        }
                        }.uploadProgress { progress in // main queue by default
                            print(Float(progress.fractionCompleted) * 100)
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    FTIndicator.showToastMessage("Server Error")
                    self.editBtn.setImage(#imageLiteral(resourceName: "nav_edit"), for: .normal)
                    self.editingMode = false
                    FTIndicator.dismissProgress()
                }
        }
        )
    }
    
    func getProfile(){
        
        if let userId = UserDefaults.standard.object(forKey: "user_id") as? String{
            
            var langParam : String = "en"
            if let lang = UserDefaults.standard.object(forKey: "lang") as? String{
                langParam = lang
            }
            
            let urlString : String = URLConstants.baseUrl + URLConstants.getProfille
            let param = ["user_id":userId,"lang":langParam]
            
            ServerData.postResponseFromURL(urlString: urlString, showIndicator: false, params: param, completion: { (data) in
                print(data)
                let user_dict : NSDictionary = data["data"] as! NSDictionary
                UserDefaults.standard.set(user_dict, forKey: "user_profile")
                UserDefaults.standard.synchronize()
                UserDefaults.standard.set(user_dict, forKey: "User")
                UserDefaults.standard.synchronize()
                
            })
        }
        
       
    }
    
   
      @IBAction func actionChooseBGImage(_ sender: Any) {
        isUserImage = false
        
        
        
        
        let alertController = JHTAlertController(title: "", message: "Profile updated successfully", preferredStyle: .alert)
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
    
    
    @IBAction func actionChooseImage(_ sender: Any) {
        
        isUserImage = true
        let alertController = JHTAlertController(title: "", message:DefinedStrings.selecteImage , preferredStyle: .alert)
        alertController.titleImage = #imageLiteral(resourceName: "alertHead")
        alertController.titleViewBackgroundColor =  UIColor(red:65/255.0, green :4/255.0, blue :85/255.0,alpha :1.0)
        alertController.alertBackgroundColor = UIColor(red:65/255.0, green :4/255.0, blue :85/255.0,alpha :1.0)
        alertController.setAllButtonBackgroundColors(to: UIColor(red:253/255.0, green :200/255.0, blue :118/255.0,alpha :1.0))
        alertController.hasRoundedCorners = true
        
        let galAction = JHTAlertAction(title: NSLocalizedString(DefinedStrings.galleryString, comment: ""), style: .default) { _ in
              self.openGallary()
        }
        let camAction = JHTAlertAction(title: NSLocalizedString(DefinedStrings.cameraString, comment: ""), style: .default) { _ in
            self.openCamera()
        }
        let laterAction = JHTAlertAction(title: NSLocalizedString(DefinedStrings.cancelString, comment: ""), style: .cancel) { _ in
            
        }
        alertController.addAction(galAction)
        alertController.addAction(camAction)
        alertController.addAction(laterAction)

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
            alertController.titleViewBackgroundColor =  UIColor(red:65/255.0, green :4/255.0, blue :85/255.0,alpha :1.0)
            alertController.alertBackgroundColor = UIColor(red:65/255.0, green :4/255.0, blue :85/255.0,alpha :1.0)
            alertController.setAllButtonBackgroundColors(to: UIColor(red:253/255.0, green :200/255.0, blue :118/255.0,alpha :1.0))
            alertController.hasRoundedCorners = true
            let galAction = JHTAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default) { _ in
            }
            alertController.addAction(galAction)
            self.present(alertController, animated: true, completion: {
            })

        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imgProfile.contentMode = .scaleToFill
            imgVar = true
            
            if self.isUserImage == true{
                imgProfile.image = pickedImage

            }else{
                imgProfileBG.image = pickedImage
            }
        }
        dismiss(animated: true, completion: nil)
    }

    
}



/*
 1) Points System from the Google_Ads
 2) Points deduction from the users account
 3) InApp Purchase
 4) Correct the Image of the user at API end
 5) Search Section UI if need to be corrected
 6) Show star user on the HomeScreen.
*/





