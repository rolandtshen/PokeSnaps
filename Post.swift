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

class Post: PFObject, PFSubclassing {
    
    @NSManaged var fromUser: PFUser?
    @NSManaged var imageFile: PFFile?
    @NSManaged var likes: NSNumber?
    @NSManaged var dislikes: NSNumber?
    
    class func parseClassName() -> String {
        return "Post"
    }
    
    override class func initialize() {
        var onceToken: dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
        }
    }
}