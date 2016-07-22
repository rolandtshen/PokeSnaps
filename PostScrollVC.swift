//
//  PostScroll.swift
//  PokeSnaps
//
//  Created by Eric Wong on 7/21/16.
//  Copyright © 2016 PokeSnaps. All rights reserved.
//

import UIKit

class PostScroll: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
    }
    
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    

}
