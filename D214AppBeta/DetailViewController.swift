//
//  DetailViewController.swift
//  D214AppBeta
//
//  Created by Robert D. Brown on 1/13/16.
//  Copyright © 2016 Robert D. Brown. All rights reserved.
//

import UIKit
import WebKit

import SystemConfiguration

class DetailViewController: UIViewController, UIWebViewDelegate {
    var isLoggedIn: Bool!
    @IBOutlet weak var LogoutButton: UIBarButtonItem!
    @IBOutlet weak var ImageOverlay: UIImageView!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var WebSiteView: UIWebView!
    var isInitialWebView = true
    var loadThisSite: SuString!
    var savedSplitButton: UIBarButtonItem!
    var savedLoginInfo: [String]!
    
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
        
        self.checkConnection()
        if loadThisSite != nil
        {
            
            self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.Automatic
            self.splitViewController?.presentsWithGesture = true
            LogoutButton.title = "Logged In!"
            LogoutButton.tintColor = UIColor(red: 0.0, green: 255/255, blue: 0.0, alpha: 1.0)
            isLoggedIn = true
            WebSiteView.loadRequest(NSURLRequest(URL: (loadThisSite.getURL())))
           

            
            
        }
        else
        {
            
            if(isInitialWebView){
                savedSplitButton = self.navigationItem.leftBarButtonItem
                splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.PrimaryHidden
                
                showLogin()
                
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
                LogoutButton.title = "Logged In!"
                LogoutButton.enabled = true
                LogoutButton.tintColor = UIColor(red: 0.0, green: 255/255, blue: 0.0, alpha: 1.0)
                self.splitViewController?.presentsWithGesture = true
                self.navigationItem.leftBarButtonItem = savedSplitButton
                //savedLoginInfo.append(usernameTextField.text!)
                //savedLoginInfo.append(passwordTextField.text!)
                hideLogin()
                self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 255/255, green: 140/255, blue: 0.0, alpha: 1.0)
                usernameTextField.text = ""
                passwordTextField.text = ""
                
                
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
        
        self.checkConnection()

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
        self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.Automatic
    }
    func showLogin(){
        usernameTextField.alpha = 1.0
        passwordTextField.alpha = 1.0
        LoginButton.alpha = 1.0
        ImageOverlay.image = UIImage(named: "RedLogin")
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.leftBarButtonItem?.enabled = false
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.clearColor()
        splitViewController?.presentsWithGesture = false
        LogoutButton.title = "Not Logged In"
        LogoutButton.enabled = false
        LogoutButton.tintColor = UIColor(red: 255/255, green: 0.0, blue: 0.0, alpha: 1.0)
        splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.PrimaryHidden

    }

    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    func checkConnection(){
        if(DetailViewController.isConnectedToNetwork() == false){
            var alert = UIAlertView()
            alert.title = "Network Error"
            alert.message = "Not Connected to Wifi or has been Disconnected"
            alert.addButtonWithTitle("Please Recconnect and Retry")
            alert.show()
            
        }

    }
    @IBAction func LogoutPressed(sender: AnyObject) {
        if(isLoggedIn == true){
        let alertController = UIAlertController(title: "Logout?", message: "Are you sure you want to logout?", preferredStyle: .Alert)
        
        let logoutAction = UIAlertAction(title: "Yes", style: .Cancel) { (action) in
            self.WebSiteView.loadRequest(NSURLRequest (URL: NSURL(string: "http://ezproxy.d214.org:2048/logout")!))
            self.isInitialWebView = true
            
            self.showLogin()
            
            
            
            
        }
        alertController.addAction(logoutAction)
        
        let cancelAction = UIAlertAction(title: "No", style: .Destructive) { (action) in
            
        }
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true) {
            
        }
        
        }
    }
    

}

