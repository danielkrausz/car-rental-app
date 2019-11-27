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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
