//
//  CarCell.swift
//  CarRent
//
//  Created by Dániel Krausz on 2019. 11. 18..
//  Copyright © 2019. Dániel Krausz. All rights reserved.
//

import UIKit

class CarCell: UITableViewCell {
    @IBOutlet weak var carModelLbl: UILabel!
    @IBOutlet weak var currentKmLbl: UILabel!
    @IBOutlet weak var carColorLbl: UILabel!
    @IBOutlet weak var engineTypeImg: UIImageView!
    public static let reuseIdentifier = "CarCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    public func configureWith(car: Car) {
        carModelLbl.text = "\(car.brand) \(car.model)"
        carColorLbl.text = "\(car.color)"
        currentKmLbl.text = "\(car.currentKm)"
        switch car.engineType {
        case "ELECTRIC":
            engineTypeImg.image = UIImage(named: "electric")
        case "DIESEL":
            engineTypeImg.image = UIImage(named: "diesel")
        case "BENZINE":
            engineTypeImg.image = UIImage(named: "benzin")
        default:
            engineTypeImg.image = UIImage(named: "unknown")
        }

    }

}
