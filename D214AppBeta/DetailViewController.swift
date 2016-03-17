//
//  DetailViewController.swift
//  D214AppBeta
//
//  Created by Robert D. Brown on 1/13/16.
//  Copyright © 2016 Robert D. Brown. All rights reserved.
//

import UIKit
import WebKit
import CoreData


import SystemConfiguration

class DetailViewController: UIViewController, UIWebViewDelegate, UITextFieldDelegate {
    var isLoggedIn: Bool!
    @IBOutlet weak var LogoutButton: UIBarButtonItem!
    @IBOutlet weak var HelpButton: UIBarButtonItem!
    @IBOutlet weak var ImageOverlay: UIImageView!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var WebSiteView: UIWebView!
    var isInitialWebView = true
    var loadThisSite: SuString!
    var savedSplitButton: UIBarButtonItem!
    var savedLoginInfo: [String]!
    var AutoLogin = false
    
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
            LogoutButton.title = "Logout?"
            LogoutButton.tintColor = UIColor(red: 255/255, green: 140/255, blue: 0.0, alpha: 1.0)
            ImageOverlay.alpha = 0.0
        
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
    func webViewDidStartLoad(webView: UIWebView) {
        if(loadThisSite != nil){
            
            
            if(loadThisSite.getName() == "Correspondent" && !AutoLogin){
                WebSiteView.alpha = 0.0
            }
            
            if(loadThisSite.getName() == "Chicago Tribune" && !AutoLogin){
                let URL: NSURL = NSURL(string: "http://nieonline.com/chicago/studentconnect.cfm")!
                let request:NSMutableURLRequest = NSMutableURLRequest(URL: URL)
                request.HTTPMethod = "POST"
                request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                let bodyData = "teacherlastname=jhhsnewspaper@gmail.com&classpword=huskies"
                request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
                AutoLogin = true
                WebSiteView.loadRequest(request)
                
            }
            if(loadThisSite.getName() == "Chicago Sun Times" && !AutoLogin){
                let URL: NSURL = NSURL(string: "http://chicagosuntimesnie.newspaperdirect.com/")!
                let request:NSMutableURLRequest = NSMutableURLRequest(URL: URL)
                request.HTTPMethod = "POST"
                request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                let bodyData = "_ctl0:_ctl0:MainContentPlaceHolder:MainPanel:_ctl4:login:_ctl0:UserName=jhhsnewspaper@gmail.com&_ctl0:_ctl0:MainContentPlaceHolder:MainPanel:_ctl4:login:_ctl0:Password=huskies"
                request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
                AutoLogin = true
                WebSiteView.loadRequest(request)
                
            }
            if(loadThisSite.getName() == "Flipster" && !AutoLogin){
                let URL: NSURL = NSURL(string: "http://search.ebscohost.com/login.aspx?authtype=ip,uid&profile=eon&custid=s9461855")!
                let request:NSMutableURLRequest = NSMutableURLRequest(URL: URL)
                request.HTTPMethod = "POST"
                request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                let bodyData = "user=johnhersey&password=library"
                request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
                AutoLogin = true
                WebSiteView.loadRequest(request)
            }
            if(loadThisSite.getName() == "Infinite Campus" && !AutoLogin){
                let URL: NSURL = NSURL(string: "https://ic.d214.org/campus/verify.jsp")!
                let request:NSMutableURLRequest = NSMutableURLRequest(URL: URL)
                request.HTTPMethod = "POST"
                request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                
                
                let appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                let context:NSManagedObjectContext = appDel.managedObjectContext
                let rdata = NSFetchRequest(entityName: "User")
                rdata.returnsObjectsAsFaults = false
                let results:NSArray = try! context.executeFetchRequest(rdata)
                
                if(results.count > 0){
                    let res = results[0] as! NSManagedObject
                    let bodyData = "username=\(res.valueForKey("username") as! String)&password=\(res.valueForKey("password") as! String)&appName=township_214&useCSRFProtection=true&y=16&x=34"
                    request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
                    AutoLogin = true
                    WebSiteView.loadRequest(request)
                }

            }
            if(loadThisSite.getName() == "Overdrive" && !AutoLogin){
                let URL: NSURL = NSURL(string: "https://twpdistrict214.libraryreserve.com/10/45/en/BANGAuthenticate.dll")!
                let request:NSMutableURLRequest = NSMutableURLRequest(URL: URL)
                request.HTTPMethod = "POST"
                request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.addValue("SecureSession=C1287AB9-8FA0-48E5-AD45-02F3F60E5523; SourceHost=d214.lib.overdrive.com; UIOptions=10|45|en; _ga=GA1.3.1656530739.1457975062; _dc_gtm_UA-34791607-6=1; _ga=GA1.2.1656530739.1457975062; _dc_gtm_UA-34791607-28=1", forHTTPHeaderField: "Cookie")
                
                let appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                let context:NSManagedObjectContext = appDel.managedObjectContext
                let rdata = NSFetchRequest(entityName: "User")
                rdata.returnsObjectsAsFaults = false
                let results:NSArray = try! context.executeFetchRequest(rdata)
                
                if(results.count > 0){
                let res = results[0] as! NSManagedObject
               // NSHTTPCookieStorage.sharedHTTPCookieStorage().cookieAcceptPolicy = .Always
                print("username=\(res.valueForKey("username") as! String)&pass=\(res.valueForKey("password") as! String)")
                let bodyData = "LibraryCardILS=township214&lcn=\(res.valueForKey("username") as! String)&LibraryCardPIN=\(res.valueForKey("password") as! String)&URL=Default.htm"
                request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
                AutoLogin = true
                WebSiteView.loadRequest(request)
                    }

            }
            if(loadThisSite.getName() == "Schoology" && !AutoLogin){
                let URL: NSURL = NSURL(string: "https://schoology.d214.org/login/ldap?&school=26201007")!
                let request:NSMutableURLRequest = NSMutableURLRequest(URL: URL)
                request.HTTPMethod = "POST"
                request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                
                
                let appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                let context:NSManagedObjectContext = appDel.managedObjectContext
                let rdata = NSFetchRequest(entityName: "User")
                rdata.returnsObjectsAsFaults = false
                let results:NSArray = try! context.executeFetchRequest(rdata)
                
                if(results.count > 0){
                    let res = results[0] as! NSManagedObject
                    
                    let bodyData = "mail=\(res.valueForKey("username") as! String)&pass=\(res.valueForKey("password") as! String)&school_nid=26201007&form_id=s_user_login_form"
                    request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
                    AutoLogin = true
                    WebSiteView.loadRequest(request)
                }
                
            }
            if(loadThisSite.getName() == "Moodle" && !AutoLogin){
                let URL: NSURL = NSURL(string: "http://moodle2.d214.org/login/index.php")!
                let request:NSMutableURLRequest = NSMutableURLRequest(URL: URL)
                request.HTTPMethod = "POST"
                request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                
                
                let appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                let context:NSManagedObjectContext = appDel.managedObjectContext
                let rdata = NSFetchRequest(entityName: "User")
                rdata.returnsObjectsAsFaults = false
                let results:NSArray = try! context.executeFetchRequest(rdata)
                
                if(results.count > 0){
                    let res = results[0] as! NSManagedObject
                    
                    let bodyData = "username=\(res.valueForKey("username") as! String)&password=\(res.valueForKey("password") as! String)"
                    request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
                    AutoLogin = true
                    WebSiteView.loadRequest(request)
                }
                
            }
            if(loadThisSite.getName() == "Gapps" && !AutoLogin){
                let URL: NSURL = NSURL(string: "https://gapps.d214.org/")!
                let request:NSMutableURLRequest = NSMutableURLRequest(URL: URL)
                request.HTTPMethod = "POST"
                request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                
                
                let appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                let context:NSManagedObjectContext = appDel.managedObjectContext
                let rdata = NSFetchRequest(entityName: "User")
                rdata.returnsObjectsAsFaults = false
                let results:NSArray = try! context.executeFetchRequest(rdata)
                
                if(results.count > 0){
                    let res = results[0] as! NSManagedObject
                    
                    let bodyData = "netid=\(res.valueForKey("username") as! String)&netidpword=\(res.valueForKey("password") as! String)"
                    request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
                    AutoLogin = true
                    WebSiteView.loadRequest(request)
                }
                
            
            }


            

        }
    }

    func webViewDidFinishLoad(webView: UIWebView) {
        if (!isInitialWebView){
            
            let data = WebSiteView.stringByEvaluatingJavaScriptFromString("document.documentElement.outerHTML")
            
            let range = data?.rangeOfString("<title>Database Menu</title>")
            WebSiteView.alpha = 1.0
            
            
            if range != nil{
                WebSiteView.alpha = 0.0
                isLoggedIn = true
                LogoutButton.title = "Logout?"
                LogoutButton.enabled = true
                LogoutButton.tintColor = UIColor(red: 255/255, green: 140/255, blue: 0.0, alpha: 1.0)

                self.splitViewController?.presentsWithGesture = true
                self.navigationItem.leftBarButtonItem = savedSplitButton
                
                hideLogin()
                
                let appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
            
                let context:NSManagedObjectContext = appDel.managedObjectContext
                let newUser = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: context) as! NSManagedObject
                newUser.setValue(usernameTextField.text!, forKey: "username")
                newUser.setValue(passwordTextField.text!, forKey: "password")
                try? context.save()
                
                
                self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 255/255, green: 140/255, blue: 0.0, alpha: 1.0)
                usernameTextField.text = ""
                passwordTextField.text = ""
                
                
            }
            
            if(!isLoggedIn)
            {
                let alert = UIAlertController(title: "Login Problem", message: "Wrong Username Or Password", preferredStyle: .Alert)
                let button = UIAlertAction(title: "Try Agian!", style: .Default, handler: nil)
                alert.addAction(button)
                presentViewController(alert, animated: true, completion: nil)
            }
            if(loadThisSite != nil){
                if(loadThisSite.getName() == "Correspondent" && !AutoLogin){
                  
                    
                    let link = WebSiteView.stringByEvaluatingJavaScriptFromString("document.getElementById('streamElm14').getElementsByTagName('a')[0].href")
                    AutoLogin = true
                    
                    WebSiteView.loadRequest(NSURLRequest(URL: NSURL(string: link!)!))
                   
                    
                    
            
                }
            }
        }
        isInitialWebView = false
        
    }

    @IBAction func LoginINPressed(sender: AnyObject) {
        let savedUserName = usernameTextField.text!
        let savedPassword = passwordTextField.text!
        savedLoginInfo = [savedUserName,savedPassword]
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
        logoView.alpha = 0.0
        ImageOverlay.image = UIImage(named: "backgroundimage")
        self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.Automatic
    }
    func showLogin(){
        logoView.image = UIImage(named: "D214Logo")
        logoView.alpha = 1.0
        usernameTextField.alpha = 1.0
        passwordTextField.alpha = 1.0
        LoginButton.alpha = 1.0
        ImageOverlay.image = UIImage(named: "RedLogin")
        ImageOverlay.alpha = 1.0
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.leftBarButtonItem?.enabled = false
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.clearColor()
        splitViewController?.presentsWithGesture = false
        usernameTextField.placeholder = "Net ID"
        passwordTextField.placeholder = "Password"
        
        LogoutButton.title = "Not Logged In"
        LogoutButton.enabled = false
        splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.PrimaryHidden

    }
     func textFieldShouldReturn(textField: UITextField) -> Bool {
    
        
        if(textField == self.passwordTextField!){
        self.LoginINPressed(self.LoginButton)
        }
        if(textField == self.usernameTextField!){
            usernameTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
            
        }
        return true
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
            
        let alertController = UIAlertController(title: "Network Error", message: "Not Connected to Wifi or has been Disconnected", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Please Recconnect and Retry", style: .Destructive) { (action) in
            
        }
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true){
                
        }
                
            

        }

    }
    @IBAction func HelpButtonPressed(sender: AnyObject) {
        //let popoverContent = (self.storyboard?.instantiateViewControllerWithIdentifier("infoView"))! as UIViewController
        //let nav = UINavigationController(rootViewController: popoverContent)
        //nav.modalPresentationStyle = UIModalPresentationStyle.Popover
        //let popover = nav.popoverPresentationController
        //self.presentViewController(nav, animated: true, completion: { _ in })
        // popover!.permittedArrowDirections = .Up
        
        //popoverContent.preferredContentSize = CGSizeMake(250, 250)
        //UITextView = UITextView(frame: CGRect(x: 0, y: 0, width: 300, height: 300), textContainer: NSTextContainer())
        //let textField: UITextView = UITextView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
        
        //popoverContent.view.addSubview(textField)
        //popover!.delegate = self.navigationController.dele
        //popover!.sourceView = self.view
        //popover!.sourceRect = tableView.rectForRowAtIndexPath(indexPath)
        //popoverContent.navigationController?.setNavigationBarHidden(true, animated: true)
        

    }
    @IBAction func LogoutPressed(sender: AnyObject) {
        if(isLoggedIn == true){
        let alertController = UIAlertController(title: "Logout?", message: "Are you sure you want to logout?", preferredStyle: .Alert)
        
        let logoutAction = UIAlertAction(title: "Yes", style: .Cancel) { (action) in
            self.WebSiteView.loadRequest(NSURLRequest (URL: NSURL(string: "http://ezproxy.d214.org:2048/logout")!))
            self.isInitialWebView = true
            
            self.deleteUserData()
        
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
       func deleteUserData() {
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDel.managedObjectContext
        let coord = appDel.persistentStoreCoordinator
        
        let fetchRequest = NSFetchRequest(entityName: "User")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try coord.executeRequest(deleteRequest, withContext: context)
        } catch let error as NSError {
            debugPrint(error)
        }
    }
    
   
}



