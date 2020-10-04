//
//  DetailViewController.swift
//  coursework2
//
//  Created by Aman Benbi on 11/05/2020.
//  Copyright © 2020 Aman Benbi. All rights reserved.
//

import UIKit
import CoreData

class customView: UIView {
    
    var fillAmount:CGFloat = 28

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        UIColor.black.setStroke()
        let   newRect  =   CGRect(x:0,y:0,width:fillAmount,height:30)
        let path = UIBezierPath(roundedRect: newRect, cornerRadius: 2.0)
        path.stroke()
        UIColor.blue.setFill()
        path.fill()
    }
}


class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate
{
    
    @IBOutlet weak var tableView: UITableView!
    var currentTask:Tasks?
    var currentAssessment:Assessment?

    
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let cellColour:UIColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.1)
    let cellSelColour:UIColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.2)
    
    override func viewDidLoad() {
           super.viewDidLoad()
           // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
           configureView()
       }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! CustomTaskTableViewCell
        let task = fetchedResultsController.object(at: indexPath)
        
        cell.customTaskNameCell.text = task.taskName
        cell.customProgressCell.text = String(task.percentageComplete) + "%"
        cell.progressView.fillAmount = CGFloat(task.percentageComplete)
        
        self.configureCell(cell, indexPath: indexPath)
        let backgroundView = UIView()
        backgroundView.backgroundColor = cellSelColour
        cell.selectedBackgroundView = backgroundView
        
        
        return cell
    }
    
    // MARK: - Configure the Cell
    
    func configureCell(_ cell: UITableViewCell, indexPath: IndexPath)
        
    {
        if let title = self.fetchedResultsController.fetchedObjects?[indexPath.row].taskName {
//        cell.textLabel?.text = title
        cell.backgroundColor = cellColour
        }
//        if let percentage = self.fetchedResultsController.fetchedObjects?[indexPath.row].percentageComplete
//        {
//
//            cell.detailTextLabel?.text = String(percentage)
//
//        }
        else {

            cell.detailTextLabel?.text = ""

        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.fetchedResultsController.sections?.count ?? 0
        
    }
    

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    


    func configureView() {
        // Update the user interface for the detail item.
        if let detail = assessment {
            if let label = detailDescriptionLabel {
                label.text = detail.assessmentName
            }
        }
        if let detail = currentTask {
            if let label = detailDescriptionLabel {
                label.text = detail.taskName
            }
        }
    }

    var assessment: Assessment? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    var cTask: Tasks? {
           didSet {
               // Update the view.
               configureView()
           }
       }
    // MARK: - Fetched results controller
    
    var _fetchedResultsController: NSFetchedResultsController<Tasks>? = nil

    var fetchedResultsController: NSFetchedResultsController<Tasks> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        let currentAssessment = self.assessment
        let fetchRequest: NSFetchRequest<Tasks> = Tasks.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "taskName", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if(self.assessment != nil)
        {
            let predicate = NSPredicate(format: "assessments = %@", currentAssessment!)
            fetchRequest.predicate = predicate
        }
        else{
            let predicate = NSPredicate(format: "assessmentNT = %@", "task1")
            fetchRequest.predicate = predicate
        }
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController<Tasks>(
        fetchRequest: fetchRequest,
        managedObjectContext: self.managedObjectContext,
        sectionNameKeyPath: #keyPath(Tasks.assessments),
        cacheName: nil)
        
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
             // Replace this implementation with code to handle the error appropriately.
             // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             let nserror = error as NSError
             fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    
    
    
    
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       // <#code#>
        
        if let identifier = segue.identifier {
            if let indexPath = tableView.indexPathForSelectedRow {
            let object = fetchedResultsController.object(at: indexPath)
                self.currentTask = object
//                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
//                controller.currentTask = object
//                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
//                controller.navigationItem.leftItemsSupplementBackButton = true
//                detailViewController = controller
            }
            switch identifier
            {
            case "assessmentDetail":
                let destVC = segue.destination as! AssessmentDetailViewController
                if let name = self.assessment?.assessmentName
                {
                    destVC.textAN = "Name: " + name
                } else {
                     destVC.textAN = "Name: "
                }
                if let module = self.assessment?.moduleName
                {
                    destVC.textmN = "Job Role: " + module
                } else {
                    destVC.textmN = "Job Role: "
                }
                if let lev = self.assessment?.level
                {
                    destVC.textlevelL = "Level of Importance (1-10): " + String(lev)
                } else {
                    destVC.textlevelL = "Level of Importance (1-10): "
                }
                if let markAward = self.assessment?.markAwarded
                {
                    destVC.markAwardText = "DNA Number: " + String(markAward)
                } else {
                    destVC.markAwardText = "DNA Number: "
                }
                if let val = self.assessment?.value
                {
                    destVC.textValue = String(val)
                } else {
                    destVC.textValue = "Timezone (Number): "
                }
                if let dates = self.assessment?.dueDate
                {
                    let df = DateFormatter()
                    df.dateFormat = "dd-MM-yyyy"
                    let formattedDate = df.string(from: assessment!.dueDate!)
                    
                    let seconds = self.assessment?.dueDate?.timeIntervalSince(Date())
                    let days = seconds!/(60*60*24)
                    
                    let roundUpDays = round(days)
                    let daysInBetweeen = Int(roundUpDays)
                    
                    destVC.textDue =  daysInBetweeen
                    
                } else {
                    destVC.textDue = 0
                }
                if let note = self.assessment?.notes
                {
                    destVC.textNotes = "Notes: " + note
                } else {
                    destVC.textNotes = "Notes: "
                }
                if let amountOfDaysBetween = self.assessment?.amountOfDays
                {
                    destVC.amountOfDays = Int(amountOfDaysBetween)
                }
                
                
            default:
            break
                
            }
        }
        
        if segue.identifier == "addTask"
        {
            
            let object = self.assessment
            let controller = segue.destination as! AddTaskViewController
            controller.assessment = object
        }
        
           let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let task = Tasks(context: context)

        
        if segue.identifier == "editTask" {
        let destVC = segue.destination as! EditTaskViewController
//          print("Hello")
            destVC.currentTask = self.currentTask
//            print(currentTask!.taskName)
//            print("Hello")
        }
        
        
    }
    
    // MARK: Table Editing
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
            case .insert:
                tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
            case .delete:
                tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
            default:
                return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            case .insert:
                tableView.insertRows(at: [newIndexPath!], with: .fade)
            case .delete:
                tableView.deleteRows(at: [indexPath!], with: .fade)
            case .update:
                self.configureCell(tableView.cellForRow(at: indexPath!)!, indexPath: newIndexPath!)
            case .move:
                self.configureCell(tableView.cellForRow(at: indexPath!)!, indexPath: newIndexPath!)
                tableView.moveRow(at: indexPath!, to: newIndexPath!)
            default:
                return
        }
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = fetchedResultsController.managedObjectContext
            context.delete(fetchedResultsController.object(at: indexPath))
                
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

}

