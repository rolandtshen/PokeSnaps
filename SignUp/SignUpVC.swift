//
//  SignUpVC.swift
//  PokeSnaps
//
//  Created by Eric Wong on 7/26/16.
//  Copyright © 2016 PokeSnaps. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var loginLabel: UILabel!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextfield: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBAction func signUpButton(sender: UIButton) {
        signUp()
        
    }
    
    
    @IBAction func goToLoginButton(sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func signUp() {
        let user = PFUser()
        let username = nameTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        user.username = username
        user.password = passwordTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        user.email = emailTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        // other fields can be set just like with PFObject
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            
            if user.username != "" || user.password != "" || user.email != "" {
                
                
                if let error = error {
                    
                    
                    
                    let errorString = error.userInfo["error"] as? NSString
                    // Show the errorString somewhere and let the user try again.
                    print(errorString ?? "unknown error")
                    self.errorHandler()
                } else {
                    // Hooray! Let them use the app now.
                    print("signup success")
                    self.performSegueWithIdentifier("signUp", sender: self)
                }
            }
        }
        
    }
    
    func errorHandler() {
        
        let alert = UIAlertController(title: "Error", message: "Something went wrong. Check input and try again.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(
            
            UIAlertAction(
                
                title: "OK", style: UIAlertActionStyle.Default, handler:{
                    
                    (UIAlertAction) in
                    
                    print("ok")
                    
                    
                }
            )
        )
        
        self.presentViewController(alert, animated: true, completion: {
        })
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}
