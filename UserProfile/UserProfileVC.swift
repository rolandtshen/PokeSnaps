//
//  ViewController.swift
//  PokeSnaps
//
//  Created by Eric Wong on 7/20/16.
//  Copyright © 2016 PokeSnaps. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ViewController: UIViewController {
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var nameLbl: UILabel!
    var posts: [Post] = []
    var image: UIImage?
    var image1: UIImage?
    
    
    @IBAction func logOutButton(sender: AnyObject) {
        let alert = UIAlertController(title: "Log Out", message: "Do you want to log out?", preferredStyle: .Alert)
        let yesAction = UIAlertAction(title: "Yes", style: .Default) { (UIAlertAction) in
            PFUser.logOut()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                PFUser.logOutInBackground(self.performSegueWithIdentifier("logout", sender: self))
                
            })
            
        }
        
        let noAction = UIAlertAction(title: "No", style: .Default) { (UIAlertAction) in
            print("Does not log out")
        }
        alert.addAction(yesAction)
        alert.addAction(noAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        collection.delegate = self
        collection.dataSource = self
        
        nameLbl.text = PFUser.currentUser()?.username
        
        ParseHelper.postQuery { posts in
            self.posts = posts
            self.collection.reloadData()
        }
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        print(segue.identifier)
//        
//        if segue.identifier == "test" {
//            let destViewController = segue.destinationViewController as! PostScroll
//            
//            let selectedIndicies = collection.indexPathsForSelectedItems()!
//            print(selectedIndicies)
//            let indexPath : NSIndexPath = selectedIndicies[0] as NSIndexPath
//            let cell = self.collection.cellForItemAtIndexPath(indexPath)
//            
//            
////            destViewController.imageView.image =  posts[0].image.value
//        }
//    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PostCellIdentifier", forIndexPath: indexPath) as? PostCell
        //sets the post to be used as the object in the post array with the index of indexPath.item
        
        if posts.count > 0 {
            let post = posts[indexPath.item]
            //sets the image of the cell to be the image of the post's image
            //I don't have the post class so just set 'imageFile' to be what ever the image property is called in the post class
            
            post.downloadImage { image in
                guard let image = image else { print("NO IMAGE"); return }
                cell?.imageView.image = image
                self.image1 = cell?.imageView.image
            }
        cell!.likes.text = ("\(post.likes)")
            
        }
        return cell!
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // print("cell tapped \(indexPath.row)")
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PostCell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
        // return posts.count > 0 ? posts.count / collectionView.numberOfSections() : 0
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(105, 125)
    }
}
