//
//  postActivityVC.swift
//  Eack-AppWireframe
//
//  Created by Evan on 8/12/17.
//  Copyright © 2017 Evan Laird. All rights reserved.
//

import UIKit
import MapKit

class PostActivityVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
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
    
    let numberArray = ["1","2","3","4","5","6","7","8","9","10","∞"]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberOfPeoplePicker.delegate = self
        numberOfPeoplePicker.dataSource = self
        
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
        return numberArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return numberArray[row]
    }
    
    @IBAction func postActivityPressed(_ sender: Any) {
        
        if activityTitle.text != "" && activityLocation.text != "" {
            dismiss(animated: true, completion: nil)
        }
        
        
        
    }
    
    
    @IBAction func selectPhotoPressed(_ sender: Any) {
        
    }
    
    @objc func endEditing() {
        view.endEditing(true)
    }
    
    
    
}
