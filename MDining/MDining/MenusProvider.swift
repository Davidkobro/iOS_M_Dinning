//
//  menusprovider.swift
//  MDining
//
//  Created by Elisabeth Furr on 12/5/17.
//  Copyright © 2017 Flamango. All rights reserved.
//
import Foundation

let notificationKey1 = "com.flamango.notificationKey1"
let notificationKey2 = "com.flamango.notificationKey2"

class MenusProvider{
    
    static let shared = MenusProvider()
    
    var diningLocations = [DiningLocation]()
    var diningLocationDict = [String: [Meal]]()
    
    init() {
        // assigns dining locations pulled from the network to dining locations array
        MenusAPIManager.getDiningLocations { (diningLocationsFromAPI) in
            self.diningLocations = diningLocationsFromAPI
            // posts a notification communicating with other files that this information
            // is loaded
            NotificationCenter.default.post(name: Notification.Name(rawValue: notificationKey1), object: self)
            // assigns meals pulled from the network to value in dictionary, organized by
            // dining locations
            for location in self.diningLocations {
                MenusAPIManager.getMeals(for: location) { (mealFromAPI) in
                    self.diningLocationDict[location.name] = mealFromAPI
                    // posts a notification communication with other files that this information
                    // is loaded
                    NotificationCenter.default.post(name: Notification.Name(rawValue: notificationKey2), object: self)
                }
            }
            
        }
    }
}
