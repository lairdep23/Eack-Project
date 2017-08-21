//
//  ShareButton.swift
//  Eack-AppWireframe
//
//  Created by Evan on 8/21/17.
//  Copyright © 2017 Evan Laird. All rights reserved.
//

import UIKit

@IBDesignable
class ShareButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupView()
    }
    
    func setupView(scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
    }

}
