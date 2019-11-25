//
//  RentCell.swift
//  CarRent
//
//  Created by Dániel Krausz on 2019. 11. 25..
//  Copyright © 2019. Dániel Krausz. All rights reserved.
//

import UIKit

class RentCell: UITableViewCell {
    @IBOutlet weak var startStationNameLbl: UILabel!
    @IBOutlet weak var endDateLbl: UILabel!
    @IBOutlet weak var endStationNameLbl: UILabel!
    @IBOutlet weak var startDateLbl: UILabel!
    public static let reuseIdentifier = "RentCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    public func configureWith(rent: Rent) {
        startStationNameLbl.text = String(rent.startStationId)
        endStationNameLbl.text = String(rent.endStationId)
        startDateLbl.text = rent.actualStartTime
        endDateLbl.text = rent.actualEndTime
    }

}
