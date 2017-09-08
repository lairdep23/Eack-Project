//
//  ProfileActivityCell.swift
//  Trestled
//
//  Created by Evan on 9/8/17.
//  Copyright © 2017 Evan Laird. All rights reserved.
//

import UIKit
import Kingfisher
import CoreLocation

class ProfileActivityCell: UITableViewCell {
    
    @IBOutlet weak var activityTitle: UILabel!
    @IBOutlet weak var activityTime: UILabel!
    @IBOutlet weak var activityDistance: UILabel!
    @IBOutlet weak var activityLocation: UILabel!
    @IBOutlet weak var activityPostedDate: UILabel!
    
    func updateViews(activity: Activity, userLocation: CLLocation) {
        activityTitle.text = activity.title
        
        if activity.distance != nil {
            let activityMilesString = String(format: "%.1f", activity.distance)
            self.activityDistance.text = "\(activityMilesString) miles"
        }
        
        
        
        //Turning timestamp to PostDate
        
        if let postInterval = Double(activity.postDate) as? TimeInterval {
            let postedDate = Date(timeIntervalSince1970: postInterval/1000)
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, h:mm a"
            let exactDateString = "\(dateFormatter.string(from: postedDate))"
            
            self.activityPostedDate.text = exactDateString
        }
        
        if let activityInterval = Double(activity.time) as? TimeInterval {
            let activityDate = Date(timeIntervalSince1970: activityInterval)
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E, MMM d, h:mm a"
            
            let exactActivityDateString = dateFormatter.string(from: activityDate)
            self.activityTime.text = exactActivityDateString
            
        }
        
        
    }
}
