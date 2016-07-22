//
//  Post.swift
//  PokeSnaps
//
//  Created by Eric Wong on 7/20/16.
//  Copyright © 2016 PokeSnaps. All rights reserved.
//

import Foundation

class Post {
    private var postName: String!
    private var postLikes: String!
    private var postDislikes: String!
    
    var name: String {
        return postName
    }
    
    var likes: String {
        return postLikes
    }
    
    var dislikes: String {
        return postDislikes
    }

    init(name:String, likes: String, dislikes: String) {
        self.postName = name
        self.postLikes = likes
        self.postDislikes = dislikes
        
    }


}
