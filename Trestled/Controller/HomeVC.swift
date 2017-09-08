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
    
    //Outlet

    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableViewLabel: UILabel!
    
    
    //Tab Bar Buttons
    
    @IBOutlet weak var closestImage: UIImageView!
    @IBOutlet weak var closestText: UILabel!
    
    @IBOutlet weak var endingImage: UIImageView!
    @IBOutlet weak var endingText: UILabel!
    
    @IBOutlet weak var recentImage: UIImageView!
    @IBOutlet weak var recentText: UILabel!
    
    //Variables and Constants
    
    
    var postActivityVC: UIViewController?
    let locationManager = CLLocationManager()
    var selectedCategoryCell = IndexPath(row: 0, section: 0)
    var usersCity = "You"
    var bottomBarSelected = "Ending"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        
        //Setting Bottom Tab Bar
        
        closestImage.isHighlighted = false
        closestText.isHighlighted = false
        endingImage.isHighlighted = true
        endingText.isHighlighted = true
        recentImage.isHighlighted = false
        recentText.isHighlighted = false
        
        
        
        //LocationServices
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
        }
        
        

        //Profile photo
        
        let photoURL = USER?.photoURL
        menuBtn.kf.setImage(with: photoURL, for: .normal)
        
        //Gestures
        
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        //Loading
        
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.isHidden = false
        
        getAllFirebaseActivities { (success) in
            //Setting the "All" Category Selected in collectionView
            let index = IndexPath(row: 0, section: 0)
            self.collectionView.selectItem(at: index, animated: false, scrollPosition: .top)
            let firstSelected = self.collectionView.cellForItem(at: index)
            self.showSelectedCell(firstSelected!)
            
        }
        

       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tableView.reloadData()
    }
    
    
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    //TableView of Activities
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Evan: \(DataService.instance.getActivities().count)")
        return DataService.instance.getActivities().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell") as? ActivityCell {
            
            let activity = DataService.instance.getActivities()[indexPath.row]
            //print("Evan: \(activity.title)")
            if userCLLocation != nil {
                cell.updateViews(activity: activity, userLocation: userCLLocation!)
            } else {
                print("Evan: Couldn't find userLocation")
            }
        
            return cell
        }
        
        return ActivityCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 237
    }
    
    //CollectionView of Categories
    
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategory = DataService.instance.getCategories()[indexPath.row].name
        
        if let oldCell = collectionView.cellForItem(at: selectedCategoryCell) {
            oldCell.backgroundColor = UIColor.clear
            selectedCategoryCell =  IndexPath(row: indexPath.row, section: 0)
            if let newCell = collectionView.cellForItem(at: indexPath) {
                showSelectedCell(newCell)
            }
        }
        
        
        
        //Query the tableView on selectedCategory
        
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        
        
        if selectedCategory == "All" {
            getAllFirebaseActivities(completion: { (success) in
                
            })
            
        } else {
//            let firstIndex = IndexPath(row: 0, section: 0)
//            collectionView.cellForItem(at: firstIndex)?.backgroundColor = UIColor.clear
            let catQuery = DataService.instance.REF_ACTS.queryOrdered(byChild: "category").queryEqual(toValue: selectedCategory)
            
            catQuery.observe(.value) { (snapshot) in
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                    DataService.instance.activities.removeAll()
                    if snapshots.count != 0 {
                        for snap in snapshots {
                            if let activityDict = snap.value as? Dictionary<String,Any> {
                                let key = snap.key
                                if let posterID = activityDict["posterID"] as? String {
                                    DataService.instance.REF_USERS.child(posterID).observeSingleEvent(of: .value, with: { (snapshot) in
                                        if let posterDict = snapshot.value as? Dictionary<String,Any> {
                                            let activity = Activity(postKey: key, userLoc: userCLLocation!, postData: activityDict, posterData: posterDict)
                                            
                                            print(activity.distance)
                                            DataService.instance.activities.append(activity)
                                            self.sortDataServiceActivities()
                                            
                                            
                                        }
                                        self.activityIndicator.stopAnimating()
                                        //self.tableView.reloadData()
                                    })
                                } else {
                                    print("Couldn't get posterID")
                                }
                            } else {
                                print("Couldn't get activities")
                            }
                        }
                        
                    } else {
                        print("No Activities")
                        self.activityIndicator.stopAnimating()
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
        
        
        
        
    }
    
    func showSelectedCell(_ cell: UICollectionViewCell) {
        cell.layer.cornerRadius = 5.0
        cell.clipsToBounds = true
        cell.backgroundColor = UIColor.groupTableViewBackground
    }
    
    
    
    
    //Prepare for tableView segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let activityDetailsVC = segue.destination as? ActivityDetailVC {
            
            assert(sender as? Int != nil)
            activityDetailsVC.setupView(activityRow: sender as! Int)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let activityRow = Int(indexPath.row)
        
        performSegue(withIdentifier: "toActivityDetailVC", sender: activityRow)
    }
    
    //Get Users Location
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLoc: CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
        
        userCLLocation = CLLocation(latitude: userLoc.latitude, longitude: userLoc.longitude)
        getUsersCity(lat: userLoc.latitude, long: userLoc.longitude)
        locationManager.stopUpdatingLocation()
        
        
    }
    
    func getUsersCity(lat: CLLocationDegrees, long: CLLocationDegrees) {
        let userLoc = CLLocation(latitude: lat, longitude: long)
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(userLoc, completionHandler: { (placemarks, error) in
            guard let placemarks = placemarks else {
                return
            }
            
            if let locDict = placemarks.first?.addressDictionary {
                if let city = locDict["City"] as? String {
                    self.usersCity = city
                    self.tableViewLabel.text = "Activities Near \(self.usersCity)..."
                } else {
                    
                }
            }

        })
    }
    
    //Bottom Tab Bar Actions
    
    @IBAction func closestBtnPressed(_ sender: Any) {
        closestImage.isHighlighted = true
        closestText.isHighlighted = true
        endingImage.isHighlighted = false
        endingText.isHighlighted = false
        recentImage.isHighlighted = false
        recentText.isHighlighted = false
        
        tableViewLabel.text = "Activities Near \(usersCity)..."
        
        bottomBarSelected = "Closest"
        
        sortByClosest()
        
    }
    
    @IBAction func endingBtnPressed(_ sender: Any) {
        endingImage.isHighlighted = true
        endingText.isHighlighted = true
        recentImage.isHighlighted = false
        recentText.isHighlighted = false
        closestImage.isHighlighted = false
        closestText.isHighlighted = false
        
        tableViewLabel.text = "Activities Ending Soonest..."
        
        bottomBarSelected = "Ending"
        
        sortByEnding()
        
    }
    
    @IBAction func recentBtnPressed(_ sender: Any) {
        recentImage.isHighlighted = true
        recentText.isHighlighted = true
        closestImage.isHighlighted = false
        closestText.isHighlighted = false
        endingText.isHighlighted = false
        endingImage.isHighlighted = false
        
        tableViewLabel.text = "Recently Posted Activities..."
        
        bottomBarSelected = "Recent"
        
        sortByRecent()
        
    }
    
    @IBAction func postBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "toPostActivityVC", sender: nil)
    }
    
    
    @IBAction func searchBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "toSearchVC", sender: nil)
    }
    
    func sortByEnding() {
        
        let endingActivities: [Activity] = DataService.instance.getActivities().sorted { ($0.time < $1.time)}
        DataService.instance.activities = endingActivities
        tableView.reloadData()
        
    }
    
    func sortByClosest(){
        let closeActivities: [Activity] = DataService.instance.getActivities().sorted { ($0.distance! < $1.distance!)}
        DataService.instance.activities = closeActivities
        tableView.reloadData()
    }
    
    func sortByRecent(){
        let recentActivities: [Activity] = DataService.instance.getActivities().sorted { ($0.postDate > $1.postDate) }
        DataService.instance.activities = recentActivities
        tableView.reloadData()
        
    }
    
    func getAllFirebaseActivities(completion: @escaping CompletionHandler){
        //Firebase Listener
        
        DataService.instance.REF_ACTS.observe(.value) { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                DataService.instance.activities.removeAll()
                if snapshots.count != 0 {
                    for snap in snapshots {
                        if let activityDict = snap.value as? Dictionary<String,Any> {
                            let key = snap.key
                            if let posterID = activityDict["posterID"] as? String {
                                DataService.instance.REF_USERS.child(posterID).observeSingleEvent(of: .value, with: { (snapshot) in
                                    if let posterDict = snapshot.value as? Dictionary<String,Any> {
                                        let activity = Activity(postKey: key, userLoc: userCLLocation!, postData: activityDict, posterData: posterDict)
                                        
                                        DataService.instance.activities.append(activity)
                                        
                                        self.sortDataServiceActivities()
                                        
                                        
                                    }
                                    self.activityIndicator.stopAnimating()
                                    //self.tableView.reloadData()
                                })
                            } else {
                                print("Evan: couldn't get posterID")
                            }
                        }
                    }
                } else {
                    print("No Activities")
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                }
                completion(true)
            }
            
        }
        
    }
    
    func sortDataServiceActivities() {
        if self.bottomBarSelected == "Ending" {
            self.sortByEnding()
        } else if self.bottomBarSelected == "Recent" {
            self.sortByRecent()
        } else if self.bottomBarSelected == "Closest" {
            self.sortByClosest()
        }
    }
    
    
    
    
    
    
    
    

}
