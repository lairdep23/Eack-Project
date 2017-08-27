//
//  postActivityVC.swift
//  Eack-AppWireframe
//
//  Created by Evan on 8/12/17.
//  Copyright © 2017 Evan Laird. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import GooglePlaces
import CoreLocation

class PostActivityVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, CLLocationManagerDelegate {
    
    //Outlets
    
    @IBOutlet weak var activityTitle: UITextField!
    @IBOutlet weak var activityLocation: UITextField!
    @IBOutlet weak var activityDesc: UITextView!
    @IBOutlet weak var activityImage: UIImageView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var timePicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var numberOfPeoplePicker: UIPickerView!
    
    @IBOutlet weak var postBtn: JoinButton!
    
    //Variables and Constants
    
    var imagePicker: UIImagePickerController!
    var placeAddress: String?
    let locationManager = CLLocationManager()
    
    let numberArray = ["1","2","3","4","5","6","7","8","9","10","∞"]
    let categoryArray = ["Exercise", "Chill", "Shopping", "Food/Drink", "Sports", "Events", "Outdoors", "Learning", "Work"]
    let timePickerArray = ["Now", "Later Today", "Tomorrow", "Far Out"]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberOfPeoplePicker.delegate = self
        numberOfPeoplePicker.dataSource = self
        timePicker.delegate = self
        timePicker.dataSource = self
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        activityDesc.delegate = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        activityLocation.delegate = self
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let loc = CLLocationCoordinate2DMake(mapView.userLocation.coordinate.latitude, mapView.userLocation.coordinate.longitude)
            let region = MKCoordinateRegionMake(loc, span)
            
            mapView.showsUserLocation = true
            mapView.centerCoordinate.latitude = mapView.userLocation.coordinate.latitude
            mapView.centerCoordinate.longitude = mapView.userLocation.coordinate.longitude
            
            mapView.setRegion(region, animated: true)
        }

        
        
        
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(PostActivityVC.endEditing))
        self.view.addGestureRecognizer(tap)

        
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == numberOfPeoplePicker {
            return numberArray.count
        } else if pickerView == categoryPicker {
            return categoryArray.count
        } else if pickerView == timePicker {
            return timePickerArray.count
        } 
        
        return 0
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == numberOfPeoplePicker {
            return numberArray[row]
        } else if pickerView == categoryPicker {
            return categoryArray[row]
        } else if pickerView == timePicker {
            return timePickerArray[row]
        }
        
        return "N/A"
    }
    
    @IBAction func postActivityPressed(_ sender: Any) {
        
        postBtn.isEnabled = false
        
        //Getting all content from fields
        
        guard let title = activityTitle.text, title != "" else {
            print("Evan: Need to enter title")
            self.postBtn.isEnabled = true
            return
        }
        
        guard let desc = activityDesc.text, title != "" else {
            print("Evan: Need to enter desc")
            self.postBtn.isEnabled = true
            return
        }
        
        guard let location = activityLocation.text, location != "" else {
            print("Evan: Need to enter location")
            self.postBtn.isEnabled = true
            return
        }
        
        guard let numberOfP: Int = Int(numberArray[numberOfPeoplePicker.selectedRow(inComponent: 0)]) else {
            print("Evan: No number of people")
            self.postBtn.isEnabled = true
            return
        }
        
        guard let image = activityImage.image, image != UIImage(named:"camera") else {
            print("Evan: Must Select an Image")
            return
        }
        
        guard let exactAddress = placeAddress, exactAddress != "" else {
            print("Evan: Must select location")
            return
        }
        
        let category: String = categoryArray[categoryPicker.selectedRow(inComponent: 0)]
        let timeCategory: String = timePickerArray[timePicker.selectedRow(inComponent: 0)]
        let exactTime: Date = datePicker.date
        
        //Date Formatting
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MMM d, h:mm a"
        
        let exactDateString = dateFormatter.string(from: exactTime)
        
        //Uploading Image to Firebase Storage
        
        if let imgData = UIImageJPEGRepresentation(image, 0.2) {
            
            let imageUID = NSUUID().uuidString
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            DataService.instance.REF_PICS.child(imageUID).putData(imgData, metadata: metaData, completion: { (metaData, error) in
                
                if error != nil {
                    print("Evan: unable to upload image \(error.debugDescription))")
                } else {
                    print("Evan: upload image successful")
                    guard let downloadURL = metaData?.downloadURL()?.absoluteString else {
                        print("Evan: couldn't get downloadURL")
                        return
                    }
                    //Sending Activity Data to Firebase
                    
                    let postData: Dictionary<String,Any> = ["posterID": USER?.uid ?? "", "title": title, "category": category , "desc": desc, "location": location, "exactLocation": exactAddress , "photoURL": downloadURL, "timeCategory": timeCategory, "exactTime": exactDateString, "numberOfPeople": numberOfP, "postDate": ServerValue.timestamp()]
                    
                    DataService.instance.uploadActivity(withActivityData: postData, uploadComplete: { (isComplete) in
                        if isComplete {
                            self.postBtn.isEnabled = true
                            self.dismiss(animated: true, completion: nil)
                        } else {
                            self.postBtn.isEnabled = true
                            print("Error uploading activity")
                        }
                    })
                    
                }
            })
        }
    }
    
    @IBAction func selectPhotoPressed(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            activityImage.image = image
        } else {
            print("Evan: Image Couldn't be selected")
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @objc func endEditing() {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == activityLocation {
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            present(autocompleteController, animated: true, completion: nil)
        }
    }
    
    
    
}


extension PostActivityVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
}

extension PostActivityVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        print("Place Lat and Long: \(place.coordinate.latitude) lat and \(place.coordinate.longitude)")
        
        activityLocation.text = place.name
        placeAddress = place.formattedAddress
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(placeAddress!) { (placemarks, error) in
            guard let placemarks = placemarks, let location = placemarks.first?.location else {
                return
            }
            
            self.mapView.centerCoordinate.latitude = location.coordinate.latitude
            self.mapView.centerCoordinate.longitude = location.coordinate.longitude
            
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let loc = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            let region = MKCoordinateRegionMake(loc, span)
            self.mapView.setRegion(region, animated: true)

        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Evan Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
