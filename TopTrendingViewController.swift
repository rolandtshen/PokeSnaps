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
    
    func getTopLikes() -> NSNumber {
        let post = Post()
        let likes = post.likes?.integerValue
        let dislikes = post.dislikes?.integerValue
        return likes! - dislikes!
    }

    override func queryForTable() -> PFQuery {
        
        let query = Post.query()!
        //top posts
        if(segmentedControl.selectedSegmentIndex == 0) {
            query.limit = 50;
            query.orderByDescending("createdAt")
            query.includeKey("user")
            return query
        }
        //trending posts
        else {
            query.limit = 50;
            query.orderByDescending("createdAt")
            query.includeKey("user")
            return query
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        let post = object as! Post
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TopTrendingCell
        cell.postImage.clipsToBounds = true
        cell.usernameLabel.text = post.fromUser?.username
        cell.likesLabel.text = "\(post.likes)"
        cell.dislikesLabel.text = "\(post.likes)"
        getImage(object!, completionHandler: { (image) in
            cell.postImage.image = image
        })
        return cell
    }
    
}
    