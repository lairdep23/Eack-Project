//
//  Activity.swift
//  Eack-AppWireframe
//
//  Created by Evan on 7/29/17.
//  Copyright © 2017 Evan Laird. All rights reserved.
//

import Foundation

struct Activity {
    
    private(set) public var user: String
    private(set) public var title: String
    private(set) public var location: String
    private(set) public var time: String
    private(set) public var userImgName: String
    private(set) public var mainImage: String
    
    init(user: String, title: String, loc: String, time: String, userImgName: String, mainImage: String ) {
        self.user = user
        self.title = title
        self.location = loc
        self.time = time
        self.userImgName = userImgName
        self.mainImage = mainImage
    }
}
