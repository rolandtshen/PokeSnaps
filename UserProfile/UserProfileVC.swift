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

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var nameLbl: UILabel!
    var posts: [Post] = []
    
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
        collection.reloadData()
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "test") {
            
            let destViewController = segue.destinationViewController as! PostScroll
            
            destViewController.imageView.image = UIImage()
        }
    }
    
    
    
    func getImage(object: PFObject, completionHandler: (UIImage) -> Void) {
        let image = object as! Post
        if let picture = image.imageFile {
            picture.getDataInBackgroundWithBlock({
                (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    completionHandler(UIImage(data: imageData!)!)
                }
            })
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell =  collection.dequeueReusableCellWithReuseIdentifier("PostCellIdentifier", forIndexPath: indexPath) as? PostCell {
            
            return cell }
        else {
        return UICollectionViewCell()
    }
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(105, 105)
    }

}