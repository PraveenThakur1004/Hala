//
//  LotteryController.swift
//  hala
//
//  Created by MAC on 01/10/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import FTIndicator

class LotteryController: UIViewController {
    var pointArray : [LotteryPoint] = []
    var selectedCell : LotteryCell!
    @IBOutlet weak var collector: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Lottery"
        
        self.collector.isUserInteractionEnabled = true

        
        let backBtn : UIButton = UIButton(frame : CGRect(x:0,y:0,width: 44, height :44))
        backBtn.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        backBtn.addTarget(self, action: #selector(LotteryController.backTap), for: .touchDown)
        let barButton : UIBarButtonItem = UIBarButtonItem(customView : backBtn)
        self.navigationItem.leftBarButtonItem = barButton
        
        collector.register(UINib(nibName : "LotteryCell",bundle : nil), forCellWithReuseIdentifier: "LotteryCell")
        
        getLotteryPoints()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func backTap(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func getLotteryPoints(){
        
        var langParam : String = "en"
        if let lang = UserDefaults.standard.object(forKey: "lang") as? String{
            langParam = lang
        }
        
        let param = ["lang":langParam]
        let urlString : String = URLConstants.baseUrl + URLConstants.dailyPoints + param.convertDictionary()
        ServerData.getResponseFromURL(urlString: urlString, loaderNeed: true) { (dataDictionary) in
            if let art = dataDictionary["data"] as? NSArray{
                if art.count > 0{
                    for i in 0 ..< art.count {
                        let dict = art[i] as! NSDictionary
                        let point = dict["Point"]  as! NSDictionary
                        let lott : LotteryPoint = LotteryPoint.init(user: point)
                        self.pointArray.append(lott)
                    }
                    self.collector.reloadData()
                }
            }
        }
    }
    
    func addPoints(points : String){
        
        var langParam : String = "en"
        if let lang = UserDefaults.standard.object(forKey: "lang") as? String{
            langParam = lang
        }
        
         if let userId = UserDefaults.standard.object(forKey: "user_id") as? String{
            var param = ["points":points,"lang":langParam,"user_id":userId]
            //let urlString : String = URLConstants.baseUrl  + URLConstants.addMorePoints
            let urlString : String = URLConstants.baseUrl  + "dailyPoint?"
            param = ["point":points,"lang":langParam,"user_id":userId,"type":"3"]
            ServerData.postResponseFromURL(urlString: urlString, showIndicator: false, params: param, completion: { (dataDictionary) in
                FTIndicator.showSuccess(withMessage: "You have earned \(points) points")
                DispatchQueue.main.async {
                    sleep(1)
                    self.backTap()
                }
                
            })
        }
    }
   
}
extension LotteryController : UICollectionViewDataSource , UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pointArray.count;
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LotteryCell", for: indexPath) as! LotteryCell
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let lott : LotteryPoint = pointArray[indexPath.row]
        if selectedCell != nil{
            selectedCell.flipCell(text: lott.points!)
        }
        self.collector.isUserInteractionEnabled = false
        selectedCell = collectionView.cellForItem(at: indexPath) as! LotteryCell
        selectedCell.flipCell(text: lott.points!)
        
        self.addPoints(points: lott.points!)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sizeWidth : CGFloat = (view.frame.size.width/3) - 20
        let sizer : CGSize = CGSize(width : sizeWidth , height : sizeWidth)
        return sizer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 10, 5, 10)
    }
    
}
