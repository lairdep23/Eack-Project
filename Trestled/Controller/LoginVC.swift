//
//  LoginVC.swift
//  Trestled
//
//  Created by Evan on 8/25/17.
//  Copyright © 2017 Evan Laird. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit


class LoginVC: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = true
    

    }

    @IBAction func facebookPressed(_ sender: Any) {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                
                let profPhoto = user?.photoURL?.absoluteString
                let userData = ["provider": "Facebook", "email": user?.email, "profile_photo": profPhoto, "name": user?.displayName] as [String : Any]
                
                DataService.instance.createDBUser(uid: (user?.uid)!, userData: userData)
                
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.dismiss(animated: true, completion: nil)
                
                
            })
            
        }
    }
}
