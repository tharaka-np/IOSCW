//
//  SingleMapViewController.swift
//  NIBMCOVID19
//
//  Created by Tharaka Pathirana on 9/20/20.
//  Copyright © 2020 Tharaka Pathirana. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Firebase

class SingleMapViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    var lati: Double = 0
    var long: Double = 0
    
    var mapLocations : [MapModel] = []
    
    var mLocation : MapMarker!
    
    
    @IBOutlet weak var largeMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        fetchDataMapLocations()
        // Do any additional setup after loading the view.
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = 5
            
            DispatchQueue.main.async {
                self.locationManager.startUpdatingLocation()
            }
        }
        
        largeMap.delegate = self
        largeMap.showsUserLocation = true
        
        mLocation = MapMarker(coordinate: CLLocationCoordinate2D(latitude: lati, longitude: long))
    }
    
    func mapData(locations: [MapModel]){
        print(locations)
        self.mapLocations.removeAll()
        self.largeMap.removeAnnotations(largeMap.annotations)
        
        self.mapLocations.append(contentsOf: locations)
        self.mapLocations = locations
        self.updateMapData()
    }
    
    func updateMapData(){
        for data in mapLocations{
            
            if data.uid == Auth.auth().currentUser?.uid ?? "" {
                self.largeMap.addAnnotation(mLocation)
                continue
            }
            
            let coordinate = CLLocationCoordinate2D(latitude: data.latitude, longitude: data.longtitude)
            let pin = MapMarker(coordinate: coordinate)
            if data.temp < 36 {
                pin.title = "SAFE"
                
            } else {
                pin.title = "RISK"
                
            }
            
            self.largeMap.addAnnotation(pin)
        }
    }
    
    func fetchDataMapLocations() {
        
        var mapLocation : [MapModel] = []
        
        Database.database().reference().child("userCoordinates").observe(.childChanged, with: {
            snapshot in
            
            Database.database().reference().ref.child("userCoordinates").observeSingleEvent(of: .value, with: { snapshot in
                
                mapLocation.removeAll()
                
                if let dict = snapshot.value as? [String: Any] {
                    for loc in dict{
                        guard let innerDict = loc.value as? [String: Any] else {
                            continue
                        }
                        
                        mapLocation.append(MapModel(latitude: innerDict["latitude"] as! Double, longtitude: innerDict["longitude"] as! Double, uid: innerDict["uid"] as! String, temp: innerDict["temp"] as! Int, syncDateTime: innerDict["syncDateTime"] as! String))
                    }
                    
                    self.mapData(locations: mapLocation)
              
                }
                
            })
            
        })
        
        Database.database().reference().child("userCoordinates").observeSingleEvent(of: .value, with: { snapshot in
            
            if let Dict = snapshot.value as? [String: Any] {
                
                for (_,value) in Dict {
                    guard let innerDict = value as? [String: Any] else {
                        continue
                    }
                    
                    mapLocation.append(MapModel(latitude: innerDict["latitude"] as! Double, longtitude: innerDict["longitude"] as! Double, uid: innerDict["uid"] as! String, temp: innerDict["temp"] as! Int, syncDateTime: innerDict["syncDateTime"] as! String))
                    
                }
                
                self.mapData(locations: mapLocation)
            }
        })
        
    }

}

extension SingleMapViewController :  MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotionView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        
        if annotation.title == "RISK" {
            annotionView.image = #imageLiteral(resourceName: "icons8-street-view-100")
        }
        
        if annotation.title == "SAFE" {
            annotionView.image = #imageLiteral(resourceName: "location(2)")
        }
        
        if annotation.title == "I AM" {
            annotionView.image = #imageLiteral(resourceName: "location")
        }
        
        annotionView.canShowCallout = true
        return annotionView
    }
}

extension SingleMapViewController : CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {

//            let values = [
//                "longitude": location.coordinate.longitude,
//                "latitude": location.coordinate.latitude,
//                "uid": Service.shared.getUserUid()
//            ] as [String : Any]
//
//            let dat = Service.shared.updateUserCordinates(values)
            
            largeMap.removeAnnotation(mLocation)
            mLocation = MapMarker(coordinate: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
            mLocation.title = "I AM"
            self.largeMap.addAnnotation(mLocation)
            
            lati = location.coordinate.latitude
            long = location.coordinate.longitude
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.largeMap.setRegion(region, animated: true)
            
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager Error: \(error.localizedDescription)")
    }

}
