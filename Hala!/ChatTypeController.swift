//
//  ChatTypeController.swift
//  hala
//
//  Created by MAC on 02/10/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import SDWebImage
import FTIndicator

class ChatTypeController: UIViewController {

    var refreshControl: UIRefreshControl!

    var passDict : UserDetail!
    var chatArray : [UserDetail] = []
    var groupArray : [GroupInbox] = []
    var selectedUser : UserDetail!

    @IBOutlet weak var chatSegment : UISegmentedControl!
    @IBOutlet weak var inboxTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        inboxSearch.attributedPlaceholder = NSAttributedString(string: "Search",
//                                                                  attributes: [NSAttributedStringKey.foregroundColor: GlobalConstants.DEFAULT_COLOR_BRINJAL.withAlphaComponent(0.4)])
        
        self.getChats(checkLoader: true)
        
        
        inboxTableView.tableFooterView = UIView()

        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(ChatTypeController.refresh), for: UIControlEvents.valueChanged)
        inboxTableView.addSubview(refreshControl)
        // Do any additional setup after loading the view.
    }
    
    @objc func refresh() {
        self.refreshControl.beginRefreshing()
        self.getChats(checkLoader: false)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.chatSegment.selectedSegmentIndex = 0
        if UserDefaults.standard.object(forKey: "ChatUpdate") != nil{
            self.getChats(checkLoader: true)
            UserDefaults.standard.removeObject(forKey: "ChatUpdate")
            UserDefaults.standard.synchronize()
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentSwitchAction(_ sender: Any) {
        if chatSegment.selectedSegmentIndex == 0{
            inboxTableView.reloadData()
        }else{
        self.performSegue(withIdentifier: "Group", sender: self)
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "Chat"{
            let controller = segue.destination as! ChatController
            controller.friend = selectedUser
        }
        
    }
 
    

    
    
    
    func getChats(checkLoader : Bool){
        if let lang = UserDefaults.standard.object(forKey: "lang") as? String{

          if let userId = UserDefaults.standard.object(forKey: "user_id") as? String{
            let urlString = URLConstants.baseUrl + URLConstants.getChats
            let param = ["id":userId,"lang":lang]
            ServerData.postResponseFromURL(urlString: urlString, showIndicator: checkLoader, params: param, completion: { (dataDictionary) in
                print(dataDictionary)
                self.chatArray.removeAll()
                if let status = dataDictionary["response"] as? String{
                    if status == "1"{
                        if let users = dataDictionary["data"] as? NSArray{
                            for i in 0 ..< users.count {
                                let dict = users[i] as! NSDictionary
                                let user : UserDetail = UserDetail.init(user: dict)
                                self.chatArray.append(user)
                            }
                        }
                        self.inboxTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                        self.getGroups(checkLoader: false, param: param)
                        
                    }else{
                        self.getGroups(checkLoader: false, param: param)

                        FTIndicator.showToastMessage("No recent chats")
                    }
                }
            })
            
        }
    }
    }
    
    
    func getGroups(checkLoader : Bool , param : [String : String]){
        
        let urlString : String = URLConstants.baseUrl + URLConstants.groupInbox
        
        ServerData.postResponseFromURL(urlString: urlString, showIndicator: checkLoader, params: param, completion: { (dataDictionary) in
            print(dataDictionary)
            self.groupArray.removeAll()
            if let status = dataDictionary["response"] as? String{
                if status == "1"{
                    if let users = dataDictionary["data"] as? NSArray{
                        for i in 0 ..< users.count {
                            let dict = users[i] as! NSDictionary
                            let user : GroupInbox = GroupInbox.init(group: dict)
                            self.groupArray.append(user)
                        }
                    }
                }
                 self.inboxTableView.reloadSections(IndexSet(integer: 1), with: .automatic)
            }
        })
        
        
        
    }
    
    

}


extension ChatTypeController : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1{
            return groupArray.count
        }else{
            return chatArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTblVwCell", for: indexPath) as! HomeTblVwCell
        if indexPath.section == 0{
            let user : UserDetail = chatArray[indexPath.row]
            
            if user.online == true{
                cell.onlineImageView.isHidden = false
            }else{
                cell.onlineImageView.isHidden = true
            }
            
            cell.lblName.text = user.name
            if let url = URL(string : user.image){
                cell.imgUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder"))
            }
            cell.lblLastMsg.text = user.message!
            
            if user.online == true{
            }else{
            }
        }else{
            let group : GroupInbox = groupArray[indexPath.row]
            cell.lblName.text = group.name
            
            cell.onlineImageView.isHidden = true

            
            
            if let url = URL(string : group.image!){
                cell.imgUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder"))
            }
            cell.lblLastMsg.text = group.message!
        }
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 81
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0{
            selectedUser = chatArray[indexPath.row]
            self.performSegue(withIdentifier: "Chat", sender: self)

        }else{
            let controller : ChatController = self.storyboard?.instantiateViewController(withIdentifier: "ChatController") as! ChatController
            let other : GroupInbox = groupArray[indexPath.row]
            let dict:NSDictionary =
                ["id":other.gid ?? "","image":other.image ?? "","name":other.name ?? ""
            ]
            controller.isGroup = true
            passDict = UserDetail(user: dict)
            controller.friend = passDict
            self.navigationController?.pushViewController(controller, animated: true)
            
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (tableView.indexPathsForVisibleRows?.last)?.row {
           self.refreshControl.endRefreshing()
        }
    }
    
    
}



/*
     1) Create a group
     2) Group Listing
         a) My Groups either approved or not
         b) All others approved groups
 
     PLease include the members name and id's only
 
     3) send request to a particular group
     4) Accept a request
     5) Reject a request
     6) Delete API Group owner
 
 
 
*/


