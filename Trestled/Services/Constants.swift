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

//Completion Handler

typealias CompletionHandler = (_ Success: Bool) -> ()
