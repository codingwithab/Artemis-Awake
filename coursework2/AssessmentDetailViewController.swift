//
//  AssessmentDetailViewController.swift
//  coursework2
//
//  Created by Aman Benbi on 11/05/2020.
//  Copyright © 2020 Aman Benbi. All rights reserved.
//

import UIKit

class AssessmentDetailViewController: UIViewController {
    @IBOutlet weak var aN: UILabel!
    @IBOutlet weak var mN: UILabel!
    @IBOutlet weak var levelL: UILabel!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var due: UILabel!
    @IBOutlet weak var notes: UILabel!
    @IBOutlet weak var markAt: UILabel!
    @IBOutlet weak var pieProgressDays: UIView!
    
    var textAN = ""
    var textmN = ""
    var textlevelL = ""
    var textValue = ""
    var textDue = 0
    var textNotes = ""
    var markAwardText = ""
    var amountOfDays = 0
    var assessment:Assessment?
    

    let PieChartView = pieChartView() 
    override func viewDidLoad() {
        super.viewDidLoad()
        aN.text = textAN
        mN.text = textmN
        levelL.text = textlevelL
        markAt.text = markAwardText
        value.text = textValue
        due.text = String(textDue) + " Days Remaining"
        notes.text = textNotes

        
        
        let daysSinceAdded = CGFloat(amountOfDays)
        let daysLapsed = CGFloat(amountOfDays - textDue)
        let daysRemaining = CGFloat(textDue)


        print (daysSinceAdded)
        print (daysLapsed)
        print (textDue)

        
        let padding: CGFloat = 20
        let height = (pieProgressDays.frame.height)

        PieChartView.frame = CGRect(
          x: 0, y:0,
          width: view.frame.size.width, height: height
        )

        PieChartView.segments = [
          Segment(color: .red,   value:daysLapsed),
          Segment(color: .green,    value: daysRemaining),

        ]
            pieProgressDays.addSubview(PieChartView)
        
        
        
        // Do any additional setup after loading the view.
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
