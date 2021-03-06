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

class ActivityDetailVC: UIViewController, MKMapViewDelegate {

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
    //var activity: Activity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        if activityRow != nil {
            let activity = DataService.instance.getActivities()[activityRow!]

            numberToJoin.text = "\(activity.numberOfP!) More Can Join!"
            activityImage.kf.setImage(with: URL(string: activity.mainImageURL))
            activityTitle.text = activity.title
            createdUser.text = activity.posterName
            activityAddress.text = activity.location
            activityLocation.text = activity.location
            userCreatedImage.kf.setImage(with: URL(string: activity.posterImgURL))
            activityDesc.text = activity.description
            
            if let activityInterval = Double(activity.time) as? TimeInterval {
                let activityDate = Date(timeIntervalSince1970: activityInterval)
                let dateFormatter: DateFormatter = DateFormatter()
                dateFormatter.dateFormat = "E, MMM d, h:mm a"
                
                let exactActivityDateString = dateFormatter.string(from: activityDate)
                self.activityTime.text = exactActivityDateString
                
            }
            
            if let postInterval = Double(activity.postDate) as? TimeInterval {
                let postedDate = Date(timeIntervalSince1970: postInterval/1000)
                let dateFormatter: DateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM d, h:mm a"
                let exactDateString = "\(dateFormatter.string(from: postedDate))"
                
                self.postedDate.text = exactDateString
            }
            
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(activity.exactLocation) { (placemarks, error) in
                guard let placemarks = placemarks, let location = placemarks.first?.location else {
                    return
                }
                //update mapView
                let span = MKCoordinateSpanMake(0.1, 0.1)
                let loc = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
                let region = MKCoordinateRegionMake(loc, span)
                let circle = MKCircle(center: loc, radius: 4000)
                
                self.mapView.setRegion(region, animated: true)
                self.mapView.showsUserLocation = true
                self.mapView.add(circle)
                
                
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
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleView = MKCircleRenderer(overlay: overlay)
        circleView.fillColor = UIColor.orange.withAlphaComponent(0.4)
        return circleView
    }
    
    
    
    @IBAction func requestToJoinPressed(_ sender: Any) {
        if activityRow != nil {
            let activity = DataService.instance.getActivities()[activityRow!]
            print(activity.postKey)
            
            //performSegue(withIdentifier: "ToMessageView", sender: activityRow)
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
