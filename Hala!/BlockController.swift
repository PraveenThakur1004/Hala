//
//  BlockController.swift
//  hala
//
//  Created by MAC on 16/10/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import FTIndicator


class BlockController: UIViewController {
    
    var userArray : [UserDetail] = []
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var backImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("Block List", comment: "")
        
        self.tblView.tableFooterView = UIView()
        
        self.getBlockList()
        
        
        
        
        let backBtn : UIButton = UIButton(frame : CGRect(x:0,y:0,width: 44, height :44))
        backBtn.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        backBtn.addTarget(self, action: #selector(SettingsController.backTap), for: .touchDown)
        let barButton : UIBarButtonItem = UIBarButtonItem(customView : backBtn)
        self.navigationItem.leftBarButtonItem = barButton
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func backTap(){
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tblView.isHidden = false
        self.backLabel.isHidden = true
        self.backImageView.isHidden = true
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func getBlockList(){
        if let userId = UserDefaults.standard.object(forKey: "user_id") as? String{
            if let lang = UserDefaults.standard.object(forKey: "lang") as? String{

            let param = ["lang":lang,"user_id":userId]
            let urlString = URLConstants.baseUrl + URLConstants.blockList
            print(urlString)
            ServerData.postResponseFromURL(urlString: urlString, showIndicator: true, params: param, completion: { (dataDictionary) in
                
                
                if let users = dataDictionary["data"] as? NSArray{
                    for i in 0 ..< users.count {
                        let dict = users[i] as! NSDictionary
                        let user : UserDetail = UserDetail.init(user: dict)
                        self.userArray.append(user)
                    }
                }
                
                if self.userArray.count == 0{
                    self.tblView.isHidden = true
                    self.backLabel.isHidden = false
                    self.backImageView.isHidden = false
                }else{
                    if let mesg = dataDictionary["mesg"] as? String{
                        FTIndicator.showToastMessage(mesg)
                    }
                }
                
                
                self.tblView.reloadData()
                print(self.userArray)
                
         
                
            })
        }
        }
    }
    
    
    func removeHot(path : IndexPath){
        if let userId = UserDefaults.standard.object(forKey: "user_id") as? String{
            let user : UserDetail = self.userArray[path.row]
            
            self.userArray.remove(at: path.row)
            
            FTIndicator.showToastMessage(NSLocalizedString("User removed from the blocklist", comment: ""))
            
            let indexxer : IndexPath = IndexPath(row : path.row, section : 0)
            self.tblView.beginUpdates()
            self.tblView.deleteRows(at: [indexxer], with: .fade)
            self.tblView.endUpdates()
            
            
            if self.userArray.count == 0{
                self.tblView.isHidden = true
                self.backLabel.isHidden = false
                self.backImageView.isHidden = false
            }
            
            if let lang = UserDefaults.standard.object(forKey: "lang") as? String{

            let urlString : String = URLConstants.baseUrl + URLConstants.removeHotBlocklist
            
            let param = ["add_by":userId,"add_to":user.uid,"lang":lang,"status":"0"]
            
            ServerData.postResponseFromURL(urlString: urlString, showIndicator: true, params: param as! [String : String], completion: { (dataDictionary) in
                print(dataDictionary)
            })
            }
        }
        
    }
    
    
}

extension BlockController : UITableViewDelegate , UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleCell", for: indexPath as IndexPath) as! PeopleCell
        
        let user : UserDetail = userArray[indexPath.row]
        
        cell.nameLabel.text = user.name
        
        if user.gender == true{
            cell.genderImageView.isHidden = true
        }else{
            cell.genderImageView.isHidden = false
        }
        if user.distance! == "0"{
            cell.distanceLabel.text = ""
        }else{
            cell.distanceLabel.text = "\(user.distance!) Km"
        }
        
        if let url = URL(string : user.image){
            cell.userImageView.sd_setImage(with: url, placeholderImage: nil)
        }
        
        cell.deleteBtn.layer.cornerRadius = 4
        cell.deleteBtn.layer.borderWidth = 1
        cell.deleteBtn.layer.borderColor = UIColor.red.cgColor
        cell.deleteBtn.clipsToBounds = true
        cell.deleteBtn.addTarget(self, action: #selector(BlockController.deleteAction(notify:)), for: .touchUpInside)
        
        
        return cell
    }
    

   @objc func deleteAction(notify : UIButton){
        let indexPath : IndexPath = IndexPath(row:notify.tag , section:0)
        self.removeHot(path: indexPath)
    }
//
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete{
//            self.removeHot(path: indexPath)
//        }
//    }
    
}

