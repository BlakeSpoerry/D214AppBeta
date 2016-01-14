//
//  MainTableViewController.swift
//  D214AppAlpha
//
//  Created by mobileapps on 11/6/15.
//  Copyright © 2015 JohnHerseyHighSchool. All rights reserved.
//

import UIKit

class MainTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var DataBaseTable: UITableView!
    @IBOutlet weak var ResourceTable: UITableView!
    @IBOutlet weak var WritingTable: UITableView!
    
    @IBOutlet weak var MainSegmentedControl: UISegmentedControl!
    
    var savedWebView: UIWebView?
    var selectedData: SuString?
    
    // Empty SuStrings used to store data
    var databases = [SuString]()
    var resorces = [SuString]()
    var writing = [SuString]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAlphas([0.0,0.0,0.0])
        //sets the segmented controller to me unselcted
         MainSegmentedControl.selectedSegmentIndex = -1
        //databases = getList("")
        //resorces = getList("")
        writing = getList("writing")
        databases = getList("databaselist")
        resorces = getList("resources")
    }
    
    @IBAction func segmentedControlChanged(sender: UISegmentedControl) {
        switch(MainSegmentedControl.selectedSegmentIndex){
        case 0:
            DataBaseTable.reloadData()
            setAlphas([1.0,0.0,0.0])
        case 1:
            ResourceTable.reloadData()
            setAlphas([0.0,1.0,0.0])
        case 2:
            WritingTable.reloadData()
            setAlphas([0.0,0.0,1.0])
        default:
            break
        }

    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        let returnValue = 0
        switch(MainSegmentedControl.selectedSegmentIndex){
        case 0:
            return databases.count
        case 1:
            return resorces.count
        case 2:
            return writing.count
        default:
            break
        }
        return returnValue
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = UITableViewCell()
        switch(MainSegmentedControl.selectedSegmentIndex){
        case 0:
            cell = DataBaseTable.dequeueReusableCellWithIdentifier("CellDatabase", forIndexPath: indexPath)
            cell.textLabel?.text = databases[indexPath.row].getName()
            setAlphas([1.0,0.0,0.0])
        case 1:
            cell = ResourceTable.dequeueReusableCellWithIdentifier("CellResource", forIndexPath: indexPath)
            cell.textLabel?.text = resorces[indexPath.row].getName()
            setAlphas([0.0,1.0,0.0])
        case 2:
            cell = WritingTable.dequeueReusableCellWithIdentifier("CellWriting", forIndexPath: indexPath)
            cell.textLabel?.text = writing[indexPath.row].getName()
            setAlphas([0.0,0.0,1.0])
        default:
            break
        }
        
        
        return cell
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath)
        switch(MainSegmentedControl.selectedSegmentIndex){
        case 0:
            selectedData = databases[indexPath.row]
            performSegueWithIdentifier("SplitWebViewSegue", sender: selectedCell)
        case 1:
            selectedData = resorces[indexPath.row]
            performSegueWithIdentifier("SingleWebViewSegue", sender: selectedCell)
        case 2:
            selectedData = writing[indexPath.row]
            performSegueWithIdentifier("SingleWebViewSegue", sender: selectedCell)
        default:
            break
        }
    }
    
    
    
    func getList(names: [String], urls: [String], infos: [String]) -> [SuString]{
        
        var list = [SuString]()
        
        for i in 0...names.count-1{
            
            list.append(SuString(title: names[i], url: NSURL(string: urls[i])!, info: infos[i]))
            
        }
        return list
        
        
    }
    
    func getList(filename: String) -> [SuString]{
        var list = [SuString]()
        if let path = NSBundle.mainBundle().pathForResource(filename, ofType: "txt"){
            
            let data = try? String(contentsOfFile:path, encoding: NSUTF8StringEncoding)
            if let content = (data){
                let myStrings = content.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
                for i in 0...myStrings.count-1{
                let section = myStrings[i].componentsSeparatedByString(",")
                list.append(SuString(title: section[0], url: NSURL(string: section[1])!, info: section[2]))
                }
            }
        }
        return list
    }
    func setAlphas(alphas: [CGFloat]){
        
        DataBaseTable.alpha = alphas[0]
        ResourceTable.alpha = alphas[1]
        WritingTable.alpha = alphas[2]
        
    }

   
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SingleWebViewSegue"
        {
            let nextPath: SingleWebView = segue.destinationViewController as! SingleWebView
            nextPath.SingleWebViewer = savedWebView
            nextPath.cellSelected = selectedData
            
        }
        if segue.identifier == "SplitWebViewSegue"
        {
            
            let firstPath = segue.destinationViewController as! UISplitViewController
            let secondPath = firstPath.viewControllers.first as! UINavigationController
            let nextPath = secondPath.viewControllers.first as! MasterViewController
            //nextPath.savedSplitWebView = savedWebView!
            nextPath.sectionidentifier = selectedData?.getName()
        }
    
        
    }
    


    

    
}

