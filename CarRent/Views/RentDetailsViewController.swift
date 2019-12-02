//
//  RentDetailsView.swift
//  CarRent
//
//  Created by Krausz Daniel on 2019. 11. 27..
//  Copyright © 2019. Dániel Krausz. All rights reserved.
//

import UIKit
import MapKit

class RentDetailsViewController: UIViewController {
    private var rent: Rent?

    @IBOutlet weak var carNameLbl: UILabel!
    @IBOutlet weak var carStateLbl: UILabel!
    @IBOutlet weak var startStationLbl: UILabel!
    @IBOutlet weak var startDateLbl: UILabel!
    @IBOutlet weak var endStationLbl: UILabel!
    @IBOutlet weak var endDateLbl: UILabel!
    @IBOutlet weak var locDateLbl: UILabel!
    @IBAction func sendLocRequest(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let rent = rent else { fatalError("Please pass in a valid Customer object") }

        layoutRent(rent: rent)
    }
}

extension RentDetailsViewController {
    private func layoutRent(rent: Rent) {
        carNameLbl.text = "\(rent.carBrand) \(rent.carModel)"
        carStateLbl.text = rent.state
        startStationLbl.text = rent.startStationName
        endStationLbl.text = rent.endStationName
        startDateLbl.text = rent.actualStartTime
        endStationLbl.text = rent.plannedEndTime
//        locDateLbl.text = rent.positions[rent.positions.count - 1].reportedTime
    }

    static func instantiate(rent: Rent) -> RentDetailsViewController {

      guard let rentDetailsVC = UIStoryboard(name: "Main", bundle: nil)
        // swiftlint:disable:next line_length
        .instantiateViewController(withIdentifier: "RentDetailsViewController") as? RentDetailsViewController else { fatalError("Unexpectedly failed getting CustomerDetailsViewController from Storyboard") }

      rentDetailsVC.rent = rent

      return rentDetailsVC
    }
}
