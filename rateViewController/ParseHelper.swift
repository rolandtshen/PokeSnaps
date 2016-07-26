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
    
   
    static func queryPost(onComplete: (posts: [Post]) -> Void) {
        let query = PFQuery(className: "Post")
        query.whereKey("fromUser", equalTo: PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock{ results, error in
            let results = results as! [Post]
            onComplete(posts: results)
            print(results)
            print("results retrieved")
        }
        
    }
    
    static func timelineRequestForCurrentUser(completionBlock: PFQueryArrayResultBlock) {
        let followingQuery = PFQuery(className: "Post")        
        
        followingQuery.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
}
