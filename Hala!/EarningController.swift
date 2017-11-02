//
//  EarningController.swift
//  hala
//
//  Created by MAC on 28/09/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import FTIndicator
import GoogleMobileAds


class EarningController: UIViewController , GADRewardBasedVideoAdDelegate {
    
    
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    let userCalendar = Calendar.current
    let requestedComponent: Set<Calendar.Component> = [.month,.day,.hour,.minute,.second]
    

    var rewardBasedVideo: GADRewardBasedVideoAd?

    
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var lotteryBtn: UIButton!


    let todaysDate = NSDate()

    
    override func viewDidLoad() {
        
        
        rewardBasedVideo = GADRewardBasedVideoAd.sharedInstance()
        rewardBasedVideo?.delegate = self
        rewardBasedVideo?.load(GADRequest(),withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
        
        
        if let user = UserDefaults.standard.object(forKey: "User") as? NSDictionary{
            if let points = user["point"] as? String{
                self.pointsLabel.text = "\(points) Points"
            }else{
                self.pointsLabel.text = "0 Points"
            }
        }
        let backBtn : UIButton = UIButton(frame : CGRect(x:0,y:0,width: 44, height :44))
        backBtn.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        backBtn.addTarget(self, action: #selector(EarningController.backTap), for: .touchDown)
        let barButton : UIBarButtonItem = UIBarButtonItem(customView : backBtn)
        self.navigationItem.leftBarButtonItem = barButton
        
        self.title = "Earn Points"
        
  
        
        
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func getPoints(){
        if let userId = UserDefaults.standard.object(forKey: "user_id") as? String{
            if let lang = UserDefaults.standard.object(forKey: "lang") as? String{

        let urlString : String = URLConstants.baseUrl + URLConstants.getProfille
        let param = ["user_id":userId,"lang":lang]
        
            ServerData.postResponseFromURL(urlString: urlString, showIndicator: false, params: param, completion: { (data) in
                print(data)
                let dataValue : NSDictionary = data["data"] as! NSDictionary
                let points = dataValue["point"] as! String
                self.pointsLabel.text = "\(points) Points"
                
                let pointDate : String = dataValue["point_update"] as! String
                UserDefaults.standard.set(pointDate, forKey: "PointDate")
                UserDefaults.standard.synchronize()
                
            })
        }
        }
    }
    
    
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let notificationName = Notification.Name("RefreshButtons")
        NotificationCenter.default.post(name: notificationName, object: nil)
       
        
        self.getPoints()
        /*if let waitingDate:NSDate = UserDefaults.standard.value(forKey: "waitingDate") as? NSDate {
            if (todaysDate.compare(waitingDate as Date) == ComparisonResult.orderedDescending) {
                print("show button")
                self.lotteryBtn.alpha = 0.6
                self.lotteryBtn.isUserInteractionEnabled = false
            }
            else {
                print("hide button")
                self.lotteryBtn.alpha = 0.6
                self.lotteryBtn.isUserInteractionEnabled = false
            }
        }*/
    }
    
    
    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Opened")
    }
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Closed")
    }
    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Recieved")
        if rewardBasedVideo?.isReady == true {
            rewardBasedVideo?.present(fromRootViewController: self)
        }
    }
    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Started")
    }
    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Leave")
    }
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didFailToLoadWithError error: Error) {
        print("Closed \(error)")
    }
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        print("Reward \(reward.type) \(reward.amount)")
        let str : String = String(describing: reward.amount)
        self.addPoints(points: str)
    }
    
    
    func addPoints(points : String){
        if let userId = UserDefaults.standard.object(forKey: "user_id") as? String{
            if let lang = UserDefaults.standard.object(forKey: "lang") as? String{

            var param = ["points":points,"lang":lang,"user_id":userId]
            //let urlString : String = URLConstants.baseUrl  + URLConstants.addMorePoints
            let urlString : String = URLConstants.baseUrl  + "dailyPoint?"
            param = ["point":points,"lang":lang,"user_id":userId,"type":"2"]
            ServerData.postResponseFromURL(urlString: urlString, showIndicator: false, params: param, completion: { (dataDictionary) in
                FTIndicator.showSuccess(withMessage: "You have earned \(points) points")
                DispatchQueue.main.async {
                    self.getPoints()
                }
                
            })
            }
        }
    }
    
    
    
    
    @objc func backTap(){
        navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func set24HrTimer() {
        let currentDate = NSDate()
        let newDate = NSDate(timeInterval: 86400, since: currentDate as Date)
        UserDefaults.standard.setValue(newDate, forKey: "waitingDate")
    }
    
    
    func checkDate() -> Bool{
        var chk : Bool = false
        if let dateString = UserDefaults.standard.object(forKey: "PointDate") as? String{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-mm-dd hh:mm:ss" //Your date format
            let date = dateFormatter.date(from: dateString) //according to date format your date string
            print(date ?? "")
            if date! < Date(){
                chk = true
            }
        }
        return chk
    }
    
    
    
    @IBAction func goToLottery(_ sender: Any) {
        
        if let dateString = UserDefaults.standard.object(forKey: "PointDate") as? String{
            
            
            
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let startTime = Date()
             let endTime = dateFormatter.date(from: dateString)
            if endTime != nil{
                let calender:Calendar = Calendar.current
                let components: DateComponents = calender.dateComponents([.year, .month, .day, .hour, .minute, .second], from: endTime!, to: startTime)
                
                 let components2: DateComponents = calender.dateComponents([.year, .month, .day, .hour, .minute, .second], from: startTime, to:  endTime!)
                     print(components2)
                print(components)
                if components.day! >= 1{
                    self.performSegue(withIdentifier: "Lottery", sender: self)
                }else{
                    FTIndicator.showToastMessage("Please check after few hours")
                }
            }else{
                self.performSegue(withIdentifier: "Lottery", sender: self)
            }

        }
        
        
       // set24HrTimer()
    }
    @IBAction func goToSubscptn(_ sender: Any) {
        
        self.performSegue(withIdentifier: "Subscriber", sender: self)
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
 
    
    
    
}

extension Date {
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    var isLastDayOfMonth: Bool {
        return tomorrow.month != month
    }
    func hoursBetweenDate(toDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.hour], from: self, to: toDate)
        return components.hour ?? 0
    }
}


