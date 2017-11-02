//
//  AppDelegate.swift
//  hala
//
//  Created by MAC on 28/09/17.
//  Copyright © 2017 Orem. All rights reserved.
//65,4,85


import UIKit
import CoreData
import IQKeyboardManagerSwift
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import UserNotifications
import CoreLocation
import LocationRequestManager
import GoogleMobileAds
import Fabric
import TwitterKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    let locationRequestManager: LocationRequestManager = LocationRequestManager()
    var basicRequest:LocationRequest?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let pre = Locale.preferredLanguages[0]
        print("Preffered Language -------- \(pre)")
        
        if UserDefaults.standard.object(forKey: "lang") == nil{
            
            let art  = pre.components(separatedBy: "-") as NSArray
            UserDefaults.standard.set(art[0], forKey: "lang")
            UserDefaults.standard.synchronize()
        }
        
        
        
        self.basicRequest = LocationRequest{(currentLocation:CLLocation?,error: Error?)->Void in
            if currentLocation != nil{
                let lat : Double = (currentLocation?.coordinate.latitude)!
                let lng : Double = (currentLocation?.coordinate.longitude)!
                UserDefaults.standard.set(lat, forKey: "Lat")
                UserDefaults.standard.synchronize()
                UserDefaults.standard.set(lng, forKey: "Lng")
                UserDefaults.standard.synchronize()
            }
            print("\(self.basicRequest!.status) - \(currentLocation) - \(error)")
        }
        
        locationRequestManager.addRequest(request: self.basicRequest!)
        locationRequestManager.performRequests()
        
        
        self.addNotificationsPermissions(application: application)
        
        FirebaseApp.configure()
        IQKeyboardManager.sharedManager().enable = true
        self.configureTwitter()
        GADMobileAds.configure(withApplicationID: "ca-app-pub-8538545485769168~2835060566")
        
        
        
        
        //        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(),
        //                                                    withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
        
        
        
        self.goHomeController()
        
        
        
        
        
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
    }
    
    
    
    public func goHomeController(){
        if (UserDefaults.standard.object(forKey: "user_id") as?  String) != nil{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nav = storyboard.instantiateViewController(withIdentifier: "nav")
            window?.rootViewController = nav
        }
    }
    
    // MARK: - App Functions
    func addNotificationsPermissions(application : UIApplication){
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
    }
    
    
    func configureTwitter(){
        Twitter.sharedInstance().start(withConsumerKey:"7TvKXFJkZJmKAXQPy3aUvyquk", consumerSecret:"Og5vVSGrhxFxHYRr14etvhAXEuHDzklvp0tidVpNHirQSuLdmf")
        Fabric.with([Twitter.sharedInstance()]  as [Any])
    }
    
    
    // MARK: - Notifications Handler
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print(token)
        UserDefaults.standard.set(token, forKey: "DToken")
        UserDefaults.standard.synchronize()
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        
        FBSDKAppEvents.activateApp()
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    
    func setOnlineStatus(status : String){
        if let userId = UserDefaults.standard.object(forKey: "user_id") as? String{
            if let lang = UserDefaults.standard.object(forKey: "lang") as? String{
                let urlString : String = URLConstants.baseUrl + "online?"
                let param = ["user_id":userId,"online":status,"lang":lang]
                ServerData.postResponseFromURL(urlString: urlString, showIndicator: false, params: param) { (data) in
                    print(data)
                }
            }
        }
    }
    
    
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        self.setOnlineStatus(status: "0")
        
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        self.setOnlineStatus(status: "1")
        
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        self.setOnlineStatus(status: "1")
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.setOnlineStatus(status: "0")
        
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
    
    
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return Twitter.sharedInstance().application(app, open: url, options: options)
    }
    

    
}
/*
 pod 'JHTAlertController', '~> 0.2'
 
 pod 'IQKeyboardManagerSwift', '~> 5.0'
 pod 'FBSDKCoreKit'
 pod 'FBSDKLoginKit'
 pod 'FBSDKShareKit'
 pod 'Alamofire'
 pod 'Firebase/Storage'
 pod 'Firebase/Auth'
 pod 'Firebase/Database'
 pod 'Google-Mobile-Ads-SDK', '~> 7.25'
 pod 'SDWebImage', '~>3.8'
 pod 'LocationRequestManager'
 pod 'FTIndicator', '~> 1.2'
 pod 'CarbonKit'
 pod 'FTPopOverMenu_Swift', '~> 0.0.6'
 pod 'JSQMessagesViewController', '~> 7.3'
 pod 'CZPicker', '~> 0.4'
 */

