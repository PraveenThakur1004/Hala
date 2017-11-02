//
//  MapController.swift
//  hala
//
//  Created by MAC on 17/10/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import MapKit

class MapController: UIViewController , MKMapViewDelegate {

    var userArray : [UserDetail] = []
    var currentLat : Float = 30.7333
    var currentLng : Float = 76.7794
    var selectedUser : UserDetail!
    @IBOutlet weak var mapper: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapper.delegate = self
        
        let logoBtn : UIButton = UIButton(frame : CGRect(x:0,y:0,width: 80, height :24))
        logoBtn.setBackgroundImage(#imageLiteral(resourceName: "header_logo"), for: .normal)
        logoBtn.isUserInteractionEnabled = false
        let barButton : UIBarButtonItem = UIBarButtonItem(customView : logoBtn)
        self.navigationItem.leftBarButtonItem = barButton
        
        self.navigationController?.navigationItem.hidesBackButton = true
        
        if let lattitude = UserDefaults.standard.object(forKey: "Lat") as? Float{
            currentLat = lattitude
        }
        if let longitude = UserDefaults.standard.object(forKey: "Lng") as? Float{
            currentLng = longitude
        }
        
        let center = CLLocationCoordinate2D(latitude: CLLocationDegrees(currentLat), longitude: CLLocationDegrees(currentLng))
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapper.setRegion(region, animated: true)
        self.mapper.showsUserLocation = true
        self.mapper.showsCompass = true
        self.mapper.showsTraffic = true
        
        
        self.addAnnotations()
    }
    
    func addAnnotations(){
        for i in 0 ..< userArray.count {
            let dict : UserDetail = userArray[i]
            let name = dict.name!
            let coordLat = dict.lat
            let coordLng = dict.lng
            let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(CLLocationDegrees(coordLat!), CLLocationDegrees(coordLng!))
            let myAnnot = MyAnnotation(title: name, coordinate: location , mapID : dict.uid);
            mapper.addAnnotation(myAnnot);
            //mapper.selectedAnnotations = [myAnnot]
        }
        
        zoomMapaFitAnnotations()
        
    }
    
    func zoomMapaFitAnnotations() {
        var zoomRect = MKMapRectNull
        for annotation in mapper.annotations {
            let annotationPoint = MKMapPointForCoordinate(annotation.coordinate)
            let pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0)
            if (MKMapRectIsNull(zoomRect)) {
                zoomRect = pointRect
            } else {
                zoomRect = MKMapRectUnion(zoomRect, pointRect)
            }
        }
        self.mapper.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsetsMake(50, 50, 50, 50), animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Don't want to show a custom image if the annotation is the user's location.
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        // Better to make this class property
        let annotationIdentifier = "AnnotationIdentifier"
        
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            let image = #imageLiteral(resourceName: "user_default")
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            button.setImage(image, for: UIControlState())
            annotationView?.rightCalloutAccessoryView = button
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        if let annotationView = annotationView {
            annotationView.canShowCallout = true
            annotationView.image = #imageLiteral(resourceName: "user_default")
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        
        let controller : ProfileController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileController") as! ProfileController
        controller.passedUser = selectedUser
        self.navigationController?.pushViewController(controller, animated: true)
        
        
//        let ann : MyAnnotation = view.annotation as! MyAnnotation
        
//        let namePredicate = NSPredicate(format: "name == %@",ann.title!);
//        let filteredArray = self.userArray.filter { namePredicate.evaluate(with: $0) };
//
//        print(filteredArray)
    }
    
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let annot : MyAnnotation = view.annotation! as! MyAnnotation
        for i in 0 ..< userArray.count {
            let dict : UserDetail = userArray[i]
            let uid : String = dict.uid
            if uid == annot.mapID!{
                print(annot.title)
                
                selectedUser = dict
                
                return
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func listAction(_ sender: Any) {
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
