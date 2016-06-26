//
//  ParallaxCell.swift
//  SBEssentialTableView
//
//  Created by Soham Bhattacharjee on 26/06/16.
//  Copyright © 2016 Soham Bhattacharjee. All rights reserved.
//

import UIKit

class ParallaxCell: UITableViewCell {

    @IBOutlet weak var lblPlace: UILabel!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var imgBackTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgBackBottomConstraint: NSLayoutConstraint!

    // Controls the parallax effect on your TableView
    let imageParallaxFactor: CGFloat = 40
    
    var imgBackTopInitial: CGFloat!
    var imgBackBottomInitial: CGFloat!
    
    var model: CellModel! {
        didSet {
            self.updateView()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.clipsToBounds = true
        self.imgBackBottomConstraint.constant -= 2 * self.imageParallaxFactor
        self.imgBackTopInitial = self.imgBackTopConstraint.constant
        self.imgBackBottomInitial = self.imgBackBottomConstraint.constant
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Setters
    func updateView() {
        self.imgBack.image = UIImage(named:self.model.imageName!)
        self.lblPlace.text = self.model.title
    }
    
    // MARK: - Parallax Cell Offset Handler
    func setBackgroundOffset(offset:CGFloat) {
        let boundOffset = max(0, min(1, offset))
        let pixelOffset = (1-boundOffset)*2*self.imageParallaxFactor
        self.imgBackTopConstraint.constant = self.imgBackTopInitial - pixelOffset
        self.imgBackBottomConstraint.constant = self.imgBackBottomInitial + pixelOffset
    }
    
}
