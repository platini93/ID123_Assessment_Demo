//
//  RestaurantsTableViewCell.swift
//  SIAssessmentDemo
//
//  Created by Gourav Ray on 5/24/23.
//

import UIKit

class RestaurantsTableViewCell: UITableViewCell {

    @IBOutlet weak var restImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var ratingsLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var currentlyOpenLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
