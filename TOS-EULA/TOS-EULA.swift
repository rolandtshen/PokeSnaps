//
//  TOS-EULA.swift
//  PokeSnaps
//
//  Created by Eric Wong on 7/26/16.
//  Copyright © 2016 PokeSnaps. All rights reserved.
//

import UIKit

class TermsAndConditions: UIViewController {
    
    
    @IBOutlet weak var eulaWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL (string: "pokesnap.weebly.com/terms-and-conditions.html");
        let requestObj = NSURLRequest(URL: url!);
        eulaWebView.loadRequest(requestObj);
    }
}