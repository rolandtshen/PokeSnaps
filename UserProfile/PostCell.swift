//
//  PostCell.swift
//  PokeSnaps
//
//  Created by Eric Wong on 7/20/16.
//  Copyright © 2016 PokeSnaps. All rights reserved.
//

import UIKit

class PostCell: UICollectionViewCell {
    
    @IBOutlet weak var likes:UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
    
    }
    
    var post: Post!
    
    
    func configureCell (post: Post) {
        self.post = post
    
    }
    

}
