//
//  CustomAssessmentTableViewCell.swift
//  coursework2
//
//  Created by Aman Benbi on 01/06/2020.
//  Copyright © 2020 Aman Benbi. All rights reserved.
//

import UIKit

class CustomAssessmentTableViewCell: UITableViewCell {
    @IBOutlet weak var assessmentNameLabel: UILabel!
    @IBOutlet weak var moduleNameLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
