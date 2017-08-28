//
//  RecomCell.swift
//  Eack-AppWireframe
//
//  Created by Evan on 7/28/17.
//  Copyright © 2017 Evan Laird. All rights reserved.
//

import UIKit
import Kingfisher

class ActivityCell: UITableViewCell {

    @IBOutlet weak var activityImage: UIImageView!
    @IBOutlet weak var activityTitle: UILabel!
    @IBOutlet weak var activityLocation: UILabel!
    @IBOutlet weak var activityUserCreated: UILabel!
    @IBOutlet weak var activityPostedDate: UILabel!
    @IBOutlet weak var activityMilesAway: UILabel!
    @IBOutlet weak var activityTime: UILabel!
    @IBOutlet weak var activityUserImage: ProfileImgView!
    
    
    func updateViews(activity: Activity){
        self.activityImage.kf.setImage(with: URL(string:activity.mainImageURL))
        self.activityTitle.text = activity.title
        self.activityTime.text = activity.time
        self.activityLocation.text = activity.location
        self.activityUserCreated.text = activity.posterName
        self.activityUserImage.kf.setImage(with: URL(string: activity.posterImgURL))
    }
    

}
