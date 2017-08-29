//
//  ActivityDetailVC.swift
//  Eack-AppWireframe
//
//  Created by Evan on 7/30/17.
//  Copyright © 2017 Evan Laird. All rights reserved.
//

import UIKit
import MapKit
import Kingfisher
import CoreLocation

class ActivityDetailVC: UIViewController {

    @IBOutlet weak var activityImage: UIImageView!
    
    @IBOutlet weak var activityTitle: UILabel!
    
    @IBOutlet weak var activityLocation: UILabel!
    
    @IBOutlet weak var activityTime: UILabel!
    
    @IBOutlet weak var activityDesc: UILabel!
    
    @IBOutlet weak var postedDate: UILabel!
    
    @IBOutlet weak var createdUser: UILabel!
    
    @IBOutlet weak var numberToJoin: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var activityAddress: UILabel!
    
    @IBOutlet weak var milesAway: UILabel!
    
    @IBOutlet weak var userCreatedImage: ProfileImgView!
    
    var activityRow: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if activityRow != nil {
            let activity = DataService.instance.getActivities()[activityRow!]

            numberToJoin.text = "\(activity.numberOfP!) More Can Join!"
            activityImage.kf.setImage(with: URL(string: activity.mainImageURL))
            activityTime.text = activity.time
            activityTitle.text = activity.title
            createdUser.text = activity.posterName
            activityAddress.text = activity.location
            activityLocation.text = activity.location
            userCreatedImage.kf.setImage(with: URL(string: activity.posterImgURL))
            activityDesc.text = activity.description
            
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(activity.exactLocation) { (placemarks, error) in
                guard let placemarks = placemarks, let location = placemarks.first?.location else {
                    return
                }
                //update mapView
                let span = MKCoordinateSpanMake(0.1, 0.1)
                let loc = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
                let region = MKCoordinateRegionMake(loc, span)
                
                self.mapView.setRegion(region, animated: true)
                self.mapView.showsUserLocation = true
                
                //update miles away label
                
                let activityLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                if userCLLocation != nil {
                    let distanceToActivityMeters = userCLLocation?.distance(from: activityLocation)
                    
                    if distanceToActivityMeters! <= 1609.0 {
                        //under a mile
                        self.milesAway.text = "< 1 mile"
                    } else {
                        let distanceInMiles = distanceToActivityMeters! * 0.000621371
                        let distanceString = String(format: "%.1f", distanceInMiles)
                        self.milesAway.text = "\(distanceString) miles"
                    }
                } else {
                    print("Evan: Need to turn on location")
                }
                
            }
            
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
