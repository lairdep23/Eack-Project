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

class SideMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileImage: ProfileImgView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var tableView: UITableView!
   
    
    
    let menuArray = ["Messages", "Upcoming Activities", "History", "Settings", "User Agreement and Privacy", "Support", "Logout"]
    
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
        if menuArray[indexPath.row] == "Logout" {
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                print("Successfully Signed Out")
                self.performSegue(withIdentifier: "logoutSegue", sender: nil)
                
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }
    }
    
}
