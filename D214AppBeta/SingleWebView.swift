//
//  SingleWebView.swift
//  D214AppAlpha
//
//  Created by mobileapps on 11/29/15.
//  Copyright © 2015 JohnHerseyHighSchool. All rights reserved.
//

import UIKit

class SingleWebView: UIViewController {
    
    @IBOutlet weak var SingleWebViewer: UIWebView!
    
    var cellSelected: SuString!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
         SingleWebViewer.loadRequest(NSURLRequest(URL: (cellSelected?.getURL())!))
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}
