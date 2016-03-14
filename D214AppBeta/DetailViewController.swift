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

class DetailViewController: UIViewController, UIWebViewDelegate {
    var isLoggedIn: Bool!
    @IBOutlet weak var LogoutButton: UIBarButtonItem!
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
            LogoutButton.title = "Logged In!"
            LogoutButton.tintColor = UIColor(red: 0.0, green: 255/255, blue: 0.0, alpha: 1.0)
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
            if(loadThisSite.getName() == "Overdrive" && !AutoLogin){
                let URL: NSURL = NSURL(string: "https://twpdistrict214.libraryreserve.com/10/45/en/BANGAuthenticate.dll")!
                let request:NSMutableURLRequest = NSMutableURLRequest(URL: URL)
                request.HTTPMethod = "POST"
                request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.addValue("SecureSession=97AA9D8F-2B77-4520-A09D-228B902A1BAE; SourceHost=d214.lib.overdrive.com; UIOptions=10|45|en; _ga=GA1.3.1656530739.1457975062; _dc_gtm_UA-34791607-6=1; _ga=GA1.2.1656530739.1457975062; _dc_gtm_UA-34791607-28=1", forHTTPHeaderField: "Cookie")
                
                var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                var context:NSManagedObjectContext = appDel.managedObjectContext
                var rdata = NSFetchRequest(entityName: "User")
                rdata.returnsObjectsAsFaults = false
                var results:NSArray = try! context.executeFetchRequest(rdata)
                
                if(results.count > 0){
                var res = results[0] as! NSManagedObject
               // NSHTTPCookieStorage.sharedHTTPCookieStorage().cookieAcceptPolicy = .Always
                
                let bodyData = "LibraryCardILS=township214&lcn=\(res.valueForKey("username") as! String)&LibraryCardPIN=\(res.valueForKey("password") as! String)&URL=Default.htm"
                
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
            
            
            
            if range != nil{
                WebSiteView.alpha = 0.0
                isLoggedIn = true
                LogoutButton.title = "Logged In!"
                LogoutButton.enabled = true
                LogoutButton.tintColor = UIColor(red: 0.0, green: 255/255, blue: 0.0, alpha: 1.0)
                self.splitViewController?.presentsWithGesture = true
                self.navigationItem.leftBarButtonItem = savedSplitButton
                
                var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                hideLogin()
                var context:NSManagedObjectContext = appDel.managedObjectContext
                var newUser = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: context) as! NSManagedObject
                newUser.setValue(usernameTextField.text!, forKey: "username")
                newUser.setValue(passwordTextField.text!, forKey: "password")
                try? context.save()
                print(newUser)
                
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
                  
                    let link = WebSiteView.stringByEvaluatingJavaScriptFromString("document.getElementById('streamElm14').getAttribute('metadata')")
                    let link2 = WebSiteView.stringByEvaluatingJavaScriptFromString("document.getElementById('streamElm14').cover")
                    let link3 = WebSiteView.stringByEvaluatingJavaScriptFromString("document.getElementById('streamElm14').innerHTML")
                    print(link!)
                    print(link2!)
                    print(link3!)
                    AutoLogin = true

                    
                    /*if let content = (link){
                        let myStrings = content.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
                        for item in myStrings{
                            if(item.containsString("/thecorrespondent/")){
                            print(item)
                            }
                    AutoLogin = true
                }
                }
                }*/
            
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
            
        let alertController = UIAlertController(title: "Network Error", message: "Not Connected to Wifi or has been Disconnected", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Please Recconnect and Retry", style: .Destructive) { (action) in
            
        }
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true){
                
        }
                
            

        }

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
    func getFile(filename: String) -> [SuString]{
        var list = [SuString]()
        if let path = NSBundle.mainBundle().pathForResource(filename, ofType: "txt"){
            
            let data = try? String(contentsOfFile:path, encoding: NSUTF8StringEncoding)
            if let content = (data){
                let myStrings = content.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
                for item in myStrings{
                    let section = item.componentsSeparatedByString("|")
                    list.append(SuString(title: section[0], url: NSURL(string: section[1])!, info: section[2]))
                }
            }
        }
        return list
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



