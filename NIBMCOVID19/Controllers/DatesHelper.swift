//
//  DatesHelper.swift
//  NIBMCOVID19
//
//  Created by Tharaka Pathirana on 9/19/20.
//  Copyright © 2020 Tharaka Pathirana. All rights reserved.
//

import UIKit
 
struct DatesHelper {

        static let shared = DatesHelper()
        let formatter = DateFormatter()



        func getNowDate(_ date: Date) -> String {
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            return formatter.string(from: date)
        }
        
        
        func getAgoTime(_ date: String) -> String{
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateFrom =  formatter.date(from: date)!
            let timeIntervalInSeconds = Date().timeIntervalSince(dateFrom)
            
            let secondsInAMinute = 60;
            let secondsInAnHour  = 60 *  secondsInAMinute;
            let secondsInADay    = 24 * secondsInAnHour;

            // extract days
            let days = timeIntervalInSeconds/Double(secondsInADay)
            let hours = Int(timeIntervalInSeconds / 3600)
            let minitues = Int(timeIntervalInSeconds / Double(secondsInAMinute))
            
            
            if Int(days) > 0{
                return String(Int(days)) + " Days ago"
            }
            else if hours > 0{
                return String(hours)  + " Hours ago"
            }
            else if minitues > 0{
                return String(minitues)  + " Minutes ago"
            }
            else {return " Just now"}
            

        }
}
