//
//  SettingsController.swift
//  hala
//
//  Created by MAC on 30/09/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import JHTAlertController

class SettingsController: UIViewController {

    var ifPolicy : Bool = true
    var userDictionary : NSMutableDictionary!
    var notificationStatus : Bool = false
    let settingsArray = [NSLocalizedString("Notifications", comment: ""),NSLocalizedString("Privacy Policies", comment: ""),NSLocalizedString("About Us", comment: ""),NSLocalizedString("Change Password", comment: ""),NSLocalizedString("Blocked List", comment: "")]
    @IBOutlet weak var settingsTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        if let user = UserDefaults.standard.object(forKey: "User") as? NSDictionary{
            let notify  = user["notify"] as! String
            if notify == "1"{
                notificationStatus = true
            }else{
                notificationStatus = false
            }
            userDictionary = NSMutableDictionary(dictionary : user)
        }
        
        let backBtn : UIButton = UIButton(frame : CGRect(x:0,y:0,width: 44, height :44))
        backBtn.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        backBtn.addTarget(self, action: #selector(SettingsController.backTap), for: .touchDown)
        let barButton : UIBarButtonItem = UIBarButtonItem(customView : backBtn)
        self.navigationItem.leftBarButtonItem = barButton
        
        self.title = "Settings"

        self.settingsTable.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func backTap(){
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Web"{
             let controller = segue.destination as! WebberController
            controller.ifPolicy = ifPolicy
            controller.urlString = URLConstants.privacyPolicy
            if ifPolicy == false{
                controller.titleString = "About Us"
            }else{
                controller.titleString = "Privacy Policies"
            }
        }
    }
 
    @objc func switchChanged(sender: UISwitch!) {
        print("Switch value is \(sender.isOn)")
        if sender.isOn{
            notificationStatus = true
            self.setNOtificationOnOff(status: "1")
        }else{
            notificationStatus = false
            self.setNOtificationOnOff(status: "0")
        }
    }
    
    func setNOtificationOnOff(status : String){
        
        var langParam : String = "en"
        if let lang = UserDefaults.standard.object(forKey: "lang") as? String{
            langParam = lang
        }
        
     if let userId = UserDefaults.standard.object(forKey: "user_id") as? String{
        let param = ["user_id":userId,"lang":langParam,"notify":status]
        let urlString = URLConstants.baseUrl + URLConstants.notificationStatus
        ServerData.postResponseFromURL(urlString: urlString, showIndicator: false, params: param) { (dataDictionary) in
            self.userDictionary.setValue(status, forKey: "notify")
            let path : IndexPath = IndexPath(row: 1, section : 0)
            self.settingsTable.reloadRows(at: [path], with: .fade)
            self.getProfile()
        }
        }
    }
    
    
    
    func getProfile(){
        var langParam : String = "en"
        if let lang = UserDefaults.standard.object(forKey: "lang") as? String{
            langParam = lang
        }
        if let userId = UserDefaults.standard.object(forKey: "user_id") as? String{
            
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
    

}

extension SettingsController : UITableViewDataSource , UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = settingsArray[indexPath.row]
        
        cell?.selectionStyle = .default
        if indexPath.row == 0{
            cell?.selectionStyle = .none
            //let selectedColor: UIColor = UIColor(red:253/255.0, green :200/255.0, blue :118/255.0,alpha :1.0)
           // let color: UIColor = UIColor(red:65/255.0, green :4/255.0, blue :85/255.0,alpha :1.0)
            let notificationSwitch = UISwitch()
            notificationSwitch.center = view.center
            notificationSwitch.setOn(notificationStatus, animated: false)
            //notificationSwitch.tintColor = color
            //notificationSwitch.onTintColor = selectedColor
            notificationSwitch.addTarget(self, action: #selector(switchChanged(sender:)), for: UIControlEvents.valueChanged)
            cell?.accessoryView = notificationSwitch
        }
        if indexPath.row == 5{
         
            var langParam : String = "English"
            if let lang = UserDefaults.standard.object(forKey: "lang") as? String{
                if lang == "en"{
                    langParam = "English"
                }else{
                    langParam = "Arabic"
                }
            }
            let labelLanguage : UILabel = UILabel()
            labelLanguage.frame = CGRect(x:0,y:0,width : 80,height : 30)
            labelLanguage.text = langParam
            labelLanguage.textAlignment = .right
            labelLanguage.textColor = UIColor.lightGray
            cell?.accessoryView = labelLanguage
        }
            
  
            
        else if indexPath.row == 4 || indexPath.row == 3 || indexPath.row == 2 || indexPath.row == 1{
            let imgView : UIImageView = UIImageView()
            imgView.frame = CGRect(x:0,y:0,width:12,height:12)
            let image : UIImage = #imageLiteral(resourceName: "next_grey")
            imgView.image = image
            cell?.accessoryView = imgView
        }
        
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 1{
            ifPolicy = true
            self.performSegue(withIdentifier: "Web", sender: self)
        }
        else if indexPath.row == 3{
            self.performSegue(withIdentifier: "Change", sender: self)
        }
        else if indexPath.row == 4{
            self.performSegue(withIdentifier: "Block", sender: self)
        }
        else if indexPath.row == 2{
            ifPolicy = false
            self.performSegue(withIdentifier: "Web", sender: self)
        }
        else if indexPath.row == 5{
            self.showLangAlert()
        }
    }
    
    func showLangAlert(){
        let alertController = JHTAlertController(title: "Hala!", message: "Please choose language of your choice.", preferredStyle: .alert)
        alertController.titleViewBackgroundColor = GlobalConstants.DEFAULT_SELECTED_YELLOW
        alertController.titleTextColor = GlobalConstants.DEFAULT_COLOR_BRINJAL
        alertController.alertBackgroundColor = GlobalConstants.DEFAULT_COLOR_BRINJAL
        alertController.setAllButtonBackgroundColors(to: GlobalConstants.DEFAULT_COLOR_BRINJAL)
        alertController.hasRoundedCorners = true
        let cancelAction = JHTAlertAction(title: "Cancel", style: .cancel,  handler: nil)
        
        let defaultAction = JHTAlertAction(title: "English", style: .default, handler: {  _ in
            UserDefaults.standard.set("en", forKey: "lang")
            UserDefaults.standard.synchronize()
            self.switchStoryBoard()
        })
        
        let blueAction = JHTAlertAction(title: "Arabic", style: .default) {  _ in
            UserDefaults.standard.set("ar", forKey: "lang")
            UserDefaults.standard.synchronize()
            self.switchStoryBoard()
        }
        alertController.addActions([defaultAction,blueAction, cancelAction])
        present(alertController, animated: true, completion: nil)
    }
    
    func switchStoryBoard(){
        let app : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        app.goHomeController()
    }
    
    
    
}
