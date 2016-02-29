//
//  DetailViewController.swift
//  D214AppBeta
//
//  Created by Robert D. Brown on 1/13/16.
//  Copyright © 2016 Robert D. Brown. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, UIWebViewDelegate {
    var isLoggedIn: Bool!
    @IBOutlet weak var LoginICON: UIBarButtonItem!
    @IBOutlet weak var ImageOverlay: UIImageView!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var WebSiteView: UIWebView!
    var isInitialWebView = true
    var loadThisSite: SuString!
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let _ = self.detailItem {
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.secureTextEntry = true
        WebSiteView.delegate = self
        if loadThisSite != nil
        {
            splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
            self.splitViewController?.presentsWithGesture = true
            LoginICON.title = "Logged In!"
            LoginICON.tintColor = UIColor(red: 0.0, green: 255/255, blue: 0.0, alpha: 1.0)
            isLoggedIn = true
            WebSiteView.loadRequest(NSURLRequest(URL: (loadThisSite.getURL())))
           

            
            
        }
        else
        {
            if(isInitialWebView){
                splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.PrimaryHidden
                //self.navigationItem.leftBarButtonItem?.enabled = false
                self.navigationItem.leftBarButtonItem?.tintColor = UIColor.clearColor()
                splitViewController?.presentsWithGesture = false
                showLogin()
                LoginICON.title = "Not Logged In"
                LoginICON.tintColor = UIColor(red: 255/255, green: 0.0, blue: 0.0, alpha: 1.0)
            }
            
            WebSiteView.loadRequest(NSURLRequest(URL: NSURL(string: "http://ezproxy.d214.org:2048/login")!))
           
            
            
            
        }
        self.navigationController?.navigationBar.tintColor =  UIColor(red: 255/255, green: 140/255, blue: 0.0, alpha: 1.0)
        
        
        // Do any additional setup after loading the view, typically from a nib.
        //self.configureView()
        //self.splitViewController?.preferredDisplayMode = .PrimaryHidden
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func webViewDidFinishLoad(webView: UIWebView) {
        if (!isInitialWebView){
            
            let data = WebSiteView.stringByEvaluatingJavaScriptFromString("document.documentElement.outerHTML")
            
            let range = data?.rangeOfString("<title>Database Menu</title>")
            if range != nil{
                WebSiteView.alpha = 0.0
                isLoggedIn = true
                hideLogin()
                LoginICON.title = "Logged In!"
                LoginICON.tintColor = UIColor(red: 0.0, green: 255/255, blue: 0.0, alpha: 1.0)
                self.splitViewController?.presentsWithGesture = true
                
                self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 255/255, green: 140/255, blue: 0.0, alpha: 1.0)

                
                
            }
            
            if(!isLoggedIn)
            {
                var alert = UIAlertView()
                alert.title = "Login Problem"
                alert.message = "Wrong Username Or Password"
                alert.addButtonWithTitle("Try Agian!")
                alert.show()
            }
            

        }
        isInitialWebView = false
        
    }

    @IBAction func LoginINPressed(sender: AnyObject) {
        let savedUserName = usernameTextField.text!
        let savedPassword = passwordTextField.text!
        isLoggedIn = false
        if(!isLoggedIn){
            let URL: NSURL = NSURL(string: "http://ezproxy.d214.org:2048/login")!
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: URL)
            request.HTTPMethod = "POST"
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            let bodyData = "user=\(savedUserName)&pass=\(savedPassword)"
            request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
            WebSiteView.loadRequest(request)
            passwordTextField.resignFirstResponder()
            usernameTextField.resignFirstResponder()
            
           
           
        }
    }
    func hideLogin(){
        LoginButton.alpha = 0.0
        usernameTextField.alpha = 0.0
        passwordTextField.alpha = 0.0
        ImageOverlay.image = UIImage(named: "backgroundimage")
    }
    func showLogin(){
        usernameTextField.alpha = 1.0
        passwordTextField.alpha = 1.0
        LoginButton.alpha = 1.0
        ImageOverlay.image = UIImage(named: "RedLogin")
    }

}

