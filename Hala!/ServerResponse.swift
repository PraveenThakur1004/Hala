//
//  ServerResponse.swift
//  hala
//
//  Created by MAC on 03/10/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import CoreLocation


////////////All Inbox Users
struct UserDetail {
    var star_User : String!
    var star_Points : String!
    var social_type : String!
    var backgroundImage : String!
    var bloodGroup : String!
    var email : String!
    var distance : String!
    var dob : String!
    var drinks : String!
    var ethinicity : String!
    var eyeColor : String!
    var gender : Bool!
    var hairColor : String!
    var hobby : String!
    var height : String!
    var uid : String!
    var image : String!
    var intrested : String!
    var introduction : String!
    var lat : Double!
    var lng : Double!
    var name : String!
    var phone : String!
    var point : String!
    var online : Bool!
    var relationship : String!
    var smoke : String!
    var message : String?
    var favourate : String!

    init(user : NSDictionary )
    {
        let withoutNull = user.RemoveNullValueFromDic()
        
        uid =  withoutNull["id"] as? String ?? ""
        name =  withoutNull["name"] as? String ?? ""
        backgroundImage  =  withoutNull["bg_image"] as? String ?? ""
        bloodGroup =  withoutNull["blood_group"] as? String ?? ""
        email = withoutNull["email"] as? String ?? ""
        distance = "0"// withoutNull["distance"]! as! String
        dob = withoutNull["dob"] as? String  ?? ""
        drinks = withoutNull["drinking"] as? String ?? ""
        ethinicity = withoutNull["ethinicity"] as? String ?? ""
        eyeColor = withoutNull["eye_color"] as? String ?? ""
        height = withoutNull["height"] as? String ?? ""
        hobby = withoutNull["hobby"] as? String ?? ""
        image = withoutNull["image"] as? String ?? ""
        intrested = withoutNull["intrested"] as?  String ?? ""
        introduction = withoutNull["introduction"] as? String ?? ""
        hairColor = withoutNull["hair_color"] as? String ?? ""
        star_User = withoutNull["staruser"] as? String ?? "0"
        star_Points = withoutNull["Starpoints"] as? String ?? "0"

        
        social_type = withoutNull["social_type"] as? String ?? ""
        
        if let mess = withoutNull["mess"] as? String{
            message = mess
        }
        
        
        if let isMale = withoutNull["gender"] as? String{
            if isMale == "1"{
                gender = true
            }else{
                gender = false
            }
        }
        if let latt = withoutNull["lat"] as? String{
            lat = Double(latt)
        }
        if let lang = withoutNull["lng"] as? String{
            lng = Double(lang)
        }
        
        distance = ""
        
        
        
        
        if let latt = UserDefaults.standard.object(forKey: "Lat") as? CGFloat{
            if let lngg = UserDefaults.standard.object(forKey: "Lng") as? CGFloat{
                let coordinate₀ = CLLocation(latitude: CLLocationDegrees(latt), longitude: CLLocationDegrees(lngg))
                if lat != nil{
                    if lng != nil{
                        let validCord = CLLocationCoordinate2DMake(lat, lng)
                        let coordinate₁ = CLLocation(latitude: lat, longitude: lng)
                        if (CLLocationCoordinate2DIsValid(validCord)) {
                            let distanceInMeters = coordinate₀.distance(from: coordinate₁)
                            if(distanceInMeters <= 1609)
                            {
                                let dis = String(format: "%.2f",  distanceInMeters)
                                distance = "\(distanceInMeters) meters"
                            }
                            else
                            {
                                let dis = String(format: "%.2f",  distanceInMeters)
                                distance = "\(distanceInMeters/1609) miles"
                            }
                        }
                    }
                }
                
            }
        }
        
        
        
        
        
        favourate = "0"
        if let fav = withoutNull["favourate"] as? NSNumber{
            favourate = fav.stringValue
        }
        if let fav = withoutNull["favourate"] as? String{
            favourate = fav
        }
        
        
        
        if let isOnline = withoutNull["online"] as? String{
            if isOnline == "0"{
                online = false
            }else{
                online = true
            }
        }
        
        phone = withoutNull["phone"] as? String ?? ""
        point = withoutNull["point"] as? String ?? ""
        relationship = withoutNull["relationship"] as?  String ?? ""
        smoke = withoutNull["smoking"] as? String ?? ""
    }
    }



////////////All Inbox Users
struct LotteryPoint {
    var lid : String?
    var points : String?
    
    init(user : NSDictionary )    {
        let withoutNull = user.RemoveNullValueFromDic()
        lid =  withoutNull["id"]! as! String ?? ""
        points =  withoutNull["points"]! as! String ?? ""
    }
    
}

//created = "2017-10-16 13:12:17";
//description = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis";
//id = 12;
//image = "";
//joined = 0;
//modified = "2017-10-16 13:12:17";
//name = Hello;
//owner = 1;
//status = 0;
//"user_id" = 36;



////////////All Inbox Users
struct GroupInbox {
    var image : String?
    var name : String?
    var gid : String?
    var desc : String?
    var message : String?
    
    init(group : NSDictionary )
    {
        let withoutNull = group.RemoveNullValueFromDic()
        image =  withoutNull["image"]! as? String ?? ""
        name =  withoutNull["name"]! as? String ?? ""
        desc =  withoutNull["description"]! as? String ?? ""
        gid =  withoutNull["id"]! as? String ?? ""
        message =  withoutNull["mess"]! as? String ?? ""
        
    }
}


////////////All Inbox Users
struct Group {
    var image : String?
    var name : String?
    var gid : String?
    var desc : String?
    var ownerId : String?
    var approvalStatus : String?
    
    init(subscritions : NSDictionary )
    {
        let withoutNull = subscritions.RemoveNullValueFromDic()
        image =  withoutNull["image"]! as? String ?? ""
        name =  withoutNull["name"]! as? String ?? ""
        desc =  withoutNull["description"]! as? String ?? ""
        gid =  withoutNull["id"]! as? String ?? ""
        ownerId =  withoutNull["user_id"]! as? String ?? ""
        approvalStatus =  withoutNull["status"]! as? String ?? "0"

    }
}

struct OtherGroup {
    var image : String?
    var name : String?
    var gid : String?
    var desc : String?
    var ownerId : String?
    var approvalStatus : String?
    var member : Member?
    init(subscritions : NSDictionary )
    {
        let withoutNull = subscritions.RemoveNullValueFromDic()
        
        let dic1 : NSDictionary = withoutNull["Group"] as! NSDictionary
        
        image =  dic1["image"]! as? String ?? ""
        name =  dic1["name"]! as? String ?? ""
        desc =  dic1["description"]! as? String ?? ""
        gid =  dic1["id"]! as? String ?? ""
        ownerId =  dic1["user_id"]! as? String ?? ""
        
        let isJoined : String = dic1["joined"]! as? String ?? "0"
        let isPending : String = dic1["pending"]! as? String ?? "0"
        approvalStatus =  dic1["joined"]! as? String ?? "0"

        if isJoined == "0" && isPending == "0"{
            approvalStatus = "0"
        }
        if isJoined  == "1" && isPending == "0"{
            approvalStatus = "2"
        }
        if isJoined  == "0" && isPending == "1"{
            approvalStatus = "1"
        }
        
        
        
        if let dic = withoutNull["Member"] as? NSDictionary{
            member = Member.init(subscritions: dic)
        }
    }
}

struct Member {
    var request_status : String?
    var gid : String?
    var uid : String?
    
    init(subscritions : NSDictionary )
    {
        let withoutNull = subscritions.RemoveNullValueFromDic()
        request_status =  withoutNull["request_status"]! as? String ?? "1"
        gid =  withoutNull["id"]! as? String ?? ""
        uid =  withoutNull["member_id"]! as? String ?? "0"
        
    }
}






////////////All Inbox Users
struct Subscription {
    var sid : String!
    var name : String!
    var amount : String!
    var points : String!
    
    init(subscritions : NSDictionary )
    {
        let withoutNull = subscritions.RemoveNullValueFromDic()
        sid =  withoutNull["id"]! as! String
        name =  withoutNull["name"]! as! String
        amount  =  withoutNull["amount"]! as! String
        points =  withoutNull["points"]! as? String ?? "0"
    }
}
