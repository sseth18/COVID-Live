//
//  LocationTableViewCell.swift
//  COVID-Live
//
//  Created by Samar Seth on 5/20/20.
//  Copyright © 2020 Samar Seth. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    @IBOutlet var country: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
