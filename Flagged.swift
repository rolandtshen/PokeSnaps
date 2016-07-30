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

class Flagged: PFObject, PFSubclassing {
    
    @NSManaged var fromUser: PFUser?
    @NSManaged var reportedPost: PFObject?
    
    static func parseClassName() -> String {
        return "Flagged"
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
    
    func flag(post: Post) {
        let flagged = Flagged()
        flagged.fromUser = PFUser.currentUser()
        flagged.reportedPost = post
        flagged.saveInBackground()
    }
}