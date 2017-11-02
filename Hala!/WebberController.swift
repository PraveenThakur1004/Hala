//
//  WebberController.swift
//  hala
//
//  Created by MAC on 30/09/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import FTIndicator
class WebberController: UIViewController {
    @IBOutlet weak var webber: UIWebView!
     @IBOutlet weak var textter: UITextView!
    var titleString : String = ""
    var ifPolicy : Bool = false
    var urlString : String!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = titleString
        
        let backBtn : UIButton = UIButton(frame : CGRect(x:0,y:0,width: 44, height :44))
        backBtn.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        backBtn.addTarget(self, action: #selector(SettingsController.backTap), for: .touchDown)
        let barButton : UIBarButtonItem = UIBarButtonItem(customView : backBtn)
        self.navigationItem.leftBarButtonItem = barButton
        
        
        FTIndicator.showProgress(withMessage: "Loading...")
        
        
        if ifPolicy == true{
            textter.isHidden = true
            let myURL = URL(string: urlString)
            let myRequest = URLRequest(url: myURL!)
            webber.loadRequest(myRequest)
        }else{
            webber.isHidden = true
            self.getAboutUs()
        }
        
     

        // Do any additional setup after loading the view.
    }
    
    func getAboutUs(){
        var langParam : String = "en"
        if let lang = UserDefaults.standard.object(forKey: "lang") as? String{
            langParam = lang
        }
        let urlString : String = URLConstants.baseUrl + URLConstants.aboutUS
        let param = ["lang":langParam]
        ServerData.postResponseFromURL(urlString: urlString, showIndicator: true, params: param) { (dataDictionary) in
            print(dataDictionary)
            if let data = dataDictionary["data"] as? NSDictionary{
                if let status = data["info"] as? String{
                    self.textter.text = status
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension WebberController : UIWebViewDelegate{

    func webViewDidFinishLoad(_ webView: UIWebView) {
        FTIndicator.dismissProgress()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        FTIndicator.dismissProgress()
    }
}
