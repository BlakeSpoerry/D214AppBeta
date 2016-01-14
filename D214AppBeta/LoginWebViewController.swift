//
//  ViewController.swift
//  D214AppAlpha
//
//  Created by mobileapps on 11/5/15.
//  Copyright © 2015 JohnHerseyHighSchool. All rights reserved.
//

import UIKit

class LoginWebViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var LoginWebView: UIWebView!
    var isInitialWebView = true
    var loggedIn:Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoginWebView.delegate = self
        LoginWebView.loadRequest(NSURLRequest(URL: NSURL(string: "http://ezproxy.d214.org:2048/login")!))
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "HomePage"{
            let nextPath = segue.destinationViewController as! UINavigationController
            let secondPath = nextPath.viewControllers.first as! MainTableViewController
            secondPath.savedWebView = LoginWebView
        }
        loggedIn = true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        if !isInitialWebView
        {
            let data = LoginWebView.stringByEvaluatingJavaScriptFromString("document.documentElement.outerHTML")
            let range = data?.rangeOfString("<title>Database Menu</title>")
            if range != nil{
                LoginWebView.alpha = 0.0
                performSegueWithIdentifier("HomePage", sender: LoginWebView)
            }
            
        }
        isInitialWebView = false
    }
    
    
    
}

