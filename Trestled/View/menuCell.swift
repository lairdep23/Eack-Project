//
//  menuCell.swift
//  Eack-AppWireframe
//
//  Created by Evan on 8/1/17.
//  Copyright © 2017 Evan Laird. All rights reserved.
//

import UIKit

class menuCell: UITableViewCell {
    
    @IBOutlet weak var cellTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setupView(title: String) {
        cellTitle.text = title
    }


}
