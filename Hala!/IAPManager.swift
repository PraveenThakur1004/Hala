//
//  IAPManager.swift
//  Jack
//
//  Created by Andrey Chernukha on 9/29/15.
//  Copyright © 2015 Brian Parker. All rights reserved.
//

import UIKit
import StoreKit
//MARK:-Constants
let kBuy10Points : String = "com.music.item"
let kBuy20Points : String = "com.edgemusic.premium"
let kBuy30Points : String = "com.edgemusic.standard"
let kBuy40Points : String = "com.edgemusic.standard"


let kIdentifierKey : String = "identifier"

class IAPManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver
{
    var products : [SKProduct]? = nil
    static var instance : IAPManager = IAPManager()
    func initialize(){
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
        self.getProducts()
    }
    func getProducts()
    {
        if SKPaymentQueue.canMakePayments(){
            let productIdentifiers : NSSet = NSSet(objects:kBuy10Points,kBuy20Points,kBuy30Points,kBuy40Points)
            let productsRequest : SKProductsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
            productsRequest.delegate = self
            productsRequest.start()
        }
        
    }
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse)
    {
        if response.invalidProductIdentifiers.count > 0
        {
            //          return
            //abort()
            NSLog("Log")
        }
        products = response.products
      }
    func buyProduct(_ index : Int )
    {
        let payment : SKPayment = SKPayment(product: (products![index]))
        SKPaymentQueue.default().add(payment)
        SKPaymentQueue.default().add(self)
    }
    func restoreProduct(){
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction])
    {
        print ("Tran dec: \(transactions.description)")
        for transaction in transactions
        {
            switch transaction.transactionState
            {
            case .purchased:
                productPurchased("Purchased");
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                productPurchased("Failed") ;
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                productPurchased("Restored")
                if  transaction.payment.productIdentifier == kBuy10Points{
                transaction.payment
                
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            case .purchasing:
                break
            case .deferred:
                productPurchased("Deferred")
                
            }
        }
        
    }
    func productPurchased(_ purchaseType : String)
    {
        let useInfo:NSDictionary = NSDictionary(object: purchaseType, forKey: "Type" as NSCopying)
        let notification = Notification(name: Notification.Name(rawValue: "ItemPurchaseNotification"), object: self, userInfo: useInfo as? [AnyHashable: Any])
        NotificationCenter.default.post(notification)
    }
    func transactionFailed(_ error : NSError?)
    {
        let message : String = error == nil ? "Unknown error" : error!.localizedDescription
        let alert : UIAlertView = UIAlertView(title: "Transaction failed", message: message, delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
}
