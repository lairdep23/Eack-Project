//
//  Constants.swift
//  Trestled
//
//  Created by Evan on 8/25/17.
//  Copyright © 2017 Evan Laird. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation

//Constants and Global Variables

let DB_BASE = Database.database().reference()
let FIR_STORAGE = Storage.storage().reference()
let USER = Auth.auth().currentUser
var userCLLocation: CLLocation?
let TrestledOrange = UIColor(red: 0.937, green: 0.424, blue: 0.00, alpha: 1.00)
var userRadius = 50.0

//Completion Handler

typealias CompletionHandler = (_ Success: Bool) -> ()

//Notification Service

let USER_LOCATION_UPDATED = Notification.Name("userLocationChanged")
