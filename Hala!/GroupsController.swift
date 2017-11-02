//
//  GroupsController.swift
//  hala
//
//  Created by MAC on 10/10/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import FTIndicator
import JHTAlertController

class GroupsController: UIViewController {
    
    @IBOutlet weak var groupSegment: UISegmentedControl!
    @IBOutlet weak var groupTableView: UITableView!
    
    var myGroupsAllArray : NSMutableArray = NSMutableArray()
    var myGroupsArray : [Group] = []
    var otherGroupsArray : [OtherGroup] = []
    var passDict : UserDetail!
    var ifMine : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("Groups", comment: "")
        
        
        self.groupTableView.tableFooterView = UIView()
        
        
        let color: UIColor = UIColor(red:65/255.0, green :4/255.0, blue :85/255.0,alpha :1.0)
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.barTintColor = color
        self.navigationController!.navigationBar.barStyle = .black
        
        
        
        let backBtn : UIButton = UIButton(frame : CGRect(x:0,y:0,width: 44, height :44))
        backBtn.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        backBtn.addTarget(self, action: #selector(GroupsController.backTap), for: .touchDown)
        let barButton : UIBarButtonItem = UIBarButtonItem(customView : backBtn)
        self.navigationItem.leftBarButtonItem = barButton
        
        
        
        
        
        self.groupTableView.estimatedRowHeight = 200
        
        
        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        groupSegment.selectedSegmentIndex = 0
        if otherGroupsArray.count > 0{
            otherGroupsArray.removeAll()
        }
        if myGroupsArray.count > 0{
            myGroupsArray.removeAll()
        }
        self.groupTableView.reloadData()
        
        self.getGroups()
    }
    
    
    @objc func backTap(){
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getGroups(){
        
        if self.myGroupsArray.count > 0{
            self.myGroupsArray.removeAll()
        }
        if self.myGroupsAllArray.count > 0{
            self.myGroupsAllArray.removeAllObjects()
        }
        
        if let userId = UserDefaults.standard.object(forKey: "user_id") as? String{

            if let lang = UserDefaults.standard.object(forKey: "lang") as? String{

        let urlString = URLConstants.baseUrl + URLConstants.myGroups
        let param = ["user_id":userId,"lang":lang]
        
            ServerData.postResponseFromURL(urlString: urlString, showIndicator: true, params: param, completion: { (dataDictionary) in
                if let art = dataDictionary["data"] as? NSArray{
                    for i in 0 ..< art.count {
                        let dict : NSDictionary = art[i] as! NSDictionary
                        let dict2 : NSDictionary = dict["Group"] as! NSDictionary
                        let myGroup : Group = Group.init(subscritions: dict2)
                        self.myGroupsArray.append(myGroup)
                        self.myGroupsAllArray.add(dict)
                    }
                    DispatchQueue.main.async {
                        self.getAllOtherGroups(uid: userId, lang: lang)
                        self.groupTableView.reloadData()
                    }
                }else{
                    DispatchQueue.main.async {
                             self.ifMine = false
                        self.getAllOtherGroups(uid: userId, lang: lang)
                        self.groupTableView.reloadData()
                        self.groupSegment.selectedSegmentIndex = 1
                    }
                }
            })
        }
        }
    }
    
    
    func getAllOtherGroups(uid : String , lang : String){
        
        if self.otherGroupsArray.count > 0{
            self.otherGroupsArray.removeAll()
        }
        
        let urlString = URLConstants.baseUrl + URLConstants.allGroups
        let param = ["user_id":uid,"lang":lang]
        
        
        ServerData.postResponseFromURL(urlString: urlString, showIndicator: false, params: param, completion: { (dataDictionary) in
            print(dataDictionary)
            if let art = dataDictionary["data"] as? NSArray{
                for i in 0 ..< art.count {
                    let dict : NSDictionary = art[i] as! NSDictionary
                    let myGroup : OtherGroup = OtherGroup.init(subscritions: dict)
                    self.otherGroupsArray.append(myGroup)
                }
            }
            self.groupTableView.reloadData()
        })
        
        
    }
    
    
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            ifMine = true
        }else{
            ifMine = false
        }
        groupTableView.reloadData()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
    
    @objc func createGroup(){
        self.performSegue(withIdentifier: "Create", sender: self)
    }
    
    
    func leaveAction(other : OtherGroup){
        if let userId = UserDefaults.standard.object(forKey: "user_id") as? String{
            if let lang = UserDefaults.standard.object(forKey: "lang") as? String{
        let urlString : String = URLConstants.baseUrl + URLConstants.leaveGroup
            let param = ["user_id":userId,"lang" : lang,"group_id":other.gid]
            ServerData.postResponseFromURL(urlString: urlString, showIndicator: true, params: param as! [String : String] ) { (dataDictionary) in
            print(dataDictionary)
            if (dataDictionary["response"] as? String) != nil{
                if let message = dataDictionary["mesg"] as? String{
                    FTIndicator.showToastMessage(message)
                }
            }
            self.getGroups()
        }
        }
    }
    }
    
    
    
    @objc func groupAction(_ button: UIButton) {
         if let userId = UserDefaults.standard.object(forKey: "user_id") as? String{
        let other : OtherGroup = otherGroupsArray[button.tag]
                //http://nimbyisttechnologies.com/himanshu/hala/api/apis/rejectreq?request_id=4&lang=en
        if other.approvalStatus == "1"{
            print("Pending")
            
            
//            FTIndicator.showToastMessage("Your request is awaited for approval")
            
            
            let alertController = JHTAlertController(title: "", message: "Do you want to cancel request?", preferredStyle: .alert)
            alertController.titleImage = #imageLiteral(resourceName: "alertHead")
            alertController.titleViewBackgroundColor =  UIColor(red:65/255.0, green :4/255.0, blue :85/255.0,alpha :1.0)
            alertController.alertBackgroundColor = UIColor(red:65/255.0, green :4/255.0, blue :85/255.0,alpha :1.0)
            alertController.setAllButtonBackgroundColors(to: UIColor(red:253/255.0, green :200/255.0, blue :118/255.0,alpha :1.0))
            alertController.hasRoundedCorners = true
            
            // Create the action.
            
            let cancelRequest = JHTAlertAction(title: "Cancel Request", style: .default) { _ in
                
                self.leaveAction(other: other)

            }
            let okAction = JHTAlertAction(title: "Ok", style: .default) { _ in
                
                
            }
     
            alertController.addAction(cancelRequest)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: {
                
            })
   
            
            return
        }
        if other.approvalStatus == "2"{
            print("Leave")
            self.leaveAction(other: other)
            return
        }
        if other.approvalStatus == "0"{
            print("Send")
            if let lang = UserDefaults.standard.object(forKey: "lang") as? String{

            let param = ["member_id":userId,"group_id":other.gid!,"lang":lang]
            let urlString : String = URLConstants.baseUrl + URLConstants.joinGroup
            ServerData.postResponseFromURL(urlString: urlString, showIndicator: true, params: param, completion: { (dataDictionary) in
                if let response = dataDictionary["response"] as? String{
                    if response == "0"{
                        if let mesg : String = dataDictionary["mesg"] as? String{
                            FTIndicator.showToastMessage(mesg)
                        }
                        
                    }else{
                        FTIndicator.showToastMessage("Request Sent")
                    }
                }
                self.getGroups()
            })
            }
        }
        
        }

        //http://nimbyisttechnologies.com/himanshu/hala/api/apis/sendRequest?member_id=37&group_id=9&lang=en
        
    }
    
    
}

extension GroupsController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ifMine == true{
            return myGroupsArray.count
        }
        return otherGroupsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let groupImageView = cell.contentView.viewWithTag(10) as! UIImageView
        let groupName = cell.contentView.viewWithTag(20) as! UILabel
        let groupDesc = cell.contentView.viewWithTag(30) as! UILabel
        let groupApproved = cell.contentView.viewWithTag(40) as! UIImageView

        groupImageView.contentMode = .scaleToFill
        groupImageView.layer.cornerRadius = groupImageView.frame.size.width / 2
        groupImageView.clipsToBounds = true
        
        
        if ifMine == true{
            
            let singlegroup : Group = self.myGroupsArray[indexPath.row]

            let imageUrl : String = URLConstants.imageBase + singlegroup.image!
            
            if let url = URL(string : imageUrl){
                groupImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "user_default"))
            }
            
            
            groupDesc.text = singlegroup.desc!
            groupDesc.numberOfLines = 0
        
            cell.accessoryView = nil
            
           groupName.text = singlegroup.name
            
            if singlegroup.approvalStatus == "0"{
                groupApproved.image = #imageLiteral(resourceName: "approved2")
            }else{
                groupApproved.image = #imageLiteral(resourceName: "approved")
            }
            
            groupApproved.isHidden = false
            
            
        }else{
            let other : OtherGroup = otherGroupsArray[indexPath.row]
            let imageUrl : String = URLConstants.imageBase + other.image!

            if let url = URL(string : imageUrl){
                groupImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "user_default"))
            }
            groupName.text = other.name
            groupDesc.text = other.desc
            
            let approveDisapproveBtn = UIButton()
            approveDisapproveBtn.frame = CGRect(x: 0 , y : 0 , width : 55 , height : 30)
            approveDisapproveBtn.layer.cornerRadius = 4
            approveDisapproveBtn.layer.borderWidth = 1
            approveDisapproveBtn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
            
            approveDisapproveBtn.addTarget(self, action: #selector(GroupsController.groupAction(_:)), for: .touchUpInside)
  
                if other.approvalStatus == "1"{
                    approveDisapproveBtn.setTitle("Pending", for: .normal)
                    approveDisapproveBtn.setTitleColor(GlobalConstants.DEFAULT_COLOR_BRINJAL, for: .normal)
                    approveDisapproveBtn.layer.borderColor = GlobalConstants.DEFAULT_COLOR_BRINJAL.cgColor
                    approveDisapproveBtn.layer.borderWidth = 1.0
                    approveDisapproveBtn.layer.borderColor = GlobalConstants.DEFAULT_COLOR_BRINJAL.cgColor
                }
                if other.approvalStatus == "2"{
                    approveDisapproveBtn.setTitle("Leave", for: .normal)
                    approveDisapproveBtn.setTitleColor(UIColor.red, for: .normal)
                    approveDisapproveBtn.layer.borderColor = UIColor.red.cgColor
                    approveDisapproveBtn.layer.borderWidth = 1.0
                    approveDisapproveBtn.layer.borderColor = UIColor.red.cgColor
                }
                if other.approvalStatus == "0"{
                    approveDisapproveBtn.setTitle("Join", for: .normal)
                    approveDisapproveBtn.setTitleColor(UIColor.green, for: .normal)
                    approveDisapproveBtn.layer.borderColor = UIColor.green.cgColor
                    approveDisapproveBtn.layer.borderWidth = 1.0
                    approveDisapproveBtn.layer.borderColor = UIColor.green.cgColor
                }
            approveDisapproveBtn.clipsToBounds = true
            approveDisapproveBtn.tag = indexPath.row
            approveDisapproveBtn.clipsToBounds = true
            
            cell.accessoryView = approveDisapproveBtn
            groupApproved.isHidden = true
        }
        
  
        
        
        
        return cell
    }
    
    
    func deleteGroup(myGroup : Group){
        if let userId = UserDefaults.standard.object(forKey: "user_id") as? String{
            if let lang = UserDefaults.standard.object(forKey: "lang") as? String{

            let urlString : String = URLConstants.baseUrl + URLConstants.deleteGroup
            let param = ["owner_id":userId,"group_id":myGroup.gid,"lang":lang]
            ServerData.postResponseFromURL(urlString: urlString, showIndicator: true, params: param as! [String : String], completion: { (dataDictionary) in
                print(dataDictionary)
                self.getGroups()
                FTIndicator.showToastMessage("Group Deleted")
            })
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if ifMine == true{
            let singlegroup : Group = self.myGroupsArray[indexPath.row]
            if singlegroup.approvalStatus == "0"{
                
                let alertController = JHTAlertController(title: "", message: "Group not approved yet", preferredStyle: .alert)
                alertController.titleImage = #imageLiteral(resourceName: "alertHead")
                alertController.titleViewBackgroundColor =  UIColor(red:65/255.0, green :4/255.0, blue :85/255.0,alpha :1.0)
                alertController.alertBackgroundColor = UIColor(red:65/255.0, green :4/255.0, blue :85/255.0,alpha :1.0)
                alertController.setAllButtonBackgroundColors(to: UIColor(red:253/255.0, green :200/255.0, blue :118/255.0,alpha :1.0))
                alertController.hasRoundedCorners = true
                
                let cancelRequest = JHTAlertAction(title: "Delete Group", style: .default) { _ in
                    self.deleteGroup(myGroup: singlegroup)
                }
                let okAction = JHTAlertAction(title: "Later", style: .default) { _ in
                }
                
                alertController.addAction(cancelRequest)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: {
                })
            }else{
                let controller : RequestsController = self.storyboard?.instantiateViewController(withIdentifier: "RequestsController") as! RequestsController
                controller.myGroup = singlegroup
                controller.groupMembers = self.myGroupsAllArray[indexPath.row] as! NSDictionary
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }else{
                let controller : ChatController = self.storyboard?.instantiateViewController(withIdentifier: "ChatController") as! ChatController
                let other : OtherGroup = otherGroupsArray[indexPath.row]
                let dict:NSDictionary =
                    ["id":other.gid ?? "","image":other.image ?? "","name":other.name ?? ""
                ]
                controller.isGroup = true
                passDict = UserDetail(user: dict)
                controller.friend = passDict
                self.navigationController?.pushViewController(controller, animated: true)
                
        }
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }


    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 74
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header : UIView = UIView()
        header.frame = CGRect(x:0,y:0,width:tableView.frame.size.width - 10  , height : 54)
        let button : UIButton = UIButton()
        button.frame = CGRect(x:5,y:5,width :tableView.frame.size.width - 10 , height : 44)
        header.backgroundColor = UIColor.white
        button.setBackgroundImage(#imageLiteral(resourceName: "create_group"), for: .normal)
        button.setTitle(NSLocalizedString(DefinedStrings.createGroup, comment: ""), for: .normal)
        button.addTarget(self, action: #selector(GroupsController.createGroup), for: .touchDown)
        header.addSubview(button)
        
        return header
    }

}


