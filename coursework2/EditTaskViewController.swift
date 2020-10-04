//
//  EditTaskViewController.swift
//  coursework2
//
//  Created by Aman Benbi on 26/05/2020.
//  Copyright © 2020 Aman Benbi. All rights reserved.
//

import UIKit
import CoreData
import EventKit
import EventKitUI

class EditTaskViewController: UIViewController {

    @IBOutlet weak var taskNamefieldEdit: UITextField!
    @IBOutlet weak var lengthEdit: UITextField!
    @IBOutlet weak var noteEdit: UITextField!
    @IBOutlet weak var startDateEdit: UIDatePicker!
    @IBOutlet weak var dueDateEdit: UIDatePicker!
    @IBOutlet weak var percentageComEdit: UITextField!
    @IBOutlet weak var switchEdit: UISwitch!
    //    var currentAssessment:Assessment?

    var currentTask:Tasks?
    var assessment:Assessment?

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        let task = Tasks(context: context)

        super.viewDidLoad()
//        print(currentTask?.taskName)
        taskNamefieldEdit.text = currentTask?.taskName
        lengthEdit.text = String(currentTask!.length)
        noteEdit.text = currentTask?.notes
        percentageComEdit.text = String(currentTask!.percentageComplete)
        startDateEdit.date = (currentTask!.startDate)!
        dueDateEdit.date = (currentTask!.due)!
        
        
    }
    
    
    @IBAction func editTaskUpdate(_ sender: Any) {
        if((taskNamefieldEdit.text != "") && (lengthEdit.text != "") && (lengthEdit.text != "") && (noteEdit.text != "") && (percentageComEdit.text != "") && (startDateEdit.date < dueDateEdit.date)) {
        currentTask?.taskName = taskNamefieldEdit.text
        currentTask?.length = Int16(lengthEdit.text!)!
        currentTask?.notes = noteEdit.text
    currentTask?.percentageComplete = Int16(percentageComEdit.text!)!
    currentTask?.due = dueDateEdit.date
    currentTask?.startDate = startDateEdit.date
        
        if switchEdit.isOn {
            
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
                           event.title = self.taskNamefieldEdit.text
                        event.startDate = self.startDateEdit.date
                        event.endDate = self.dueDateEdit.date
                           event.notes = "Test Notes"
                            
                            if (self.percentageComEdit.text! >= "90") {
                                let alert = UIAlertController(title: "Well Done", message:"You have completed majority of your task. Have a good day!",preferredStyle: .alert)
                                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alert.addAction(OKAction)
                                self.present(alert, animated: true, completion: nil)
                            }
                                else if ((self.percentageComEdit.text! >= "75") && (self.percentageComEdit.text! < "90")) {
                                let alert = UIAlertController(title: "Completition Required", message:"Go back to your task for another 30-45 Minutes.",preferredStyle: .alert)
                                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alert.addAction(OKAction)
                                self.present(alert, animated: true, completion: nil)
                            }
                                else if ((self.percentageComEdit.text! >= "60") && (self.percentageComEdit.text! < "75")) {
                                let alert = UIAlertController(title: "Completition Needed", message:"You need to do more of the task that is allocated to you.",preferredStyle: .alert)
                                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alert.addAction(OKAction)
                                self.present(alert, animated: true, completion: nil)
                            }
                                else {
                                    let alert = UIAlertController(title: "YOU NEED TO DO YOUR TASK!", message:"Go Back and Complete Your Task Properly!",preferredStyle: .alert)
                                    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                    alert.addAction(OKAction)
                                    self.present(alert, animated: true, completion: nil)
                                }
                            
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
                               let alert = UIAlertController(title: "Event could not save", message: (error as NSError).localizedDescription, preferredStyle: .alert)
                               let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                               alert.addAction(OKAction)
                               self.present(alert, animated: true, completion: nil)
                           }
                        
                           print("Saved Event")
                           let alert = UIAlertController(title: "Saved", message:"Event has been saved to your Calendar",preferredStyle: .alert)
                           let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                           alert.addAction(OKAction)
                           self.present(alert, animated: true, completion: nil)
                            
//                            if (self.percentageComEdit.text! >= "90") {
//                                let alert = UIAlertController(title: "Well Done", message:"You do not need any more sleep. Have a good day!",preferredStyle: .alert)
//                                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                                alert.addAction(OKAction)
//                                self.present(alert, animated: true, completion: nil)
//                            }
                            
                            (UIApplication.shared.delegate as! AppDelegate).saveContext()

                        }}
                       else{
                           
                           print("failed to save event with error : \(String(describing: error)) or access not granted")
                       }
                   }
            
        }
    
//        (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
        }
        else {
               let alert = UIAlertController(title: "Missing Details", message: "Please add the relevant details or check to see if date and time is correct...", preferredStyle: .alert)
               let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
               alert.addAction(okAction)
               self.present(alert, animated: true, completion: nil)
           }
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
