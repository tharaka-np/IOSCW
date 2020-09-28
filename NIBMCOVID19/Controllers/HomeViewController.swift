//
//  HomeViewController.swift
//  NIBMCOVID19
//
//  Created by Tharaka Pathirana on 9/17/20.
//  Copyright © 2020 Tharaka Pathirana. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Firebase

class HomeViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    var lati: Double = 0
    var long: Double = 0
    
    var mapLocations : [MapModel] = []
    
    var mLocation : MapMarker!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var latestMsg: UILabel!
    
    
    @IBOutlet weak var lblInfected: UILabel!
    @IBOutlet weak var lblNoInfect: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        getLastNotification()
        locationManager.requestAlwaysAuthorization()
        
        fetchDataMapLocations()
        
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = 5
            
            DispatchQueue.main.async {
                self.locationManager.startUpdatingLocation()
            }
        }
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        mLocation = MapMarker(coordinate: CLLocationCoordinate2D(latitude: lati, longitude: long))
        
       
    }
    
    private var lastNotification : [notification]? {
            didSet {
                if lastNotification?.count ?? 0 > 0{
                    latestMsg.text = lastNotification?[0].title
                }
            }
        }
    
    func getLastNotification(){
        Service.shared.getLastNotification{ (notification) in
            self.lastNotification = notification
        }
    }
    
    func mapData(locations: [MapModel]){
        print(locations)
        self.mapLocations.removeAll()
        self.mapView.removeAnnotations(mapView.annotations)
        
        self.mapLocations.append(contentsOf: locations)
        self.mapLocations = locations
        self.updateMapData()
    }
    
    func updateMapData(){
        var infected = 0
        var non_infected = 0
        var totalUsers = 0
        for data in mapLocations{
            
            if data.uid == Auth.auth().currentUser?.uid ?? "" {
                self.mapView.addAnnotation(mLocation)
                continue
            }
            
            let coordinate = CLLocationCoordinate2D(latitude: data.latitude, longitude: data.longtitude)
            let pin = MapMarker(coordinate: coordinate)
            if data.temp < 36 {
                pin.title = "SAFE"
                infected = infected + 1
                
            } else {
                pin.title = "RISK"
                non_infected = non_infected + 1
                
            }
            
            self.mapView.addAnnotation(pin)
            
            totalUsers = totalUsers + 1
        }
        
        self.lblInfected.text = String(infected)
        self.lblNoInfect.text = String(non_infected)
        self.lblTotal.text = String(totalUsers)
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

extension HomeViewController :  MKMapViewDelegate{
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

extension HomeViewController : CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {

//            let values = [
//                "longitude": location.coordinate.longitude,
//                "latitude": location.coordinate.latitude,
//                "uid": Service.shared.getUserUid()
//            ] as [String : Any]
//
//            let dat = Service.shared.updateUserCordinates(values)
            
            mapView.removeAnnotation(mLocation)
            mLocation = MapMarker(coordinate: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
            mLocation.title = "I AM"
            self.mapView.addAnnotation(mLocation)
            
            lati = location.coordinate.latitude
            long = location.coordinate.longitude
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
            
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager Error: \(error.localizedDescription)")
    }

}



