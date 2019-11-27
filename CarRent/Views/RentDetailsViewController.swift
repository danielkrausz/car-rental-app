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

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let rent = rent else { fatalError("Please pass in a valid Customer object") }

        layoutRent(rent: rent)
    }
}

extension RentDetailsViewController {
    private func layoutRent(rent: Rent) {

    }

    static func instantiate(rent: Rent) -> RentDetailsViewController {

      guard let rentDetailsVC = UIStoryboard(name: "Main", bundle: nil)
        // swiftlint:disable:next line_length
        .instantiateViewController(withIdentifier: "RentDetailsView") as? RentDetailsViewController else { fatalError("Unexpectedly failed getting CustomerDetailsViewController from Storyboard") }

      rentDetailsVC.rent = rent

      return rentDetailsVC
    }
}
