//
//  CustomTaskTableViewCell.swift
//  coursework2
//
//  Created by Aman Benbi on 01/06/2020.
//  Copyright © 2020 Aman Benbi. All rights reserved.
//

import UIKit

class CustomTaskTableViewCell: UITableViewCell {

    @IBOutlet weak var progressView: customView!
    @IBOutlet weak var customProgressCell: UILabel!
    @IBOutlet weak var customTaskNameCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
