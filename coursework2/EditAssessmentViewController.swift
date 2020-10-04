//
//  EditAssessmentViewController.swift
//  coursework2
//
//  Created by Aman Benbi on 12/05/2020.
//  Copyright © 2020 Aman Benbi. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI
import CoreData

class EditAssessmentViewController: UIViewController {
    @IBOutlet weak var textModuleName: UITextField!
    @IBOutlet weak var textAssessmentName: UITextField!
    @IBOutlet weak var textLevel: UITextField!
    @IBOutlet weak var textValue: UITextField!
    @IBOutlet weak var textMarkAwarded: UITextField!
    @IBOutlet weak var dateDate: UIDatePicker!
    @IBOutlet weak var textNotes: UITextField!
    @IBOutlet weak var switchCalendar: UISwitch!
    
    var currentAssessment:Assessment?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentDate = NSDate()  //5 -  get the current date
        dateDate.minimumDate = currentDate as Date  //6- set the current date/time as a minimum
        dateDate.date = currentDate as Date //7 - defaults to current time but shows how to use it.
        
        textModuleName.text = currentAssessment?.moduleName
        textAssessmentName.text = currentAssessment?.assessmentName
        textValue.text = String(currentAssessment!.value)
        textNotes.text = currentAssessment?.notes
        textMarkAwarded.text = String(currentAssessment!.markAwarded)
        textLevel.text = String(currentAssessment!.level)
        dateDate.date = (currentAssessment!.dueDate)!


    }
    
//    var dateD:String = ""
//
//
//    let dateFormatter = DateFormatter()

//    var styledDate = dateFormatter.string(from: )
//    dateD.append(" \(styledDate)")

    //set to the labels
//    labelFirstDate.text = dateD
    
    
    @IBAction func updateAssessment(_ sender: UIButton) {
        
        
if((textModuleName.text != "") && (textAssessmentName.text != "") && (textValue.text != "") && (textNotes.text != "")) {

        currentAssessment?.moduleName = textModuleName.text
        currentAssessment?.assessmentName = textAssessmentName.text
        currentAssessment?.value = Int16(textValue.text!)!
        currentAssessment?.notes = textNotes.text
        currentAssessment?.level = Int16(textLevel.text!)!
    currentAssessment?.dueDate = dateDate.date
        currentAssessment?.markAwarded = Int16(textMarkAwarded.text!)!
    
        if switchCalendar.isOn {
            
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
                           event.title = self.textAssessmentName.text
                        event.startDate = self.dateDate.date
                        event.endDate = self.dateDate.date
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
                        }}
                       else{
                           
                           print("failed to save event with error : \(String(describing: error)) or access not granted")
                       }
                   }
            
        }
    
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
