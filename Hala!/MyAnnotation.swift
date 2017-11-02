//
//  MyAnnotation.swift
//  DigiLabs
//
//  Created by Apple on 01/09/17.
//  Copyright © 2017 VINSAM. All rights reserved.
//

import UIKit
import MapKit

class MyAnnotation: NSObject , MKAnnotation  {
    var title : String?
    var mapID : String?
    var subTit : String?
    var coordinate : CLLocationCoordinate2D
    init(title:String,coordinate : CLLocationCoordinate2D , mapID : String){
        self.title = title;
        self.coordinate = coordinate;
        self.mapID = mapID
    }
    
    
}
