//
//  RequestsController.swift
//  hala
//
//  Created by MAC on 23/10/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import SDWebImage
import FTIndicator
import JHTAlertController

class RequestsController: UIViewController {

    var passDict : UserDetail!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var requestTableView: UITableView!
    var myGroup : Group!
    var groupMembers : NSDictionary!
    var groupMemebers : NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(groupMembers)
        
        self.dateLabel.text = ""
        
        self.title = myGroup.name
        self.requestTableView.tableFooterView = UIView()
        descLabel.text = myGroup.desc
        
        let backBtn : UIButton = UIButton(frame : CGRect(x:0,y:0,width: 44, height :44))
        backBtn.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        backBtn.addTarget(self, action: #selector(RequestsController.backTap), for: .touchDown)
        let barButton : UIBarButtonItem = UIBarButtonItem(customView : backBtn)
        self.navigationItem.leftBarButtonItem = barButton
 
        
        self.rightButton()
        
        self.getMembers()
    }
    
    
    func rightButton(){
        self.navigationItem.rightBarButtonItem = nil
        
        let origImageDelete = #imageLiteral(resourceName: "delete")
        let tintedImage = origImageDelete.withRenderingMode(.alwaysTemplate)
        
        let deleteBtn  = UIButton(frame : CGRect(x:0,y:0,width: 34, height :34))
        deleteBtn.tintColor = UIColor.white
        deleteBtn.setImage(tintedImage, for: .normal)
        deleteBtn.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        deleteBtn.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        deleteBtn.addTarget(self, action: #selector(RequestsController.deleteAction(_:)), for: .touchDown)
        
        let barButton3 : UIBarButtonItem = UIBarButtonItem(customView : deleteBtn)
        self.navigationItem.rightBarButtonItems = [barButton3]
    }
    @IBAction func deleteAction(_ sender: UIButton)
    {
        
        let alertController = JHTAlertController(title:  "", message:"Are you sure you want to delete the group?" , preferredStyle: .alert)
        alertController.titleImage = #imageLiteral(resourceName: "alertHead")
        alertController.titleViewBackgroundColor =  UIColor(red:65/255.0, green :4/255.0, blue :85/255.0,alpha :1.0)
        alertController.alertBackgroundColor = UIColor(red:65/255.0, green :4/255.0, blue :85/255.0,alpha :1.0)
        alertController.setAllButtonBackgroundColors(to: UIColor(red:253/255.0, green :200/255.0, blue :118/255.0,alpha :1.0))
        alertController.hasRoundedCorners = true
        let deleteAction = JHTAlertAction(title: "Delete", style: .cancel) { _ in
            self.deleteGroup()
        }
        let cancelAction = JHTAlertAction(title: DefinedStrings.cancelString, style: .cancel) { _ in
        }
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: {
        })

    }
    
    func deleteGroup(){
        
        var langParam : String = "en"
        if let lang = UserDefaults.standard.object(forKey: "lang") as? String{
            langParam = lang
        }
        
        if let userId = UserDefaults.standard.object(forKey: "user_id") as? String{
        let urlString : String = URLConstants.baseUrl + URLConstants.deleteGroup
            
            let param = ["owner_id":userId,"group_id":myGroup.gid,"lang":langParam]
            ServerData.postResponseFromURL(urlString: urlString, showIndicator: true, params: param as! [String : String], completion: { (dataDictionary) in
                
                print(dataDictionary)
                
                self.navigationController?.popViewController(animated: true)
                FTIndicator.showToastMessage("Group Deleted")
            })
        }
    }
    
    
    
    @objc func backTap(){
        navigationController?.popViewController(animated: true)
    }
    
    func getMembers(){
        let dicto : NSDictionary = groupMembers["Group"] as! NSDictionary
        passDict = UserDetail.init(user: dicto)
        let myMember : NSArray = dicto["myMember"] as! NSArray
        
        if myMember.count > 0{
            for i in 0 ..< myMember.count {
                var mutDict : NSMutableDictionary = NSMutableDictionary()
                let dict : NSDictionary = myMember[i] as! NSDictionary
                var status : String = "0"
                if let member = dict["Member"] as? NSDictionary{
                    status = member["request_status"] as! String
                    mutDict.setValue(status, forKey: "Status")
                    mutDict.setValue(member, forKey: "member")
                    
                }
                if let user = dict["User"] as? NSDictionary{
                    mutDict.setValue(user, forKey: "User")
                    self.groupMemebers.add(mutDict)
                }
            }
        }
        self.requestTableView.reloadData()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "segueChat"{
            let controller = segue.destination as! ChatController
            controller.friend = passDict
            controller.isGroup = true
        }
        
    }
    
    

    @objc func acceptAction(_ button: UIButton){
        
        var langParam : String = "en"
        if let lang = UserDefaults.standard.object(forKey: "lang") as? String{
            langParam = lang
        }
        
        
        let dict : NSDictionary = self.groupMemebers[button.tag] as! NSDictionary
        
        let mutter : NSMutableDictionary = NSMutableDictionary(dictionary : dict)
        let uid : String = (dict["member"] as! NSDictionary).object(forKey: "id") as! String
        let urlString : String = URLConstants.baseUrl + URLConstants.acceptRequest
        let param = ["request_id":uid,"lang" : langParam]
        ServerData.postResponseFromURL(urlString: urlString, showIndicator: true, params: param) { (dataDictionary) in
            print(dataDictionary)
            
            if let status = dataDictionary["response"] as? String{
                if status == "1"{
                    mutter.setValue("1", forKey: "Status")
                    self.groupMemebers.replaceObject(at: button.tag, with: mutter)
                    let path : IndexPath = IndexPath(row : button.tag ,section: 0)
                    self.requestTableView.beginUpdates()
                    self.requestTableView.reloadRows(at: [path], with: .fade)
                    self.requestTableView.endUpdates()
                }
                if let message = dataDictionary["mesg"] as? String{
                    FTIndicator.showToastMessage(message)
                    
                }
            }
        }
        
    }
    @objc func rejectAction(_ button: UIButton){
        
        var langParam : String = "en"
        if let lang = UserDefaults.standard.object(forKey: "lang") as? String{
            langParam = lang
        }
        
        
        let dict : NSDictionary = self.groupMemebers[button.tag] as! NSDictionary
        
        
        let uid : String = (dict["member"] as! NSDictionary).object(forKey: "id") as! String
        
        let urlString : String = URLConstants.baseUrl + URLConstants.rejectRequest
        let param = ["request_id":uid,"lang" : langParam]
        
        ServerData.postResponseFromURL(urlString: urlString, showIndicator: true, params: param) { (dataDictionary) in
            print(dataDictionary)
            if let status = dataDictionary["response"] as? String{
                if status == "1"{
                    self.groupMemebers.removeObject(at: button.tag)
                    self.requestTableView.reloadData()
                }
                if let message = dataDictionary["mesg"] as? String{
                    FTIndicator.showToastMessage(message)
                    
                }
                
            }
            
            
        }
        
    }


}


extension RequestsController : UITableViewDataSource , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groupMemebers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : RequestCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! RequestCell
        

        cell.acceptBtn.addTarget(self, action: #selector(RequestsController.acceptAction(_:)), for: .touchUpInside)
        cell.rejectBtn.addTarget(self, action: #selector(RequestsController.rejectAction(_:)), for: .touchUpInside)

        
        cell.acceptBtn.tag = indexPath.row
        cell.rejectBtn.tag = indexPath.row
        
        let dict : NSDictionary = self.groupMemebers[indexPath.row] as! NSDictionary
        
        let user : NSDictionary = dict["User"] as! NSDictionary
        let status : String = dict["Status"] as! String
        
        if status == "1"{
            cell.acceptBtn.isHidden = true
            cell.rejectBtn.isHidden = true
        }
        else{
            cell.acceptBtn.isHidden = false
            cell.rejectBtn.isHidden = false
        }
        
        let username : String = user["name"] as! String
        cell.nameLabel.text = username
        
        var urlImage : String = user["image"] as! String
        
        urlImage = URLConstants.imageBase + urlImage
        
        
        if let url = URL(string : urlImage){
            cell.profileImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "user_default"))
        }
        
        return cell
    }
    
 
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}
