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

class PostActivityVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Outlets
    
    @IBOutlet weak var activityTitle: UITextField!
    @IBOutlet weak var activityLocation: UITextField!
    @IBOutlet weak var activityDesc: UITextView!
    @IBOutlet weak var activityImage: UIImageView!
    
    @IBOutlet weak var locationName: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var timePicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var numberOfPeoplePicker: UIPickerView!
    
    @IBOutlet weak var postBtn: JoinButton!
    
    //Variables and Constants
    
    var imagePicker: UIImagePickerController!
    
    
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
        
        if activityTitle.text != "" {
            let date = Date()
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
            let dateString = dateFormatter.string(from: date)
            
            postBtn.isEnabled = false
            let postData: Dictionary<String,Any> = ["posterID": USER?.uid, "title": activityTitle.text!, "category": "Exercise", "desc": activityDesc.text!, "location": activityLocation.text!, "exactLocation": activityLocation.text!, "photoURL": "https://photourl.com", "time": "Later Today", "exactTime": "7:00pm", "numberOfPeople": 5, "postDate": dateString]
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
        
        
        
    }
    
    
    @IBAction func selectPhotoPressed(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @objc func endEditing() {
        view.endEditing(true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            activityImage.image = image
        } else {
            print("Evan: Image Couldn't be selected")
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    
}


extension PostActivityVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
}
