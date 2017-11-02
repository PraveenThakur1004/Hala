//
//  PeopleController.swift
//  hala
//
//  Created by MAC on 28/09/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import SDWebImage
import IQKeyboardManagerSwift


class PeopleController: UIViewController , UITableViewDelegate , UITableViewDataSource ,UISearchBarDelegate {
    
    var tapGestureTable : UITapGestureRecognizer!
    
    var section1Height : CGFloat = 0
    var searchBar : UISearchBar  = UISearchBar()
    
    var userArray : [UserDetail] = []
    var searchArray : [UserDetail] = []
    @IBOutlet weak var tblView: UITableView!
    var selectedIndex : Int = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tblView.tableFooterView = UIView()
        
        // Define identifier
        let notificationName = Notification.Name("Searching")
        NotificationCenter.default.addObserver(self, selector: #selector(PeopleController.searching), name: notificationName, object: nil)
        
        
        let notificationName2 = Notification.Name("Filtering")
        NotificationCenter.default.addObserver(self, selector: #selector(PeopleController.filtering(notify:)), name: notificationName2, object: nil)
        
        
        

        
        
//        NotificationCenter.default.addObserver(self, selector: #selector(PeopleController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(PeopleController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        

        
        // Do any additional setup after loading the view.
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        tapGestureTable = UITapGestureRecognizer(target: self, action: #selector(self.tapBlurButton(_:)))
        self.tblView.addGestureRecognizer(tapGestureTable)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
      self.tblView.removeGestureRecognizer(tapGestureTable)
    }
    
    
    @objc func tapBlurButton(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    @objc func filtering(notify : NSNotification){
        searchBar.resignFirstResponder()
        section1Height = 0
        if userArray.count > 0{
            userArray.removeAll()
        }
        self.tblView.reloadData()

        self.userArray = (notify.object as! [UserDetail])
        self.tblView.reloadData()
    }
    
    
    @objc func searching(){
        
       
        
        if section1Height == 0{
            searchBar.becomeFirstResponder()
            section1Height = 50
        }else {
            searchBar.resignFirstResponder()
            section1Height = 0
        }
        if searchArray.count > 0{
            searchArray.removeAll()
        }
           self.tblView.reloadData()
        //tblView.reloadSections(IndexSet(integer: 0), with: .top)
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ProfileView"{
            let controller = segue.destination as! ProfileController
            if section1Height == 50{
                controller.passedUser = searchArray[selectedIndex]

            }else{
                controller.passedUser = userArray[selectedIndex]
            }
            controller.itsMe = false
        }
        
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        userArray.removeAll()
        self.tblView.reloadData()
        getPeopleNearMe()
        super.viewWillAppear(animated)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        section1Height = 0
        if userArray.count > 0{
            userArray.removeAll()
        }
        self.tblView.reloadData()

        getPeopleNearMe()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
     
        
        if let textter = searchBar.text as NSString? {
            let txtAfterUpdate = textter.replacingCharacters(in: range, with: text)
            if txtAfterUpdate.characters.count>0{
                self.searchUsers(text: txtAfterUpdate, loader: false)
            }
            if txtAfterUpdate.characters.count == 0{
                if searchArray.count > 0{
                    searchArray.removeAll()
                    self.tblView.reloadData()
                }
            }
        }
        
        
        return true
    }
    
    
    func searchUsers(text : String , loader : Bool){
      
        
        var langParam : String = "en"
        if let lang = UserDefaults.standard.object(forKey: "lang") as? String{
            langParam = lang
        }
        
        let urlString : String = URLConstants.baseUrl + URLConstants.saerchPeople
        let param = ["search":text,"lang":langParam]
        ServerData.postResponseFromURL(urlString: urlString, showIndicator: loader, params: param) { (dataDictionary) in
            
            print(dataDictionary)
            DispatchQueue.main.async {
                self.searchArray.removeAll()
                if let status = dataDictionary["response"] as? String{
                    if status == "1"{
                        if let users = dataDictionary["data"] as? NSArray{
                            for i in 0 ..< users.count {
                                let dict = users[i] as! NSDictionary
                                let user : UserDetail = UserDetail.init(user: dict)
                                self.searchArray.append(user)
                            }
                        }
                    }else{
                        if self.searchArray.count > 0{
                            self.searchArray.removeAll()
                        }
                    }
                }
                self.tblView.reloadData()
            }
        }
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

        self.searchUsers(text: searchBar.text!, loader: true)
    }
    
    
    func getPeopleNearMe(){
        
        
        var langParam : String = "en"
        if let lang = UserDefaults.standard.object(forKey: "lang") as? String{
            langParam = lang
        }
        
        if let lat = UserDefaults.standard.object(forKey: "Lat") as? CGFloat{
            if let lng = UserDefaults.standard.object(forKey: "Lng") as? CGFloat{
                if let userId = UserDefaults.standard.object(forKey: "user_id") as? String{
                    let param = ["user_id":userId,"lat":"\(lat)","lng":"\(lng)","lang":langParam] as [String : String]
                    let urlString : String = URLConstants.baseUrl + URLConstants.nearBy
                    ServerData.postResponseFromURL(urlString: urlString, showIndicator: true, params: param, completion: { (dataDictionary) in
                            if let status = dataDictionary["response"] as? String{
                                if status == "1"{
                                    if let users = dataDictionary["data"] as? NSArray{
                                        for i in 0 ..< users.count {
                                            let dict = users[i] as! NSDictionary
                                            let user : UserDetail = UserDetail.init(user: dict)
                                            self.userArray.append(user)
                                        }
                                    }
                                    self.tblView.reloadData()
                                }
                        }
                    })
                }
            }
        }
        
        
    }
    
    // MARK:- TableView Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 0
        }else{
            if section1Height == 50{
                return searchArray.count
            }else{
                return userArray.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleCell", for: indexPath as IndexPath) as! PeopleCell
        if indexPath.section == 1{
            
            let user : UserDetail!
            if section1Height == 50{
                user  = searchArray[indexPath.row]
            }else{
                user  = userArray[indexPath.row]
            }
            
            if user.online == true{
                cell.onlineImageView.isHidden = false
            }else{
                cell.onlineImageView.isHidden = true
            }
            cell.nameLabel.text = user.name
            
            if user.gender == true{
                cell.genderImageView.image = #imageLiteral(resourceName: "female")
            }else{
                cell.genderImageView.image = #imageLiteral(resourceName: "male")

            }
            if user.distance! == "0"{
                cell.distanceLabel.text = ""
            }else{
                cell.distanceLabel.text = "\(user.distance!)"
            }
            
            if user.star_User == "1"{
                print("Favourite")
                cell.favLabel.isHidden = false
            }else{
                print("Unfavourite")
                cell.favLabel.isHidden = true
            }
            
            
            if let url = URL(string : URLConstants.imageBase + user.image){
                cell.userImageView.sd_setImage(with: url, placeholderImage: UIImage(named : "user_default"))
            }else{
                cell.userImageView.image = #imageLiteral(resourceName: "user_default")
            }
            
            cell.favLabel.alpha = 0

            let origImageFB = #imageLiteral(resourceName: "home_fb")
            let tintedImage = origImageFB.withRenderingMode(.alwaysTemplate)
            
            let origImageTW = #imageLiteral(resourceName: "home_tw")
            let tintedImageTW = origImageTW.withRenderingMode(.alwaysTemplate)
            
            
            cell.fbImageView.image = tintedImage
            cell.fbImageView.tintColor = UIColor.lightGray
            
            cell.twImageView.image = tintedImageTW
            cell.twImageView.tintColor = UIColor.lightGray
            
            
            if user.social_type == "fb"{
                cell.fbImageView.image = tintedImage
                cell.fbImageView.tintColor = GlobalConstants.FB_COLOR
            }
            
            if user.social_type == "twitter"{
                cell.twImageView.image = tintedImageTW
                cell.twImageView.tintColor = GlobalConstants.TW_COLOR
            }
           

            
            
            let origImageHot = #imageLiteral(resourceName: "ic_hotlist")
            let tintedImageHot = origImageHot.withRenderingMode(.alwaysTemplate)
            
            if let fav = user.favourate{
                if fav == "0"{
                    cell.hotImage.image = tintedImageHot
                    cell.hotImage.tintColor = UIColor.lightGray

                    cell.blockImageView.alpha = 0
                }else if fav == "1"{
                    cell.hotImage.image = #imageLiteral(resourceName: "hotter")
//                    cell.hotImage.tintColor = GlobalConstants.DEFAULT_SELECTED_YELLOW
                    cell.blockImageView.alpha = 0
                }else if fav == "2"{
                    cell.hotImage.image = tintedImageHot

                    cell.hotImage.tintColor = UIColor.lightGray

                    cell.blockImageView.alpha = 1
                }
            }else{
                cell.hotImage.image = tintedImageHot
                cell.hotImage.tintColor = UIColor.lightGray
            }
            
            
            let components : NSArray  = user.ethinicity.components(separatedBy: "-") as NSArray
            if components.count > 1{
                cell.ageLabel.text = "\(components.lastObject as! String) Years"
            }else{
                cell.ageLabel.text = ""
            }
            
            
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.view.endEditing(true)
        
        if section1Height == 50{
            if searchArray.count > 0{
                if indexPath.section == 1{
                    selectedIndex = indexPath.row
                    self.performSegue(withIdentifier: "ProfileView", sender: self)
                }
            }
        }else{
            if userArray.count > 0{
                if indexPath.section == 1{
                    selectedIndex = indexPath.row
                    self.performSegue(withIdentifier: "ProfileView", sender: self)
                }
            }
        }
        
      
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return section1Height
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            let header : UIView = UIView(frame : CGRect(x:0,y:0,width:tableView.frame.size.width,height:50))
            searchBar.frame = CGRect(x:0,y:3,width:header.frame.size.width,height:44)
            searchBar.delegate = self
            searchBar.showsCancelButton = true
            header.addSubview(searchBar)
//            searchBar.tintColor = GlobalConstants.DEFAULT_COLOR_BRINJAL
//            searchBar.barTintColor = GlobalConstants.DEFAULT_SELECTED_YELLOW
            self.addDoneButtonOnKeyboard()
            
            return header
        }
        return nil
    }
    
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x:0, y:0,width:320,height:50))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(PeopleController.doneButtonAction))
        
        let items : [UIBarButtonItem] = [flexSpace,done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.searchBar.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        self.searchBar.resignFirstResponder()
    }

    
    @IBAction func actionGoToMap(_ sender: Any) {
        let controller : MapController = self.storyboard?.instantiateViewController(withIdentifier: "MapController") as! MapController
        if section1Height == 50{
            controller.userArray = searchArray
        }else{
            controller.userArray = userArray
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.resignFirstResponder()
    }
    
}
