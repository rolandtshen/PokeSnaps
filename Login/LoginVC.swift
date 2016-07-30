//
//  LoginVC.swift
//  PokeSnaps
//
//  Created by Eric Wong on 7/26/16.
//  Copyright © 2016 PokeSnaps. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet var loginLabel: UILabel!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBAction func goToSignUpButton(sender: UIButton) {
    }
    
    @IBAction func loginButton(sender: UIButton) {
        login()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myColor : UIColor = UIColor( red: 255, green: 0, blue:0, alpha: 1.0 )
        emailTextField.layer.borderColor = myColor.CGColor
        passwordTextField.layer.borderColor = myColor.CGColor
        // Do any additional setup after loading the view.
        if PFUser.currentUser() != nil{
            print("Logged in user already")
            print(PFUser.currentUser()?.username)
            
            self.performSegueWithIdentifier("login", sender: self)
            
        }else{
            print("No user logged in")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func login() {
        let user = PFUser()
        user.password = passwordTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        user.email = emailTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        // other fields can be set just like with PFObject
        PFUser.logInWithUsernameInBackground(user.email!, password: user.password!) {
            (user: PFUser?, error: NSError?) -> Void in
            
            guard error == nil else { self.errorHandler(); return }
            guard user != nil else { self.errorHandler(); return }
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = mainStoryboard.instantiateViewControllerWithIdentifier("MainTabBarController")
            
            self.view.window?.rootViewController = mainTabBarController
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
    func errorHandler() {
        
        let alert = UIAlertController(title: "Error", message: "Invalid username or password.", preferredStyle: UIAlertControllerStyle.Alert)
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
