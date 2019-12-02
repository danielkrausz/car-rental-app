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
    @IBOutlet weak var acceptRentBtn: UIButton!
    @IBOutlet weak var requestLocBtn: UIButton!
    @IBOutlet weak var locDateLbl: UILabel!
    @IBOutlet weak var rentLocMapView: MKMapView!
    @IBAction func acceptRentClosure(_ sender: Any) {
        provider.request(.requestPosition(rentId: rent!.rentId)) { [weak self] result in
          guard let self = self else { return }

          switch result {
          case .success(let response):
                 // create the alert
            debugPrint("Rent successfully closed")
                       let alert = UIAlertController(title: "Rent successfully closed", message: "", preferredStyle: UIAlertController.Style.alert)

                       // add an action (button)
                       alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                       // show the alert
                       self.present(alert, animated: true, completion: nil)
          case .failure:
            let alert = UIAlertController(title: "Rent closing failed", message: "Try again", preferredStyle: UIAlertController.Style.alert)

            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

            // show the alert
            self.present(alert, animated: true, completion: nil)
            debugPrint("Request failed")
          }
        }
    }
    @IBAction func sendLocRequest(_ sender: Any) {
        provider.request(.requestPosition(rentId: rent!.rentId)) { [weak self] result in
          guard let self = self else { return }

          switch result {
          case .success(let response):
                 // create the alert
            debugPrint("Location request sent")
                       let alert = UIAlertController(title: "Location request sent", message: "Waiting for user's location.", preferredStyle: UIAlertController.Style.alert)

                       // add an action (button)
                       alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                       // show the alert
                       self.present(alert, animated: true, completion: nil)
          case .failure:
            let alert = UIAlertController(title: "Location request failed", message: "Try again", preferredStyle: UIAlertController.Style.alert)

            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

            // show the alert
            self.present(alert, animated: true, completion: nil)
            debugPrint("Request failed")
          }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let rent = rent else { fatalError("Please pass in a valid Customer object") }

        layoutRent(rent: rent)
    }
}

extension RentDetailsViewController {
    private func layoutRent(rent: Rent) {
        if rent.state == "UNCLOSED" {
            requestLocBtn.isHidden = true
            rentLocMapView.isHidden = true
        } else {
            acceptRentBtn.isHidden = true
            let locationAnnotation = MKPointAnnotation()
            let positionListSize = rent.positions!.count - 1 ?? 0
            locationAnnotation.coordinate = CLLocationCoordinate2D(latitude: (rent.positions?[positionListSize].latitude)!, longitude: (rent.positions?[positionListSize].longitude)!)
            locationAnnotation.title = "\(rent.carBrand) \(rent.carModel)"
            rentLocMapView.addAnnotation(locationAnnotation)
            Helper.centerMapOnLocation(locationAnnotation.coordinate, mapView: rentLocMapView)
        }

        carNameLbl.text = "\(rent.carBrand) \(rent.carModel)"
        carStateLbl.text = rent.state
        startStationLbl.text = rent.startStationName
        endStationLbl.text = rent.endStationName
        startDateLbl.text = rent.actualStartTime
        endStationLbl.text = rent.plannedEndTime
        locDateLbl.text = rent.positions?[(rent.positions?.count ?? 0) - 1].reportedTime
    }

    static func instantiate(rent: Rent) -> RentDetailsViewController {

      guard let rentDetailsVC = UIStoryboard(name: "Main", bundle: nil)
        // swiftlint:disable:next line_length
        .instantiateViewController(withIdentifier: "RentDetailsViewController") as? RentDetailsViewController else { fatalError("Unexpectedly failed getting CustomerDetailsViewController from Storyboard") }

      rentDetailsVC.rent = rent

      return rentDetailsVC
    }
}
