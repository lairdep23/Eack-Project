//
//  MessageView.swift
//  Eack-AppWireframe
//
//  Created by Evan on 8/9/17.
//  Copyright © 2017 Evan Laird. All rights reserved.
//

import UIKit

@IBDesignable
class MessageView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupView()
    }
    
    func setupView(scale: Bool = true) {
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 5.0
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 2)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 2
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

}
