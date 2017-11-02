//
//  SubscriptionController.swift
//  hala
//
//  Created by MAC on 30/09/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit

class SubscriptionController: UIViewController {
    
    @IBOutlet weak var pointsTable: UITableView!
    var subscritionArray : [Subscription] = []
    var selectedFriend: [String: AnyObject] = [:]
    var selectedAddressId: String = ""
    var selectedName: String = ""
    var selectedPhone: String = ""
    var selectedAddress: [String: AnyObject] = [:]
    var totalAmountToPaid = ""
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let backBtn : UIButton = UIButton(frame : CGRect(x:0,y:0,width: 44, height :44))
        backBtn.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        backBtn.addTarget(self, action: #selector(SubscriptionController.backTap), for: .touchDown)
        let barButton : UIBarButtonItem = UIBarButtonItem(customView : backBtn)
        self.navigationItem.leftBarButtonItem = barButton
        
        
        self.title = "Purchase Points"
        
        pointsTable.tableFooterView = UIView()
      
        self.getSubsriptions()
        
        // Do any additional setup after loading the view.
    }
    
    func getSubsriptions(){
        if let lang = UserDefaults.standard.object(forKey: "lang") as? String{

        let param = ["lang":lang]
        let urlString = URLConstants.baseUrl + URLConstants.subscriptionList + param.convertDictionary()
        ServerData.getResponseFromURL(urlString: urlString, loaderNeed: true) { (data) in
            print(data)
            if let dicto = data["data"] as? NSArray{
                for i in 0 ..< dicto.count {
                    let dict = dicto[i] as! NSDictionary
                    let dict2 = dict["Subscription"] as! NSDictionary
                    let subsc : Subscription = Subscription.init(subscritions: dict2)
                    self.subscritionArray.append(subsc)
                }
                self.pointsTable.reloadData()
            }
        }
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func backTap(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
 
    
    

    
}

extension SubscriptionController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscritionArray.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionCell", for: indexPath) as! SubscriptionCell
        let points = subscritionArray[indexPath.row]
        cell.pointsLabel.text = points.name.capitalizingFirstLetter()
        cell.amountLabel.text = "Buy for \(points.amount!)"
        cell.earnLabel.text = "Earn \(points.points!) points"
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let points = subscritionArray[indexPath.row]
        self.totalAmountToPaid = points.amount!
        //self.setUpPayPal()
    }
    
}
extension String {
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
