//
//  TopTrendingViewController.swift
//  PokeSnaps
//
//  Created by Roland Shen on 7/20/16.
//  Copyright © 2016 PokeSnaps. All rights reserved.
//

import Foundation
import UIKit
import ParseUI
import Parse

class TopTrendingViewController: PFQueryTableViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        self.loadObjects()
        tableView.reloadData()
        
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.separatorInset = UIEdgeInsetsZero
    }
    
    func getImage(object: PFObject, completionHandler: (UIImage) -> Void) {
        let question = object as! Post
        if let picture = question.imageFile {
            picture.getDataInBackgroundWithBlock({
                (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    completionHandler(UIImage(data: imageData!)!)
                }
            })
        }
    }

    override func queryForTable() -> PFQuery {
        let query = Post.query()!
        //top posts
        if(segmentedControl.selectedSegmentIndex == 0) {
            query.limit = 50;
            query.orderByDescending("likes")
            query.includeKey("user")
        }
        //trending posts
        else if(segmentedControl.selectedSegmentIndex == 1){
            let date = NSDate(timeIntervalSinceNow: -86400)
            query.whereKey("createdAt", greaterThan: date)
            query.orderByDescending("likes")
        }
        query.includeKey("fromUser")
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        let post = object as! Post
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TopTrendingCell
        cell.postImage.clipsToBounds = true
        cell.usernameLabel.text = post.fromUser?.username
        cell.likesLabel.text = post.likes?.stringValue
        getImage(object!, completionHandler: { (image) in
            cell.postImage.image = image
        })
        return cell
    }
    
    @IBAction func flagPressed(sender: AnyObject) {
        
    }

    @IBAction func segmentedControlChanged(sender: AnyObject) {
        tableView.reloadData()
        self.loadObjects()
        self.queryForTable()
    }
}
    