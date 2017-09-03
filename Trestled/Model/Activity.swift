//
//  Activity.swift
//  Eack-AppWireframe
//
//  Created by Evan on 7/29/17.
//  Copyright © 2017 Evan Laird. All rights reserved.
//

import Foundation
import CoreLocation

class Activity {
    
    private(set) public var posterID: String!
    private(set) public var title: String!
    private(set) public var description: String!
    private(set) public var location: String!
    private(set) public var exactLocation: String!
    private(set) public var time: Int!
    private(set) public var posterImgURL: String!
    private(set) public var posterName: String!
    private(set) public var mainImageURL: String!
    private(set) public var numberOfP: Int!
    private(set) public var postDate: Int!
    private(set) public var category: String!
    
    private(set) public var postKey: String!
    
    private(set) public var distance: Double!
    
    
    
    init(postKey: String, postData: Dictionary<String,Any>, posterData: Dictionary<String,Any>) {
        self.postKey = postKey
        
        if let posterID = postData["posterID"] as? String {
            self.posterID = posterID
        }
        
        if let title = postData["title"] as? String {
            self.title = title
        }
        
        if let desc = postData["desc"] as? String {
            self.description = desc
        }
        
        if let loc = postData["location"] as? String {
            self.location = loc
        }
        
        if let exactLoc = postData["exactLocation"] as? String {
            self.exactLocation = exactLoc
            
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(exactLoc) { (placemarks, error) in
                if error == nil {
                    if let placemark = placemarks?.first {
                        guard let activityLong = placemark.location?.coordinate.longitude else {return}
                        guard let activityLat = placemark.location?.coordinate.latitude else {return}
                        let activityLocation = CLLocation(latitude: activityLat, longitude: activityLong)
                        
                        if userCLLocation != nil {
                            let distanceToActivityMeters = userCLLocation?.distance(from: activityLocation)
                            let distanceInMiles: Double = distanceToActivityMeters! * 0.000621371
                        
                            self.distance = distanceInMiles
                        }
                    }
                } else {
                    print("Evan: Couldn't get address to a Lat and Long")
                }
            }
        }
        
        if let time = postData["exactTime"] as? Int {
            self.time = time
        }
        
        if let imageURL = postData["photoURL"] as? String {
            self.mainImageURL = imageURL
        }
        
        if let numberOfP = postData["numberOfPeople"] as? Int {
            self.numberOfP = numberOfP
        }
        
        if let category = postData["category"] as? String {
            self.category = category
        }
        
        if let postDate = postData["postDate"] as? Int {
            self.postDate = postDate
        }
        
        if let posterImage = posterData["profile_photo"] as? String {
            self.posterImgURL = posterImage
        }
        
        if let posterName = posterData["name"] as? String {
            self.posterName = posterName
        }
        
    }
}
