//
//  PostScroll.swift
//  PokeSnaps
//
//  Created by Eric Wong on 7/21/16.
//  Copyright © 2016 PokeSnaps. All rights reserved.
//

import UIKit
import Parse

class PostScroll: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    var image: UIImage?
    
    @IBAction func backButton(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func moreAlertController(sender: AnyObject) {
        let alertController = UIAlertController()
        let  delete = UIAlertAction(title: "Delete", style: .Destructive) { (action) -> Void in
            print("Delete Button Pressed")
            
        }
        
        
        let cancel = UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in
            print("Ok Button Pressed")
        })
        
        alertController.addAction(delete)
        alertController.addAction(cancel)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
        print("completed")
        
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
        nameLabel.text = PFUser.currentUser()?.username

        
    }
    
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
}


