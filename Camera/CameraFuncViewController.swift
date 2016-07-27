//
//  CameraFuncViewController.swift
//  PokeSnaps
//
//  Created by Sahil Jain on 7/20/16.
//  Copyright © 2016 PokeSnaps. All rights reserved.
//

import UIKit
import Parse

class CameraFuncViewController: UIViewController {
    var photoTakingHelper: PhotoTakingHelper?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.delegate = self
    }
}

// MARK: Tab Bar Delegate

extension CameraFuncViewController: UITabBarControllerDelegate {
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if (viewController is CameraFuncViewController) {
            takePhoto()
            return false
        } else {
            return true
        }
    }
    func takePhoto() {
        // instantiate photo taking class, provide callback for when photo is selected
        photoTakingHelper = PhotoTakingHelper(viewController: self.tabBarController!) { (image: UIImage?) in
            if let image = image {
                print("received callback")
                
                let imageData = UIImageJPEGRepresentation(image, 0.8)!
                let imageFile = PFFile(name: "image.jpg", data: imageData)!
                
                let post = Post()
                post.imageFile = imageFile
                post.fromUser = PFUser.currentUser()
                post.likes = 0
                
                post.saveInBackground()
            }
        }
    }
}