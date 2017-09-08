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
        
        
    }
}
