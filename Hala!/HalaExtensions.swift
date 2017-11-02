//
//  HalaExtensions.swift
//  hala
//
//  Created by MAC on 28/09/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit

extension String {
    
    //To check text field or String is blank or not
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }
    
    //Validate Email
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
    
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    //Trim Leading & Trailing Spaces
    func Trim() -> String {
        let trimmedString = self.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return trimmedString
    }
}

extension Dictionary{
    func convertDictionary() -> String{
        let mutableString : NSMutableString = ""
        for (key, value) in self {
            print("\(key): \(value)")
            let str : String = "\(key)=" + "\(value)"
            if mutableString == ""{
                mutableString.append(str)
                
            }else{
                mutableString.append("&\(str)")
            }
        }
        return String(mutableString)
    }
}

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.black.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}

extension UIImage{
    
    func flipImageLeftRight(_ image: UIImage) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: image.size.width, y: image.size.height)
        context.scaleBy(x: -image.scale, y: -image.scale)
        
        context.draw(image.cgImage!, in: CGRect(origin:CGPoint.zero, size: image.size))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func resizeImageWith(newSize: CGSize) -> UIImage {
        
        let scale = newSize.height / self.size.height
        let newWidth = self.size.width * scale
        UIGraphicsBeginImageContext(CGSize(width : newWidth, height : newSize.height))
        self.draw(in: CGRect(x:0,y: 0, width:newWidth,height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
    
}
extension Foundation.Date {
    func dashedStringFromDate() -> String {
        let dateFormatter = DateFormatter()
        let date = self
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        return dateFormatter.string(from: date)
    }
}


extension NSDictionary
{
    func RemoveNullValueFromDic()-> NSDictionary
    {
        let mutableDictionary:NSMutableDictionary = NSMutableDictionary(dictionary: self)
        for key in mutableDictionary.allKeys
        {
            let value = mutableDictionary[key] as AnyObject
            if(value is NSNull)
            {
                mutableDictionary.setValue("", forKey: key as! String)
            }
            
        }
        return mutableDictionary
    }
}
