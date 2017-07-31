//
//  HomeVC.swift
//  Eack-AppWireframe
//
//  Created by Evan on 7/27/17.
//  Copyright © 2017 Evan Laird. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())

       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataService.instance.getActivites().count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell") as? ActivityCell {
            
            let activity = DataService.instance.getActivites()[indexPath.row]
            cell.updateViews(activity: activity)
        
            return cell
        }
        
        return ActivityCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as? CategoryCell {
            let category = DataService.instance.getCategories()[indexPath.item]
            cell.updateViews(category: category)
            
            return cell
        }
        
        return CategoryCell()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataService.instance.getCategories().count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let activityRow = Int(indexPath.row)
        
        performSegue(withIdentifier: "toActivityDetailVC", sender: activityRow)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let activityDetailsVC = segue.destination as? ActivityDetailVC {
            
            assert(sender as! Int != nil)
            activityDetailsVC.setupView(activityRow: sender as! Int)
        }
    }
    
    
    
    
    

}
