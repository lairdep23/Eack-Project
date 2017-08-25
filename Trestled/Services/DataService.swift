//
//  DataService.swift
//  Eack-AppWireframe
//
//  Created by Evan on 7/29/17.
//  Copyright © 2017 Evan Laird. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()


class DataService {
    
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_ACTS = DB_BASE.child("activities")
    
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_ACTS: DatabaseReference {
        return _REF_ACTS
    }
    
    func createDBUser(uid: String, userData:Dictionary<String,Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    var activities = [
        Activity(user: "Mykala Conroy", title: "Let's Go Hiking!", loc: "Hollywood Hills", time: "12:00 pm", userImgName: "M-Conroy.png", mainImage: "HollywoodHike.jpg"),
        Activity(user: "Evan Laird", title: "Meet For Drinks?", loc: "Broadway Bar", time: "11:00 pm", userImgName: "EvanLaird.png", mainImage: "BroadwayBar.jpg"),
        Activity(user: "Mykala Conroy", title: "Beach Day!", loc: "Santa Monica Beach", time: "10:00 am", userImgName: "M-Conroy.png", mainImage: "SantaMonicaBeach"),
        Activity(user: "Mykala Conroy", title: "Join My Shopping Spree", loc: "Beverly Center", time: "4:00 pm", userImgName: "M-Conroy.png", mainImage: "BeverlyCenter.jpg"),
        Activity(user: "Evan Laird", title: "New Movie's Out? Who's In?", loc: "Naurt Theatre", time: "7:30 pm", userImgName: "EvanLaird.png", mainImage: "NaurtTheatre.jpg")
        
    ]
    
    
    
    
    func getActivites() -> [Activity] {
        return activities
    }
    
    func getActivity(int: Int) -> Activity {
        let activity = activities[int]
        return activity
    }
    
    private let categories = [
        Category(name: "Exercise", imageName: "exercise.png"),
        Category(name: "Chill", imageName: "chill.png"),
        Category(name: "Shopping", imageName: "shop.png"),
        Category(name: "Food/Drink", imageName: "fooddrink.png"),
        Category(name: "Sports", imageName: "sports.png"),
        Category(name: "Events", imageName: "entertain.png"),
        Category(name: "Outdoors", imageName: "outdoor.png"),
        Category(name: "All", imageName: "more.png")
    
    ]
    
    func getCategories() -> [Category] {
        return categories
    }
}
