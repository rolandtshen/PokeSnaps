//
//  ParseHelper.swift
//  Makestagram
//
//  Created by Tomas Calemczuk on 6/29/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation
import Parse

// 1
class ParseHelper {
    
   

    
    static func timelineRequestForCurrentUser(completionBlock: PFQueryArrayResultBlock) {
        let followingQuery = PFQuery(className: "Post")        
        
        followingQuery.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
}
