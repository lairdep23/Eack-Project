//
//  MessageVC.swift
//  Eack-AppWireframe
//
//  Created by Evan on 8/9/17.
//  Copyright © 2017 Evan Laird. All rights reserved.
//

import UIKit

class MessageVC: UIViewController {

    @IBOutlet weak var UserMessaging: UILabel!
    @IBOutlet weak var UserMessagingImage: ProfileImgView!
    @IBOutlet weak var YourRequestText: UILabel!
    @IBOutlet weak var acceptedRequestText: UILabel!
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet weak var messageView: UIView!
    
    
    var activityIndex = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.bindToKeyboard()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(MessageVC.endEditing))
        self.view.addGestureRecognizer(tap)

        let activity = DataService.instance.getActivities()[activityIndex]
        print(activity.posterID)
        
        UserMessaging.text = activity.posterID
        //UserMessagingImage.image = UIImage(named: activity.posterImageURL)
        YourRequestText.text = "You've requested to join \(activity.posterID) at \(activity.location) at \(activity.time) and awaiting a response"
        acceptedRequestText.text = "\(activity.posterID) has accepted your join request!"

    }

    @IBAction func sendMessageTapped(_ sender: Any) {
    }
    
    func setupView(activityRow: Int){
        
        activityIndex = activityRow
    }
    
    @objc func endEditing() {
        view.endEditing(true)
    }
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    

}
