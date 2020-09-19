//
//  ServiceLayer.swift
//  NIBMCOVID19
//
//  Created by Tharaka Pathirana on 9/19/20.
//  Copyright © 2020 Tharaka Pathirana. All rights reserved.
//

import Firebase

let DB_REF = Database.database().reference()
let USER_REF = DB_REF.child("users")
//let RFF_TEMPINFO = DB_REF.child("TemperatureDetails")
//let REFF_NOTIFICATION = DB_REF.child("Notifications")
//let REF_USERLOCATIONS = DB_REF.child("userLocationDetails")


//var allNotification = [notificationModel]()



struct Service {
    
    static let shared = Service()


    func getUserUid() ->String{
        return Auth.auth().currentUser?.uid ?? ""
    }
    
    
    
    func signOut() ->String {
        do {
            try Auth.auth().signOut()
            return "user signOut"
        } catch {
            return "DEBUG: sign out error"
        }
    }
    
    //Get all Temperature details
    func getUserById(completion: @escaping(UserDetails) -> Void) {
        
        USER_REF.child(getUserUid()).observe(DataEventType.value, with : { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let fname = value?["firstName"] as? String ?? ""
            let lname = value?["lastName"] as? String ?? ""
            let mail = value?["email"] as? String ?? ""
            let acctype = value?["accountType"] as? String ?? ""
            let pwd = value?["password"] as? String ?? ""
            let index = value?["indexNo"] as? String ?? ""
            let image = value?["imageUrl"] as? String ?? ""
                        
            let user = UserDetails(accountType:acctype as String?, email:mail as String?, firstName:fname as String?, lastName: lname as String?, password: pwd as String?, indexNo: index as String?, imageUrl: image as String?)
            
            completion(user)
        })
       

        
//        USER_REF.child(getUserUid()).observe(DataEventType.value, with : { (snapshot) in
//            guard let dictionary = snapshot.value as? [String: Any] else { return }
//            let userTemperatureDetails = temperatureModal(dictionary: dictionary)
//            let fname = dictionary?["firstName"]
//            let lname = dictionary?["lastName"]
//            let mail = dictionary?["email"]
//            let acctype = dictionary?["accountType"]
//            let pwd = dictionary?["password"]
//            let userTemperatureDetails = UserDetails(dictionary: dictionary)
//            completion(userTemperatureDetails)
//        })
        
//        var users : [UserDetails] = []
//
//        USER_REF.observe(DataEventType.value, with: { (snapshot) in
//
//            for dataSet in snapshot.children.allObjects as![DataSnapshot]{
//                let singleData = dataSet.value as? [String:AnyObject]
//
//                let fname = singleData?["firstName"]
//                let lname = singleData?["lastName"]
//                let mail = singleData?["email"]
//                let acctype = singleData?["accountType"]
//                let pwd = singleData?["password"]
//
//                let user = UserDetails(accountType:acctype as! String?, email:mail as! String?, firstName:fname as! String?, lastName: lname as! String?, password: pwd as! String?)
//
//                users.append(user)
//
//            }
//
//            completion(users)
//
//        })
    }
    
    
    
//    //Mark: Update user Temperature details
//
//    func updateUserTemperture(_ value: [String:Any] )->Int{
//            RFF_TEMPINFO.child(getUserUid()).updateChildValues(value){(error, ref) in }
//             return 0
//    }
//
//
//    //Get user Temperature details
//    func getUserTemperatureDetails(completion: @escaping(temperatureModal) -> Void) {
//        RFF_TEMPINFO.child(getUserUid()).observe(DataEventType.value, with : { (snapshot) in
//            guard let dictionary = snapshot.value as? [String: Any] else { return }
//            let userTemperatureDetails = temperatureModal(dictionary: dictionary)
//            completion(userTemperatureDetails)
//        })
//    }
    
    
//    //post notifications
//    func postNotification(_ value: [String:Any])->Int{
//
//        guard let key = REFF_NOTIFICATION.childByAutoId().key else { return 1}
//        REFF_NOTIFICATION.child(key).updateChildValues(value){(error, ref) in }
//        return 0
//    }
//
//
//
//
//    //Get all notifications
//    func getNotifications(completion: @escaping([notificationModel]) -> Void) {
//
//        allNotification.removeAll()
//
//        REFF_NOTIFICATION.observe(DataEventType.value, with: { (snapshot) in
//
//            for dataSet in snapshot.children.allObjects as![DataSnapshot]{
//                let singleData = dataSet.value as? [String:AnyObject]
//
//                let description = singleData?["description"]
//                let syncDateTime = singleData?["syncDateTime"]
//                let uid = singleData?["uid"]
//
//               let notification = notificationModel(description:description as! String?, syncDateTime:syncDateTime as! String? , uid:uid as! String?)
//                allNotification.append(notification)
//            }
//
//            completion(allNotification)
//
//        })
//
//    }
//
//
//
//
//
//
//
//    func getLastNotification(completion: @escaping([notificationModel]) -> Void) {
//
//        allNotification.removeAll()
//
//        let recentPostsQuery = (REFF_NOTIFICATION.queryLimited(toLast: 1))
//        recentPostsQuery.observe(DataEventType.value, with: { (snapshot) in
//
//            for dataSet in snapshot.children.allObjects as![DataSnapshot]{
//                let singleData = dataSet.value as? [String:AnyObject]
//
//                let description = singleData?["description"]
//                let syncDateTime = singleData?["syncDateTime"]
//                let uid = singleData?["uid"]
//
//               let notification = notificationModel(description:description as! String?, syncDateTime:syncDateTime as! String? , uid:uid as! String?)
//                allNotification.append(notification)
//            }
//
//            completion(allNotification)
//
//        })
//    }
//
//
//    func userCreation(_ value: [String:Any] )->Void{
//            REF_USERS.child(getUserUid()).updateChildValues(value){(error, ref) in }
//    }
//
//
//    func syncUserLocation(_ value: [String:Any] ) ->Void{
//        REF_USERLOCATIONS.child(getUserUid()).updateChildValues(value){(error, ref) in }
//    }
//
//
//    func getLocationUpdates(completion: @escaping([MapLocations]) -> Void) {
//        var mapLocation : [MapLocations] = []
//
//        mapLocation.removeAll()
//
//         REF_USERLOCATIONS.observe(DataEventType.value, with: { (snapshot) in
//
//             for dataSet in snapshot.children.allObjects as![DataSnapshot]{
//                 let singleData = dataSet.value as? [String:AnyObject]
//
//                 let lat = singleData?["lat"]
//                 let log = singleData?["log"]
//                 let uid = singleData?["uid"]
//                 let syncDateTime = singleData?["syncDateTime"]
//
//
//                mapLocation.append(MapLocations(lat: lat as! Double, log: log as! Double, uid: uid as! String, syncDateTime: syncDateTime as! String))
//
//             }
//
//             completion(mapLocation)
//
//         })
//
//
//        }
}
