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
    
    var activityRow: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if activityRow != nil {
            let activity = DataService.instance.getActivites()[activityRow!]
            
            numberToJoin.text = "2 More Can Join!"
            activityImage.image = UIImage(named: (activity.mainImage))
            activityTime.text = activity.time
            activityTitle.text = activity.title
            createdUser.text = activity.user
            activityAddress.text = activity.location
            activityLocation.text = activity.location
            userCreatedImage.image = UIImage(named: (activity.userImgName))
        }
    }
    
    func setupView(activityRow: Int){
        
        self.activityRow = activityRow
    }
    
    @IBAction func requestToJoinPressed(_ sender: Any) {
        if activityRow != nil {
            performSegue(withIdentifier: "ToMessageView", sender: activityRow)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let messageVC = segue.destination as? MessageVC {
            
            assert(sender as? Int != nil)
            messageVC.setupView(activityRow: sender as! Int)
        }
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
