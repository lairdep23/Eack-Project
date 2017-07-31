//
//  ActivityDetailVC.swift
//  Eack-AppWireframe
//
//  Created by Evan on 7/30/17.
//  Copyright © 2017 Evan Laird. All rights reserved.
//

import UIKit
import MapKit

class ActivityDetailVC: UIViewController {

    @IBOutlet weak var activityImage: UIImageView!
    
    @IBOutlet weak var activityTitle: UILabel!
    
    @IBOutlet weak var activityLocation: UILabel!
    
    @IBOutlet weak var activityTime: UILabel!
    
    @IBOutlet weak var createdUser: UILabel!
    
    @IBOutlet weak var numberToJoin: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var activityAddress: UILabel!
    
    @IBOutlet weak var userCreatedImage: ProfileImgView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    func setupView(activityRow: Int){
        let activity = DataService.instance.getActivites()[activityRow]
        
            print(activity.mainImage)
            print(activity.title)
            
            activityImage.image = UIImage(named: activity.mainImage)
            activityTime.text = activity.time
            activityTitle.text = activity.title
            createdUser.text = activity.user
            activityAddress.text = activity.location
            activityLocation.text = activity.location
            userCreatedImage.image = UIImage(named: activity.userImgName)
        
        
        
    }
    
    @IBAction func requestToJoinPressed(_ sender: Any) {
    }
    @IBAction func messagePressed(_ sender: Any) {
    }
    @IBAction func viewFacebookPressed(_ sender: Any) {
    }
    @IBAction func viewInMapsPressed(_ sender: Any) {
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    

}
