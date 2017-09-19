//
//  DataService.swift
//  Eack-AppWireframe
//
//  Created by Evan on 7/29/17.
//  Copyright © 2017 Evan Laird. All rights reserved.
//

import Foundation
import Firebase


class DataService {
    
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_ACTS = DB_BASE.child("activities")
    private var _REF_OLD_ACTS = DB_BASE.child("old-activities")
    private var _REF_ACTS_BY_CAT = DB_BASE.child("category-activities")
    private var _REF_PICS = FIR_STORAGE.child("activityPics")
    
    
    
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_ACTS: DatabaseReference {
        return _REF_ACTS
    }
    
    var REF_OLD_ACTS: DatabaseReference {
        return _REF_OLD_ACTS
    }
    
    var REF_ACTS_BY_CAT: DatabaseReference {
        return _REF_ACTS_BY_CAT
    }
    
    var REF_PICS: StorageReference {
        return _REF_PICS
    }
    
    func createDBUser(uid: String, userData:Dictionary<String,Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func uploadActivity(withActivityData data: Dictionary<String,Any>, category: String, uploadComplete: @escaping (_ status: Bool) ->()) {
        
        let key = REF_ACTS.childByAutoId().key
        let categoryData = ["ref-key": key]
        
        REF_ACTS.child(key).updateChildValues(data)
        REF_ACTS_BY_CAT.child(category).child(key).updateChildValues(categoryData)
        uploadComplete(true)
    }
    
    func moveToOldActivity(withActivityData data: Dictionary<String,Any>, key: String, uploadComplete: @escaping (_ status: Bool) -> ()) {
        REF_OLD_ACTS.child(key).updateChildValues(data)
        uploadComplete(true)
    }
    
    var activities = [Activity]()
    
    func getActivities() -> [Activity] {
        return activities
    }
    
    let categoryArray = ["Exercise", "Chill", "Shopping", "Food/Drink", "Sports", "Events", "Outdoors", "Learning", "Work"]

    
    private let categories = [
        Category(name: "All", imageName: "more.png"),
        Category(name: "Exercise", imageName: "exercise.png"),
        Category(name: "Chill", imageName: "chill.png"),
        Category(name: "Shopping", imageName: "shop.png"),
        Category(name: "Food/Drink", imageName: "fooddrink.png"),
        Category(name: "Nightlife", imageName: "nightlife"),
        Category(name: "Sports", imageName: "sports.png"),
        Category(name: "Events", imageName: "entertain.png"),
        Category(name: "Outdoors", imageName: "outdoor.png"),
        Category(name: "Learning", imageName: "learning"),
        Category(name: "Work", imageName: "work")
    ]
    
    func getCategories() -> [Category] {
        return categories
    }
    
    func showAlert(title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        
        return alertController
    }
}
