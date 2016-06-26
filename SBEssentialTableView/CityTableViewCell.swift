//
//  CityTableViewCell.swift
//  SBEssentialTableView
//
//  Created by Soham Bhattacharjee on 12/04/16.
//  Copyright © 2016 Soham Bhattacharjee. All rights reserved.
//

import UIKit

class CityTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCityName: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
