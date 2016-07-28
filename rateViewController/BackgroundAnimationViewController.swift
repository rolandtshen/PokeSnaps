//
//  BackgroundAnimationViewController.swift
//  Koloda
//
//  Created by Eugene Andreyev on 7/11/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import UIKit
import Koloda
import pop
import Parse


private let numberOfCards: UInt = 5
private let frameAnimationSpringBounciness: CGFloat = 9
private let frameAnimationSpringSpeed: CGFloat = 16
private let kolodaCountOfVisibleCards = 2
private let kolodaAlphaValueSemiTransparent: CGFloat = 0.1

class BackgroundAnimationViewController: UIViewController {
    
    @IBOutlet weak var kolodaView: CustomKolodaView!
    
    var images = [UIImage]()
    var posts: [Post] = []
    
    var a: Int = 0

    var index: Int = -1

    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards
        kolodaView.delegate = self
        kolodaView.dataSource = self
        kolodaView.animator = BackgroundKolodaAnimator(koloda: kolodaView)
     


        self.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        
        ParseHelper.timelineRequestForCurrentUser { (result: [PFObject]?, error: NSError?) -> Void in
            self.posts = result as? [Post] ?? []
            for a in 0...(self.posts.count - 1) {
            self.posts[a].downloadImage { image in
                self.images.append(image!)
                if (a == 5) {
                    self.kolodaView.reloadData()
                }
                
                }
            }

        }
    
        

    }
    @IBAction func leftButtonTapped(sender: AnyObject) {
        kolodaView?.swipe(SwipeResultDirection.Left)
        ParseHelper.timelineRequestForCurrentUser { (result: [PFObject]?, error: NSError?) -> Void in
            self.posts = result as? [Post] ?? []
            let likes = Int(self.posts[self.index].likes!) - 1
            
            self.posts[self.index].likes = likes
            let post = self.posts[self.index]
            post.saveInBackground()
        }
    }
    @IBAction func rightButtonTapped(sender: AnyObject) {
        ParseHelper.timelineRequestForCurrentUser { (result: [PFObject]?, error: NSError?) -> Void in
            self.posts = result as? [Post] ?? []
            let likes = Int(self.posts[self.index].likes!) + 1
            
            self.posts[self.index].likes = likes
            let post = self.posts[self.index]
            post.saveInBackground()
        }
        kolodaView?.swipe(SwipeResultDirection.Right)
        

    }
    
    @IBAction func undoButtonTapped() {
        kolodaView?.revertAction()
    }
}

//MARK: KolodaViewDelegate
extension BackgroundAnimationViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(koloda: KolodaView) {
        kolodaView.resetCurrentCardIndex()
    }
    
    func koloda(koloda: KolodaView, didSelectCardAtIndex index: UInt) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://pokesnap.weebly.com/")!)
    }
    
    func kolodaShouldApplyAppearAnimation(koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaShouldMoveBackgroundCard(koloda: KolodaView) -> Bool {
        return false
    }
    
    func kolodaShouldTransparentizeNextCard(koloda: KolodaView) -> Bool {
        return true
    }
    
    func koloda(kolodaBackgroundCardAnimation koloda: KolodaView) -> POPPropertyAnimation? {
        let animation = POPSpringAnimation(propertyNamed: kPOPViewFrame)
        animation.springBounciness = frameAnimationSpringBounciness
        animation.springSpeed = frameAnimationSpringSpeed
        return animation
    }
}



//MARK: KolodaViewDataSource
extension BackgroundAnimationViewController: KolodaViewDataSource {
    
    
    @NSManaged var imageFile: PFFile?
    
    func kolodaNumberOfCards(koloda: KolodaView) -> UInt {
        return UInt(images.count)
    }
    
    
    func koloda(koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
        
        self.index = self.index + 1
    
        
        if (images.count > 0) {
            print(self.index)
            
            if (self.index > posts.count - 1) {
                kolodaDidResetCard(kolodaView)
                self.index = 0
            }
            return UIImageView(image: images[Int(self.index)])
            
        }
        
        return UIImageView(image: UIImage(named: "Pokesnaps" ))
    }
    
    func koloda(koloda: KolodaView, viewForCardOverlayAtIndex index: UInt) -> OverlayView? {
        
        
        return NSBundle.mainBundle().loadNibNamed("CustomOverlayView",
                                                  owner: self, options: nil)[0] as? OverlayView
    }
    func koloda(koloda: KolodaView, didSwipeCardAtIndex index: UInt, inDirection direction: SwipeResultDirection) {
      print(direction.rawValue)
        if direction.rawValue == ("Right") {
            ParseHelper.timelineRequestForCurrentUser { (result: [PFObject]?, error: NSError?) -> Void in
                self.posts = result as? [Post] ?? []
                let likes = Int(self.posts[self.index].likes!) - 1
                
                self.posts[self.index].likes = likes
                let post = self.posts[self.index]
                post.saveInBackground()
            }

        }
        
        if (direction.rawValue == ("Left")) {
            ParseHelper.timelineRequestForCurrentUser { (result: [PFObject]?, error: NSError?) -> Void in
                self.posts = result as? [Post] ?? []
                let likes = Int(self.posts[self.index].likes!) + 1
                
                self.posts[self.index].likes = likes
                let post = self.posts[self.index]
                post.saveInBackground()
            }
        }
    }
}
