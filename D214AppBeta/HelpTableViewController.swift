//
//  HelpViewController.swift
//  D214AppBeta
//
//  Created by mobileapps on 3/17/16.
//  Copyright © 2016 Blake P. Spoerry. All rights reserved.
//

import UIKit
import CoreData

class HelpTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var HelpTextView: UITextView!
    var helpData: [SuString] = [SuString]()
    

    @IBOutlet weak var HelpTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.HelpTextView.text = nil
        self.HelpTextView.alpha = 0.0
        self.backButton.enabled = false
        self.backButton.tintColor = UIColor.clearColor()
        self.HelpTextView.editable = false
        self.HelpTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "HelpCell")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return helpData.count
    }
         func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell = self.HelpTableView.dequeueReusableCellWithIdentifier("HelpCell")! as UITableViewCell

            
        
            
            cell.textLabel?.textColor = UIColor.blackColor()
            
            cell.textLabel?.text = helpData[indexPath.row].getName()
            
            return cell
        }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //performSegueWithIdentifier("showHelp", sender: tableView)
        self.preferredContentSize = CGSizeMake(400, 300)
        HelpTextView.alpha = 1.0
        HelpTableView.alpha = 0.0
        HelpTextView.text = helpData[indexPath.row].getInfo()
        HelpTextView.font = UIFont(name: "Helvetica", size: 18)
        self.backButton.enabled = true
        self.backButton.tintColor = UIColor.blueColor()
         self.HelpTextView.editable = false
        
        
    }

    @IBAction func BackButtonPressed(sender: AnyObject) {
         self.HelpTextView.editable = false
        self.preferredContentSize = CGSizeMake(200, 200)
        self.HelpTextView.text = nil
        self.HelpTextView.alpha = 0.0
        self.HelpTableView.alpha = 1.0
        self.backButton.enabled = false
        self.backButton.tintColor = UIColor.clearColor()
        
    }

        
    
    
    

}

    



