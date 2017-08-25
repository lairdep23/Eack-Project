//
//  RecomCell.swift
//  Eack-AppWireframe
//
//  Created by Evan on 7/28/17.
//  Copyright © 2017 Evan Laird. All rights reserved.
//

import UIKit

class ActivityCell: UITableViewCell {

    @IBOutlet weak var activityImage: UIImageView!
    
    @IBOutlet weak var activityTitle: UILabel!
    
    @IBOutlet weak var activityLocation: UILabel!
    
    @IBOutlet weak var activityUserCreated: UILabel!
    
    @IBOutlet weak var activityTime: UILabel!
    
    @IBOutlet weak var activityUserImage: ProfileImgView!
    
    
    func updateViews(activity: Activity){
        activityImage.image = UIImage(named: activity.mainImage)
        activityTitle.text = activity.title
        activityTime.text = activity.time
        activityLocation.text = activity.location
        activityUserImage.image = UIImage(named: activity.userImgName)
        activityUserCreated.text = activity.user
    }
    

}
