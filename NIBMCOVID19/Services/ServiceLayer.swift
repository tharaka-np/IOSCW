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
let REFF_NOTIFICATION = DB_REF.child("Notifications")
let REF_USERLOCATIONS = DB_REF.child("userCoordinates")
let REF_USERSURVEYS = DB_REF.child("survey")

var allNotification = [notification]()

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
            let image = value?["dpUrl"] as? String ?? ""
                        
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
    
    func getUserTempById(completion: @escaping(Temparature) -> Void) {
        
        REF_USERLOCATIONS.child(getUserUid()).observe(DataEventType.value, with : { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let temp = value?["temp"] as? Int ?? 30
            let date = value?["syncDateTime"] as? String ?? ""
            
                        
            let userTemp = Temparature(lastTime:date as String?, temparature:temp as Int)
            
            completion(userTemp)
        })
    }
    
    func getUserLastSurveyById(completion: @escaping(Survey) -> Void) {
        
        REF_USERSURVEYS.child(getUserUid()).observe(DataEventType.value, with : { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let date = value?["syncDateTime"] as? String ?? ""
            
                        
            let userLastSurvey = Survey(lastSurveyTime:date as String?)
            
            completion(userLastSurvey)
        })
    }
    
    func updateUserProfileImage(_ imageurl: String){
        
        let values = [
          "dpUrl":imageurl
              ]as [String : Any]
        
      
            
        let user = Auth.auth().currentUser
        guard let uid = user?.uid else { return }

        Database.database().reference().child("users").child(uid).updateChildValues(values) { (error, ref) in
            print("Successfuly updated user profile image")
        }
        
    }
    
    func updateUserDetails(_ details: [String:Any]){
        let user = Auth.auth().currentUser
        guard let uid = user?.uid else { return }

        Database.database().reference().child("users").child(uid).updateChildValues(details) { (error, ref) in
            print("Successfuly updated user info")
        }
    }
    
    //post notifications
    func addNewNotification(_ value: [String:Any])->Int{
            
        guard let key = REFF_NOTIFICATION.childByAutoId().key else { return 1}
        REFF_NOTIFICATION.child(key).updateChildValues(value){(error, ref) in }
        print("Notification added auccessfully...")
        return 0
    }
    
    func updateUserCordinates(_ details: [String:Any])->Int{
        
        let user = Auth.auth().currentUser
        guard let uid = user?.uid else { return 0}
        REF_USERLOCATIONS.child(uid).updateChildValues(details){(error, ref) in }
        print("Coordinates added auccessfully...")
        return 0
    }
    
    func updateUserTemp(_ temp: [String:Any]){
        
        let user = Auth.auth().currentUser
        guard let uid = user?.uid else { return }

        Database.database().reference().child("userCoordinates").child(uid).updateChildValues(temp) { (error, ref) in
            print("Successfuly updated user temparature")
        }
    }
    
    func fetchDataMapLocations(completion: @escaping([MapModel]) -> Void) {
        
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
                    completion(mapLocation)
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
                
                print(mapLocation)
                completion(mapLocation)
            }
        })
        
    }
    
//    func getLastNotification(completion: @escaping([notification]) -> Void) {
//
//        let recentPostsQuery = (REFF_NOTIFICATION.queryLimited(toLast: 1))
//        recentPostsQuery.observe(DataEventType.value, with: { (snapshot) in
//
//            for dataSet in snapshot.children.allObjects as![DataSnapshot]{
//                let singleData = dataSet.value as? [String:AnyObject]
//
//                let description = singleData?["description"]
//                let title = singleData?["title"]
//                let syncDateTime = singleData?["syncDateTime"]
//                let uid = singleData?["uid"]
//
//                let notific = notification(title: title as! String?, description: description as! String?, syncDateTime:syncDateTime as! String? , uid:uid as! String?)
//                allNotification.append(notific)
//            }
//
//            completion(allNotification)
//
//        })
//    }
    
    func getLastNotification(completion: @escaping([notification]) -> Void) {

            var allNotifications = [notification]()
             REFF_NOTIFICATION.observe(.childAdded , with: {
                 (snapshot) in
                   
                (REFF_NOTIFICATION.queryLimited(toLast: 1)).observeSingleEvent(of: .value, with: { snapshot in
                     allNotifications.removeAll()
                     
                     if let directory = snapshot.value as? [String: Any] {
                         for location in directory{
                             guard let singleData = location.value as? [String: Any] else {
                                 continue
                             }

                         let title = singleData["title"]
                         let description = singleData["description"]
                         let syncDateTime = singleData["syncDateTime"]
                         let uid = singleData["uid"]

                        let singleNotification = notification(title: title as! String?, description: description as! String?, syncDateTime:syncDateTime as! String? , uid:uid as! String?)
                        allNotifications.append(singleNotification)
                     
                         }
                     completion(allNotifications)
                     }
                 })
             })
                 
             (REFF_NOTIFICATION.queryLimited(toLast: 1)).observeSingleEvent(of: .value, with: { snapshot in
                 if let directory = snapshot.value as? [String: Any] {
                     for(_, val) in directory{
                         guard let singleData = val as? [String: Any] else {
                             continue
                         }
                        
                        let title = singleData["title"]
                        let description = singleData["description"]
                        let syncDateTime = singleData["syncDateTime"]
                        let uid = singleData["uid"]

                        let singleNotification = notification(title: title as! String?, description: description as! String?, syncDateTime:syncDateTime as! String? , uid:uid as! String?)
                        
                    allNotifications.append(singleNotification)
                 
                     }
                 completion(allNotifications)

                 }
             })
        }
}
