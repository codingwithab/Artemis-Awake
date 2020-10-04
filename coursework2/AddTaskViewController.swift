//
//  AddTaskViewController.swift
//  coursework2
//
//  Created by Aman Benbi on 12/05/2020.
//  Copyright © 2020 Aman Benbi. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI
import CoreData

class AddTaskViewController: UIViewController {
    @IBOutlet weak var assessmentNLabel: UILabel!
    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var lengthOfTime: UITextField!
    @IBOutlet weak var taskNotes: UITextField!
    @IBOutlet weak var notify: UISwitch!
    @IBOutlet weak var taskStartDate: UIDatePicker!
    @IBOutlet weak var taskDueDate: UIDatePicker!
    @IBOutlet weak var percentageAdd: UITextField!
    

    var assessment:Assessment?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentDate = Date()
        taskStartDate.minimumDate = currentDate as Date
        taskStartDate.date = currentDate as Date
//        assessmentNLabel.text = self.assessment?.assessmentName
        
        
        // Do any additional setup after loading the view.
    }

    @IBAction func saveTask(_ sender: Any) {
        
        let task = Tasks(context: context)
        
        if((self.taskName.text != "") && (self.taskNotes.text != "") && (self.lengthOfTime.text != "") && (taskStartDate.date < taskDueDate.date)) {
        task.assessmentNT = assessment?.assessmentName
        task.taskName = taskName.text
            task.length = Int16(self.lengthOfTime.text!)!
        task.notes = taskNotes.text
            task.percentageComplete = Int16(self.percentageAdd.text!)!
            task.startDate = self.taskStartDate.date
            task.due = self.taskDueDate.date
            
            if notify.isOn {
                
                self.title = "Add Event to Calendar"
                       

                       // Do any additional setup after loading the view.
                       
                       let eventStore : EKEventStore = EKEventStore()
                       
                
                       //this is how you set up access for the reminders - extra task
                       eventStore.requestAccess(to: EKEntityType.reminder, completion:
                           {(granted, error) in
                               if !granted {
                                   print("Access to store not granted")
                               }
                       })
                        //this is how you set up access for the calendar
                       eventStore.requestAccess(to: .event) { (granted, error) in
                           
                           if (granted) && (error == nil) {
                               print("granted \(granted)")
                               print("error \(error)")
                               
                               let event:EKEvent = EKEvent(eventStore: eventStore)
                               DispatchQueue.main.async {
                               event.title = self.taskName.text
                            event.startDate = self.taskStartDate.date
                            event.endDate = self.taskDueDate.date
                               event.notes = "Test Notes"
                               //create an alarm (alert on the calendar event)
                               let alarm:EKAlarm = EKAlarm()
                               alarm.relativeOffset = 60 * -60 //1 hour before in seconds
                               //add the alarm
                               event.addAlarm(alarm)
                               event.calendar = eventStore.defaultCalendarForNewEvents
                               do {
                                   try eventStore.save(event, span: .thisEvent)
                               } catch let error as NSError {
                                   print("failed to save event with error : \(error)")
                                   let alert = UIAlertController(title: "Tasks have not been saved", message: (error as NSError).localizedDescription, preferredStyle: .alert)
                                   let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                   alert.addAction(OKAction)
                                   self.present(alert, animated: true, completion: nil)
                               }
                               print("Saved Event")
                               let alert = UIAlertController(title: "Saved", message:"Event has been saved to your Calendar",preferredStyle: .alert)
                               let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                               alert.addAction(OKAction)
                               self.present(alert, animated: true, completion: nil)
                            }}
                           else{
                               
                               print("failed to save event with error : \(String(describing: error)) or access not granted")
                           }
                       }
                
            }
            
            
            assessment?.addToTasks(task)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()

    }
    else {
        let alert = UIAlertController(title: "Missing Details", message: "Please add the relevant details...", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
    
}
