//
//  postActivityVC.swift
//  Eack-AppWireframe
//
//  Created by Evan on 8/12/17.
//  Copyright © 2017 Evan Laird. All rights reserved.
//

import UIKit
import MapKit

class postActivityVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var activityTitle: UITextField!
    @IBOutlet weak var activityLocation: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var numberOfPeoplePicker: UIPickerView!
    
    let numberArray = ["1","2","3","4","5","6","7","8","9","10","Unlimited"]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberOfPeoplePicker.delegate = self
        numberOfPeoplePicker.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(postActivityVC.endEditing))
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
            let newActivity = Activity(user: "Evan Conroy", title: activityTitle.text!, loc: activityLocation.text!, time: "12 pm", userImgName: "EvanConroy.jpg", mainImage: "HollywoodHills.jpg")
            
            DataService.instance.activities.append(newActivity)
            dismiss(animated: true, completion: nil)
        }
        
        
        
    }
    
    @objc func endEditing() {
        view.endEditing(true)
    }
    
    
    
}
