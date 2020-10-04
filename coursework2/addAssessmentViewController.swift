//
//  addAssessmentViewController.swift
//  coursework2
//
//  Created by Aman Benbi on 11/05/2020.
//  Copyright © 2020 Aman Benbi. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI
import MessageUI

class addAssessmentViewController: UIViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var mN: UITextField!
    @IBOutlet weak var aN: UITextField!
    @IBOutlet weak var level: UITextField!
    @IBOutlet weak var value: UITextField!
    @IBOutlet weak var mA: UITextField!
    @IBOutlet weak var dDate: UIDatePicker!
    @IBOutlet weak var notes: UITextField!
    @IBOutlet weak var reminder: UISwitch!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func closeKeyboard() {
        let Tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RemoveKeyboard))
        
        view.addGestureRecognizer(Tap)
    }
    
    @objc func RemoveKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentDate = NSDate()
        dDate.minimumDate = currentDate as Date
        dDate.date = currentDate as Date
        // Do any additional setup after loading the view.
        
    }
    
    
    

    @IBAction func saveButton(_ sender: Any) {
        
        let newAssessment = Assessment(context: context)
        if(((self.aN.text != "") && (self.mN.text != "") && (self.level.text != "") && (self.value.text != "") && (self.mA.text != ""))) {
            
            newAssessment.assessmentName = self.aN.text
            newAssessment.moduleName = self.mN.text
            newAssessment.level = Int16(self.level.text!)!
            newAssessment.value = Int16(self.value.text!)!
            newAssessment.notes = self.notes.text
            newAssessment.dueDate = self.dDate.date
            newAssessment.markAwarded = Int16(self.mA.text!)!
            newAssessment.firstAdded = Date()
            
            let seconds = dDate.date.timeIntervalSince(Date())
            let days = seconds/(60*60*24)
            let daysRound = round(days)
            let daysTotal = Int(daysRound)
            
            newAssessment.amountOfDays = Int16(daysTotal)
            
            if reminder.isOn {
                
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
                               event.title = self.aN.text
                            event.startDate = self.dDate.date
                            event.endDate = self.dDate.date
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
            
            let composeM = configureMailController()
            if MFMailComposeViewController.canSendMail() {
                self.present(composeM, animated: true, completion: nil)
            } else {
                showError()
            }
            
            print("Level is ", Int16(self.level.text!)!)
            
        }
        else {
            let alert = UIAlertController(title: "Missing Details", message: "Please add the relevant details...", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    

    func configureMailController() -> MFMailComposeViewController {
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients(["aman@abenbi.com"])
        mailComposeVC.setSubject("New Astronaut - Profile Attached")
        
        if let dates = self.dDate
        {
            let df = DateFormatter()
            df.dateFormat = "dd-MM-yyyy"
            let formattedDate = df.string(from: self.dDate.date)
            
            let seconds = self.dDate.date.timeIntervalSince(Date())
            let days = seconds/(60*60*24)
            
            let roundUpDays = round(days)
            let daysInBetweeen = Int(roundUpDays)
        let firstLine = "<h1>Details of Astronaut: </h1><b><h4>Name: </h4></b> " + aN.text!
        let secondLine = "<br> <br> <b><h4>Job Role: </h4></b> " + mN.text! + "<br><br> <h4><b>DNA Number: </b></h4> " + mA.text!
        let thirdLine = "<br> <br> <b><h4>Timezone (Number): </h4></b> " + value.text! + "<br><br> <h4><b>Level: </b></h4> " + level.text!
        let fourthLine = "<br> <br> <b><h4>Day: </h4></b> " + String(daysInBetweeen) + "Days Remaining..."
        mailComposeVC.setMessageBody( firstLine + secondLine + thirdLine + fourthLine, isHTML: true)
        
        }
        return mailComposeVC
    }
    
    // Function to check whether user is able to send email from the device.
    
    func showError() {
        let mailError = UIAlertController(title: "Unable to Send Email", message: "Your device is unable to send the email", preferredStyle: .alert)
        let close = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        mailError.addAction(close)
        self.present(mailError, animated: true, completion: nil)
    }
        
   
        
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
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
