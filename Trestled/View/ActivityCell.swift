//
//  RecomCell.swift
//  Eack-AppWireframe
//
//  Created by Evan on 7/28/17.
//  Copyright © 2017 Evan Laird. All rights reserved.
//

import UIKit
import Kingfisher
import CoreLocation

class ActivityCell: UITableViewCell {

    @IBOutlet weak var activityImage: UIImageView!
    @IBOutlet weak var activityTitle: UILabel!
    @IBOutlet weak var activityLocation: UILabel!
    @IBOutlet weak var activityUserCreated: UILabel!
    @IBOutlet weak var activityPostedDate: UILabel!
    @IBOutlet weak var activityMilesAway: UILabel!
    @IBOutlet weak var activityTime: UILabel!
    @IBOutlet weak var activityUserImage: ProfileImgView!
    
    
    func updateViews(activity: Activity, userLocation: CLLocation){
        self.activityImage.kf.setImage(with: URL(string:activity.mainImageURL))
        self.activityTitle.text = activity.title
        //self.activityTime.text = activity.time
        self.activityLocation.text = activity.location
        self.activityUserCreated.text = activity.posterName
        self.activityUserImage.kf.setImage(with: URL(string: activity.posterImgURL))
        
        if activity.distance != nil {
            let activityMilesString = String(format: "%.1f", activity.distance)
            self.activityMilesAway.text = "\(activityMilesString) miles"
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
