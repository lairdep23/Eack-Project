//
//  SideMenuVC.swift
//  Eack-AppWireframe
//
//  Created by Evan on 7/27/17.
//  Copyright © 2017 Evan Laird. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import Kingfisher
import Social

class SideMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileImage: ProfileImgView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var tableView: UITableView!
   
    
    
    let menuArray = ["Home", "Profile", "Messages", "My Activities", "Settings", "User Agreement and Privacy",  "Logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        username.text = USER?.displayName
        let photoURL = USER?.photoURL
        profileImage.kf.setImage(with: photoURL)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as? menuCell {
            let title = menuArray[indexPath.row]
            cell.setupView(title: title)
            
            return cell
        }
        return menuCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = menuArray[indexPath.row]
        if selected == "Logout" {
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                print("Successfully Signed Out")
                self.performSegue(withIdentifier: "logoutSegue", sender: nil)
                
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        } else if selected == "Profile" {
            self.performSegue(withIdentifier: "toProfileVC", sender: nil)
        } else if selected == "My Activities" {
            self.performSegue(withIdentifier: "toMyActivitiesVC", sender: nil)
        } else if selected == "Messages" {
            self.performSegue(withIdentifier: "toMessagesVC", sender: nil)
        } else if selected == "Settings" {
            self.performSegue(withIdentifier: "toSettingsVC", sender: nil)
        } else if selected == "User Agreement and Privacy" {
            self.performSegue(withIdentifier: "toPolicyVC", sender: nil)
        } else {
            self.performSegue(withIdentifier: "toHomeVC", sender: nil)
        }
    }
    
    @IBAction func postToFB(_ sender: UIButton!) {
        let post = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        post?.add(#imageLiteral(resourceName: "TrestledLogo"))
        post?.setInitialText("Join me on Trestled and meet new friends with fun activities!")
        self.present(post!, animated: true, completion: nil)
    }
    
    @IBAction func postToTwitter(_ sender: UIButton!) {
        let post = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        post?.add(#imageLiteral(resourceName: "TrestledLogo"))
        post?.setInitialText("Join me on Trestled and meet new friends with fun activities!")
        self.present(post!, animated: true, completion: nil)
    }
    
}
