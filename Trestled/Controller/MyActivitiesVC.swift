//
//  MyActivitiesVC.swift
//  Trestled
//
//  Created by Evan on 9/7/17.
//  Copyright © 2017 Evan Laird. All rights reserved.
//

import UIKit

class MyActivitiesVC: UIViewController {
    
    @IBOutlet weak var menuBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)

        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    }

   

}
