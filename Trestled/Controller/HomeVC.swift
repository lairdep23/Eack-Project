//
//  HomeVC.swift
//  Eack-AppWireframe
//
//  Created by Evan on 7/27/17.
//  Copyright © 2017 Evan Laird. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate {

    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //Tab Bar Buttons
    
    @IBOutlet weak var closestButton: UIButton!
    @IBOutlet weak var closestImage: UIImageView!
    @IBOutlet weak var closestText: UILabel!
    
    
    var postActivityVC: UIViewController?
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        let photoURL = USER?.photoURL
        menuBtn.kf.setImage(with: photoURL, for: .normal)
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(HomeVC.handleTap))
//        self.view.addGestureRecognizer(tap)
        
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.isHidden = false
        
        //Firebase Listener
        
        DataService.instance.REF_ACTS.observe(.value) { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                DataService.instance.activities.removeAll()
                for snap in snapshots {
                    if let activityDict = snap.value as? Dictionary<String,Any> {
                        let key = snap.key
                        if let posterID = activityDict["posterID"] as? String {
                            DataService.instance.REF_USERS.child(posterID).observeSingleEvent(of: .value, with: { (snapshot) in
                                if let posterDict = snapshot.value as? Dictionary<String,Any> {
                                    let activity = Activity(postKey: key, postData: activityDict, posterData: posterDict)
                                    print("Evan: \(activity.posterName)")
                                    DataService.instance.activities.append(activity)
                                    
                                }
                                self.activityIndicator.stopAnimating()
                                self.tableView.reloadData()
                            })
                        } else {
                            print("Evan: couldn't get posterID")
                        }
                    }
                }
            }
        }

       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tableView.reloadData()
    }
    
    
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataService.instance.getActivities().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell") as? ActivityCell {
            
            let activity = DataService.instance.getActivities()[indexPath.row]
            print("Evan: \(activity.title)")
            cell.updateViews(activity: activity)
        
            return cell
        }
        
        return ActivityCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as? CategoryCell {
            let category = DataService.instance.getCategories()[indexPath.item]
            cell.updateViews(category: category)
            
            return cell
        }
        
        return CategoryCell()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataService.instance.getCategories().count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let activityRow = Int(indexPath.row)
        
        performSegue(withIdentifier: "toActivityDetailVC", sender: activityRow)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let activityDetailsVC = segue.destination as? ActivityDetailVC {
            
            assert(sender as? Int != nil)
            activityDetailsVC.setupView(activityRow: sender as! Int)
        }
    }
    
    //Get Users Location
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLoc: CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
        print("User location = \(userLoc.latitude) and \(userLoc.longitude)")
    }
    
    @IBAction func closestBtnPressed(_ sender: Any) {
        closestImage.isHighlighted = true
        closestText.isHighlighted = true
    }
    
    
    
    
    
    
    
    
    
    

}
