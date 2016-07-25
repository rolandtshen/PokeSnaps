//
//  Post.swift
//  PokeSnaps
//
//  Created by Roland Shen on 7/21/16.
//  Copyright © 2016 PokeSnaps. All rights reserved.
//

import Foundation
import ParseUI
import Parse
import Bond
import ConvenienceKit


class Post: PFObject, PFSubclassing {
    
    var image: Observable<UIImage?> = Observable(nil)
    
    @NSManaged var fromUser: PFUser?
    @NSManaged var imageFile: PFFile?
    @NSManaged var likes: NSNumber?
    
    static func parseClassName() -> String {
        return "Post"
    }
    
    override init () {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
        }
    }
    func returnImage() -> UIImage {
        return self.image.value!
    }
    
    func downloadImage(onComplete: UIImage? -> Void) {
        if (image.value == nil) {
            imageFile?.getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
                if let error = error {
                    onComplete(nil)
                }
                
                if let data = data {
                    let image = UIImage(data: data, scale:1.0)
                    self.image.value = image
                    onComplete(image)
                }
            }
        } else {
            onComplete(nil)
        }
    }
    
    
}