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

    @IBAction func flagPost(sender: AnyObject) {
        showFlagActionSheetForPost()
    }
    
    var images = [UIImage]()
    var posts: [Post] = []
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    func showFlagActionSheetForPost() {
        let alertController = UIAlertController(title: nil, message: "Do you want to report this post?", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let destroyAction = UIAlertAction(title: "Report", style: .Destructive) { (action) in
            let post = Post()
            post.flag(post)
        }
        
        alertController.addAction(destroyAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards
        kolodaView.delegate = self
        kolodaView.dataSource = self
        kolodaView.animator = BackgroundKolodaAnimator(koloda: kolodaView)
        
        self.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        
        ParseHelper.timelineRequestForCurrentUser { result, error in
            self.posts = result as? [Post] ?? []
            
            for post in self.posts {
                post.downloadImage { image in
                    guard let image = image else { return }
                    
                    self.images.append(image)
                    self.kolodaView.reloadData()
                }
            }
        }
    }
    
    @IBAction func leftButtonTapped(sender: AnyObject) {
        kolodaView?.swipe(SwipeResultDirection.Left)
    }
    
    @IBAction func rightButtonTapped(sender: AnyObject) {
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
        let pokesnapURL = NSURL(string: "http://pokesnap.weebly.com")!
        UIApplication.sharedApplication().openURL(pokesnapURL)
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
        // Change type of index to Int instead of UInt
        // Who even uses UInt?
        let index = Int(index)
        
        if images.count > 0 {
            if index > posts.count - 1 {
                kolodaDidResetCard(kolodaView)
                kolodaView.reloadData()
            }
            
            return UIImageView(image: images[index])
        }
        
        // Return the placeholder
        return UIImageView(image: UIImage(named: "Pokesnaps"))
    }
    
    func koloda(koloda: KolodaView, viewForCardOverlayAtIndex index: UInt) -> OverlayView? {
        return NSBundle.mainBundle().loadNibNamed("CustomOverlayView",
                                                  owner: self, options: nil)[0] as? OverlayView
    }
    
    func koloda(koloda: KolodaView, didSwipeCardAtIndex index: UInt, inDirection direction: SwipeResultDirection) {
        // Change index to Int because literally no one uses UInt
        let index = Int(index)
        
        switch direction.rawValue {
        case "Left" :
            ParseHelper.timelineRequestForCurrentUser { result, error in
                guard result != nil else { self.posts = []; return }
                
                if let posts = result as? [Post] {
                    self.posts = posts
                    let post = posts[index]
                    
                    guard post.likes != nil else { return }
                    
                    var likes = Int(post.likes!)
                    likes -= 1
                    post.likes = likes
                    
                    post.saveInBackground()
                }
            }
            break
            
        case "Right" :
            ParseHelper.timelineRequestForCurrentUser { result, error in
                guard result != nil else { self.posts = []; return }
                
                if let posts = result as? [Post] {
                    self.posts = posts
                    let post = posts[index]
                    
                    guard post.likes != nil else { return }
                    
                    var likes = Int(post.likes!)
                    likes += 1
                    post.likes = likes
                    
                    post.saveInBackground()
                }
            }
            break
            
        default :
            print("Not a valid direction.")
            break
        }
    }
}
