//
//  HomeController.swift
//  hala
//
//  Created by MAC on 28/09/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import CarbonKit
import FTPopOverMenu_Swift
import FTIndicator
import JHTAlertController
import CZPicker

class HomeController: UIViewController,CarbonTabSwipeNavigationDelegate , CZPickerViewDelegate, CZPickerViewDataSource {
   
    var hobbiesArray = ["Cricket","Football","Music","Reading","Sports"]
    var distanceArray = ["1 KM","2 KM","3 KM","4 KM","5 KM","6 KM","7 KM","8 KM","9 KM","10 KM"]
    var filterType1 : Bool = true
    var pickerView: CZPickerView?

    
 var searchBtn : UIButton!
    var filterBtn : UIButton!
 var profileBtn : UIButton!
    var mySelf : UserDetail!
    var selectionArray : NSArray = ["Hobbies","Distance"]
     var menuOptionImageNameArray : [String] = ["user_default","flam","share","setting","logout"]
    var menuOptionNameArray : [String] = [NSLocalizedString("View Profile", comment: ""),NSLocalizedString("Hotlist", comment: ""),NSLocalizedString("Share App", comment: ""),NSLocalizedString("Settings", comment: ""),NSLocalizedString("Logout", comment: "")]
    var items = NSArray()
    var carbonTabSwipeNavigation: CarbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        
        let logoBtn : UIButton = UIButton(frame : CGRect(x:0,y:0,width: 80, height :24))
        logoBtn.setBackgroundImage(#imageLiteral(resourceName: "header_logo"), for: .normal)
        logoBtn.isUserInteractionEnabled = false
        let barButton : UIBarButtonItem = UIBarButtonItem(customView : logoBtn)
        self.navigationItem.leftBarButtonItem = barButton
        
        self.rightButton1()
        
        self.changeToWeChatStyle()
     

        
        items = [NSLocalizedString("Find People", comment: ""),NSLocalizedString("Chat", comment: ""),NSLocalizedString("Points", comment: "")]
        carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items as [AnyObject], delegate: self)
        carbonTabSwipeNavigation.insert(intoRootViewController: self)
        self.style()
        

        
        // Define identifier
        let notificationName5 = Notification.Name("RefreshButtons")
        NotificationCenter.default.addObserver(self, selector: #selector(HomeController.refresh), name: notificationName5, object: nil)
        


     
        // Do any additional setup after loading the view.
    }
    
    
    


    
    func numberOfRows(in pickerView: CZPickerView!) -> Int {
        if filterType1 == true{
            return hobbiesArray.count
        }else{
            return distanceArray.count
        }
    }
    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        if filterType1 == true{
            return hobbiesArray[row]
        }else{
            return distanceArray[row]
        }
        
    }
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int) {
        if filterType1 == false{
//            print(distanceArray[row])
            let art : NSArray = (distanceArray[row] as String).components(separatedBy: " ") as NSArray
            self.filterUsers(distanceFilter: true, hobbiesFiler: false, selectedDistance: art[0] as? String, hobbies: nil)
        }
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemsAtRows rows: [Any]!) {
        if filterType1 == true{
            let mutArray : NSMutableArray = NSMutableArray()
            for i in  rows {
                mutArray.add(hobbiesArray[i as! Int])
            }
            let str : String = mutArray.componentsJoined(by: ",")
//            print(str)
            self.filterUsers(distanceFilter: false, hobbiesFiler: true, selectedDistance: nil, hobbies: str)
        }
    }
    


    func filterUsers(distanceFilter : Bool? , hobbiesFiler : Bool?, selectedDistance : String? , hobbies : String?)  {
        let urlString : String = URLConstants.baseUrl + URLConstants.saerchPeople
        
        var param : [String : String] = [:]
        if distanceFilter == true{
            if let lat = UserDefaults.standard.object(forKey: "Lat") as? CGFloat{
                if let lng = UserDefaults.standard.object(forKey: "Lng") as? CGFloat{
                    if let lang = UserDefaults.standard.object(forKey: "lang") as? String{

                    param = ["lat":"\(lat)","lng":"\(lng)","lang":lang,"distance": selectedDistance!]
                    }
                }
            }
        }
        if hobbiesFiler == true{
            if let lang = UserDefaults.standard.object(forKey: "lang") as? String{
            param = ["hobby":hobbies!,"lang":lang]
            }
        }
        ServerData.postResponseFromURL(urlString: urlString, showIndicator: true, params: param) { (dataDictionary) in
//            print(dataDictionary)
            DispatchQueue.main.async {
                if let status = dataDictionary["response"] as? String{
                    var filteredUsers : [UserDetail] = []
                    if status == "1"{
                        if let users = dataDictionary["data"] as? NSArray{
                            for i in 0 ..< users.count {
                                let dict = users[i] as! NSDictionary
                                let user : UserDetail = UserDetail.init(user: dict)
//                                print(user)
                                filteredUsers.append(user)
                            }
                        }
                    }
                        let notificationName = Notification.Name("Filtering")
                        NotificationCenter.default.post(name: notificationName, object: filteredUsers)
                }
            }
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        UserDefaults.standard.set(19.0176147, forKey: "Lat")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.set(72.8561644, forKey: "Lng")
        UserDefaults.standard.synchronize()
        self.updateLocation()

        self.carbonTabSwipeNavigation.setCurrentTabIndex(1, withAnimation: true)
        self.carbonTabSwipeNavigation.setCurrentTabIndex(0, withAnimation: true)

   
        
        super.viewWillAppear(animated)
        if let user = UserDefaults.standard.object(forKey: "User") as? NSDictionary{
            mySelf = UserDetail.init(user: user)
            if  let url = URL(string: mySelf.image){
                URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                    if error != nil {
//                        print(error!)
                        return
                    }
                    DispatchQueue.main.async {
                        
                    }
                }).resume()
            }
            
        }
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func rightButton1(){
        
        self.navigationItem.rightBarButtonItem = nil
        
     searchBtn  = UIButton(frame : CGRect(x:0,y:0,width: 34, height :34))
        searchBtn.setImage(#imageLiteral(resourceName: "search"), for: .normal)
        searchBtn.addTarget(self, action: #selector(HomeController.searchAction(_:)), for: .touchDown)

        let barButton1 : UIBarButtonItem = UIBarButtonItem(customView : searchBtn)
        
         filterBtn  = UIButton(frame : CGRect(x:0,y:0,width: 34, height :34))
        filterBtn.setImage(#imageLiteral(resourceName: "filter"), for: .normal)
        filterBtn.setImage(#imageLiteral(resourceName: "filter_selected"), for: .selected)
         filterBtn.setImage(#imageLiteral(resourceName: "filter_selected"), for: .highlighted)
        filterBtn.addTarget(self, action: #selector(HomeController.filtetAction(_:)), for: .touchDown)

        let barButton2 : UIBarButtonItem = UIBarButtonItem(customView : filterBtn)
        
        
         profileBtn  = UIButton(frame : CGRect(x:0,y:0,width: 34, height :34))
        profileBtn.setImage(#imageLiteral(resourceName: "nav_menu"), for: .normal)
        profileBtn.setImage(#imageLiteral(resourceName: "menu"), for: .selected)
        profileBtn.setImage(#imageLiteral(resourceName: "menu"), for: .highlighted)
        profileBtn.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        profileBtn.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        profileBtn.addTarget(self, action: #selector(HomeController.profileAction(_:)), for: .touchDown)

        
        
        let barButton3 : UIBarButtonItem = UIBarButtonItem(customView : profileBtn)
        
        self.navigationItem.rightBarButtonItems = [barButton3,barButton2,barButton1]
    }
 
    
    func rightButton3(){
        
        self.navigationItem.rightBarButtonItem = nil

        
        profileBtn  = UIButton(frame : CGRect(x:0,y:0,width: 34, height :34))
        profileBtn.setImage(#imageLiteral(resourceName: "nav_menu"), for: .normal)
        profileBtn.setImage(#imageLiteral(resourceName: "menu"), for: .selected)
        profileBtn.setImage(#imageLiteral(resourceName: "menu"), for: .highlighted)
        profileBtn.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        profileBtn.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        profileBtn.addTarget(self, action: #selector(HomeController.profileAction(_:)), for: .touchDown)
        
        let barButton3 : UIBarButtonItem = UIBarButtonItem(customView : profileBtn)
        self.navigationItem.rightBarButtonItems = [barButton3]
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ProfileView"{
            let controller = segue.destination as! ProfileController
            controller.passedUser = mySelf
            controller.itsMe = true
        }
    }
 
    func changeToWeChatStyle() {
        
        let color: UIColor = UIColor(red:65/255.0, green :4/255.0, blue :85/255.0,alpha :1.0)
        
        let config = FTConfiguration.shared
        config.textColor = UIColor.darkGray
        config.backgoundTintColor = UIColor.white
        config.borderColor = color
        config.menuWidth = 150
        config.textAlignment = .left
        config.menuSeparatorColor = color
        config.textFont = UIFont.systemFont(ofSize: 14)
        config.menuRowHeight = 40
        config.cornerRadius = 6
        
    }
    
    
    func updateLocation(){
        if let lat = UserDefaults.standard.object(forKey: "Lat") as? CGFloat{
            if let lng = UserDefaults.standard.object(forKey: "Lng") as? CGFloat{
                if let userId = UserDefaults.standard.object(forKey: "user_id") as? String{
                    if let lang = UserDefaults.standard.object(forKey: "lang") as? String{
                    let param = ["user_id":userId,"lat":"\(lat)","lng":"\(lng)","lang":lang] as [String : String]
                    let urlString : String = URLConstants.baseUrl + URLConstants.updateLocation + param.convertDictionary()
                    ServerData.postResponseFromURL(urlString: urlString, showIndicator: false, params: param, completion: { (data) in
                    })
                    }
                }
            }
        }
    }
    
    @IBAction func searchAction(_ sender: UIButton)
    {
        let notificationName = Notification.Name("Searching")
        NotificationCenter.default.post(name: notificationName, object: nil)
    }
    
    func distanceFilerView(){
        pickerView = CZPickerView(headerTitle: "Pick Distance", cancelButtonTitle: "Cancel", confirmButtonTitle: "Filter")
        pickerView?.delegate = self
        pickerView?.dataSource = self
        pickerView?.headerTitleFont = UIFont(name : "Avenir-Book" , size : 18)
        pickerView?.needFooterView = true
        pickerView?.tapBackgroundToDismiss = true
        pickerView?.allowMultipleSelection = false
        pickerView?.headerBackgroundColor = GlobalConstants.DEFAULT_COLOR_BRINJAL
        pickerView?.confirmButtonBackgroundColor = GlobalConstants.DEFAULT_COLOR_BRINJAL
        pickerView?.checkmarkColor = GlobalConstants.DEFAULT_COLOR_BRINJAL
        pickerView?.show()
    }
    @IBAction func filtetAction(_ sender: UIButton)
    {
        
        let alertController = JHTAlertController(title: "", message: "Filter by", preferredStyle: .alert)
        alertController.titleImage = #imageLiteral(resourceName: "alertHead")
        alertController.titleViewBackgroundColor =  UIColor(red:65/255.0, green :4/255.0, blue :85/255.0,alpha :1.0)
        alertController.alertBackgroundColor = UIColor(red:65/255.0, green :4/255.0, blue :85/255.0,alpha :1.0)
        alertController.setAllButtonBackgroundColors(to: UIColor(red:253/255.0, green :200/255.0, blue :118/255.0,alpha :1.0))
        alertController.hasRoundedCorners = true
        
        let cancelRequest = JHTAlertAction(title: "Cancel", style: .default) { _ in
        }
        let disAction = JHTAlertAction(title: "Distance", style: .default) { _ in
            self.filterType1 = false
            self.distanceFilerView()
        }
        let hobAction = JHTAlertAction(title: "Hobbies", style: .default) { _ in
            self.filterType1 = true
            self.hobbiesFilterView()
        }
        
        alertController.addAction(disAction)
        alertController.addAction(hobAction)
        alertController.addAction(cancelRequest)

        self.present(alertController, animated: true, completion: {
        })
        
        
        

    }
    func hobbiesFilterView(){
        pickerView = CZPickerView(headerTitle: "Pick Hobbies", cancelButtonTitle: "Cancel", confirmButtonTitle: "Filter")
        pickerView?.delegate = self
        pickerView?.dataSource = self
        pickerView?.headerTitleFont = UIFont(name : "Avenir-Book" , size : 18)
        pickerView?.needFooterView = true
        pickerView?.tapBackgroundToDismiss = true
        pickerView?.allowMultipleSelection = true
        pickerView?.headerBackgroundColor = GlobalConstants.DEFAULT_COLOR_BRINJAL
        pickerView?.confirmButtonBackgroundColor = GlobalConstants.DEFAULT_COLOR_BRINJAL
        pickerView?.checkmarkColor = GlobalConstants.DEFAULT_COLOR_BRINJAL
        pickerView?.show()
    }
    
    
    
    
    @IBAction func profileAction(_ sender: UIButton)
    {
        FTPopOverMenu.showForSender(sender: sender, with: menuOptionNameArray, menuImageArray: menuOptionImageNameArray, done: { (selectedIndex) in
            switch selectedIndex {
            case 0:
                self.performSegue(withIdentifier: "ProfileView", sender: self)
                break;
            case 1:
                self.hotListAction()
                break;
            case 2:
                self.shareAction()
                break;
            case 3:
                self.settingsAction()
                break;
            case 4:
                self.logOutAction()
                break;
            default:
                self.hotListAction()
                break;
            }
        }) {
        }
    }
    
    
    func logOutAction(){
        let alertController = JHTAlertController(title: "", message:"Are you sure you want to logout?" , preferredStyle: .alert)
        alertController.titleImage = #imageLiteral(resourceName: "alertHead")
        alertController.titleViewBackgroundColor =  UIColor(red:65/255.0, green :4/255.0, blue :85/255.0,alpha :1.0)
        alertController.alertBackgroundColor = UIColor(red:65/255.0, green :4/255.0, blue :85/255.0,alpha :1.0)
        alertController.setAllButtonBackgroundColors(to: UIColor(red:253/255.0, green :200/255.0, blue :118/255.0,alpha :1.0))
        alertController.hasRoundedCorners = true
        
        let laterAction = JHTAlertAction(title: NSLocalizedString("Later", comment: ""), style: .cancel) { _ in
            
        }
        let logAction = JHTAlertAction(title: NSLocalizedString("Logout", comment: ""), style: .default) { _ in
            UserDefaults.standard.removeObject(forKey: "user_id")
            UserDefaults.standard.synchronize()
            UserDefaults.standard.removeObject(forKey: "User")
            UserDefaults.standard.synchronize()
            self.performSegue(withIdentifier: "Register", sender: self)
            FTIndicator.showToastMessage("Logged Out Successfully")
        }

        alertController.addAction(laterAction)
        alertController.addAction(logAction)
        self.present(alertController, animated: true, completion: {
        })
    }
    func shareAction(){
        let text = "This is some text that I want to share."
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)
    }
    func hotListAction(){
        self.performSegue(withIdentifier: "Hotlist", sender: self)
    }
    func settingsAction(){
        self.performSegue(withIdentifier: "Settings", sender: self)
    }
    
    
    
    func style() {
        
   
        
        let selectedColor: UIColor = UIColor(red:253/255.0, green :200/255.0, blue :118/255.0,alpha :1.0)
        let color: UIColor = UIColor(red:65/255.0, green :4/255.0, blue :85/255.0,alpha :1.0)
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.barTintColor = color
        self.navigationController!.navigationBar.barStyle = .black
        carbonTabSwipeNavigation.toolbar.isTranslucent = false
        carbonTabSwipeNavigation.setIndicatorColor(selectedColor)
        let width : CGFloat =  self.view.frame.size.width / 3.0
        carbonTabSwipeNavigation.toolbar.barTintColor = UIColor.black
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(width, forSegmentAt: 0)
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(width, forSegmentAt: 1)
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(width, forSegmentAt: 2)
        carbonTabSwipeNavigation.setNormalColor(UIColor.white)
        carbonTabSwipeNavigation.setSelectedColor(selectedColor, font: UIFont.boldSystemFont(ofSize: 14))
        
    }
    
    @objc func refresh(){
        self.rightButton3()
    }
    
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAt index: UInt) {
        print("Ashwani")
        if index == 0{
            self.rightButton1()
        }else{
            self.rightButton3()
        }
    }
    

    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        
        switch index {
        case 0:
      
            return self.storyboard!.instantiateViewController(withIdentifier: "PeopleController") as! PeopleController
        case 1:
     
            return self.storyboard!.instantiateViewController(withIdentifier: "ChatTypeController") as! ChatTypeController
        case 2:
 
            return self.storyboard!.instantiateViewController(withIdentifier: "EarningController") as! EarningController
        default:

            return self.storyboard!.instantiateViewController(withIdentifier: "PeopleController") as! PeopleController
        }
        
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, willMoveAt index: UInt) {
        NSLog("Did move at index: %ld", index)
        if index == 0{
            self.rightButton1()
        }else{
            self.rightButton3()
        }
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didFinishTransitionTo index: UInt) {
        print("End Transition")
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, willBeginTransitionFrom index: UInt) {
        print("Begin Transition")
    }

}




