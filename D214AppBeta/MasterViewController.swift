//
//  MasterViewController.swift
//  D214AppBeta
//
//  Created by Robert D. Brown on 1/13/16.
//  Copyright © 2016 Robert D. Brown. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate, UIPopoverControllerDelegate  {

    @IBOutlet weak var SectionControl: UISegmentedControl!
    
    
    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    
    var school: String = "JHHS"
    var currentData: [SuString] = [SuString]()
    var sectionidentifier: String?
    var resourcesToggle: Bool = false
    
    //var savedSplitWebView: UIWebView? = UIWebView()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TableList = getFile(sectionidentifier!)
        
        //self.navigationItem.leftBarButtonItem = self.editButtonItem()

        //let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        //self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
            //let object = self.fetchedResultsController.objectAtIndexPath(indexPath)
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                //controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
                controller.loadThisSite = currentData[indexPath.row]
                
                
            }
        }
        if segue.identifier == "showPopover" {
           
            if let indexPath = self.tableView.indexPathForSelectedRow {
                var controller = (segue.destinationViewController as! UINavigationController).popoverPresentationController
                
            }
           
        }
    }
    
    func adaptivePresentationStyleForPresentationController(
        controller: UIPresentationController!) -> UIModalPresentationStyle {
            return .None
    }
    @IBAction func SectionControlChanged(sender: UISegmentedControl) {
        switch(SectionControl.selectedSegmentIndex){
        case 0:
            currentData = getFile("databaselist")
            resourcesToggle = !resourcesToggle
            tableView.reloadData()
        case 1:
            currentData = getFile("resoucres")
            tableView.reloadData()
        case 2:
            currentData = getFile("writing")
            tableView.reloadData()
        case 3:
            currentData = getFile("media")
            tableView.reloadData()
        default:
            break
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
    
    // MARK: - Table View

   

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return currentData.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WebsiteCell")! as! D214Cell
        //cell.textLabel?.text = currentData[indexPath.row].getName()
        //cell.selectionStyle = UITableViewCellSelectionStyle.Blue
        //cell.accessoryType = UITableViewCellAccessoryType.DetailButton
        //cell.detailTextLabel?.text = currentData[indexPath.row].getInfo()
        
        cell.textLabel?.text = currentData[indexPath.row].getName()
        //cell.cellInfo
        
        return cell
    }
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showPopover", sender: self)
    }
    
    
    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("Event", inManagedObjectContext: self.managedObjectContext!)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //print("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController? = nil
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            self.configureCell(tableView.cellForRowAtIndexPath(indexPath!)!, atIndexPath: indexPath!)
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }

    

    
    func insertNewObject(sender: AnyObject) {
    let context = self.fetchedResultsController.managedObjectContext
    let entity = self.fetchedResultsController.fetchRequest.entity!
    let newManagedObject = NSEntityDescription.insertNewObjectForEntityForName(entity.name!, inManagedObjectContext: context)
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    newManagedObject.setValue(NSDate(), forKey: "timeStamp")
    
    // Save the context.
    do {
    try context.save()
    } catch {
    // Replace this implementation with code to handle the error appropriately.
    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //print("Unresolved error \(error), \(error.userInfo)")
    abort()
    }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    

    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let object = self.fetchedResultsController.objectAtIndexPath(indexPath)
        cell.textLabel!.text = object.valueForKey("timeStamp")!.description
    }


    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
        if SectionControl.selectedSegmentIndex == 0 && resourcesToggle
        {
            currentData = getFile(currentData[indexPath.row].getName())
            tableView.reloadData()
            resourcesToggle = !resourcesToggle
            SectionControl.selectedSegmentIndex = -1
        }
    }
    
    /*
     // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
     
     func controllerDidChangeContent(controller: NSFetchedResultsController) {
         // In the simplest, most efficient, case, reload the table view.
         self.tableView.reloadData()
     }
     */

}

