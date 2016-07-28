//
//  CustomOverlayView.swift
//  Koloda
//
//  Created by Eugene Andreyev on 7/27/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import UIKit
import Koloda

private let overlayRightImageName = "overlay_like"
private let overlayLeftImageName = "overlay_skip"

class CustomOverlayView: OverlayView {
    
    @IBOutlet lazy var overlayImageView: UIImageView! = {
        [unowned self] in
        
        var imageView = UIImageView(frame: self.bounds)
        self.addSubview(imageView)
        print("Was here")
        return imageView
        }()
    
    override var overlayState: SwipeResultDirection?  {
        didSet {
            switch overlayState {
            case .Left? :
                print("Was here")
                overlayImageView.image = UIImage(named: overlayLeftImageName)
            case .Right? :
                print("Was here")
                overlayImageView.image = UIImage(named: overlayRightImageName)
            default:
                print("Was here")

                overlayImageView.image = nil
            }
            
        }
    }
    
}
