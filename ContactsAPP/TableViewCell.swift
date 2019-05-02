//
//  TableViewCell.swift
//  ContactsAPP
//
//  Created by Murali on 5/2/19.
//  Copyright © 2019 Murali. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet var displayImage: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var mobileNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        displayImage.layer.cornerRadius = displayImage.bounds.height/2
        displayImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
