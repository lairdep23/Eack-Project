//
//  Category.swift
//  Eack-AppWireframe
//
//  Created by Evan on 7/29/17.
//  Copyright © 2017 Evan Laird. All rights reserved.
//

import Foundation

struct Category {
    
    private(set) public var name: String
    private(set) public var imageName: String
    
    init(name: String, imageName: String) {
        self.imageName = imageName
        self.name = name
    }
}
