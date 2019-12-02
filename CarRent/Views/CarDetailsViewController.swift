//
//  CarDetailsViewController.swift
//  CarRent
//
//  Created by Dániel Krausz on 2019. 11. 18..
//  Copyright © 2019. Dániel Krausz. All rights reserved.
//

import UIKit
import MapKit

class CarDetailsViewController: UIViewController {
    private var car: Car?

    @IBOutlet weak var carPriceLbl: UILabel!
    @IBOutlet weak var carModelTitle: UINavigationItem!
    @IBOutlet weak var licencePlateLbl: UILabel!
    @IBOutlet weak var carColorLbl: UILabel!
    @IBOutlet weak var currentKmLbl: UILabel!
    @IBOutlet weak var engineTypeImg: UIImageView!
    @IBOutlet weak var carLocationMapView: MKMapView!
    @IBOutlet weak var stationNameLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let car = car else { fatalError("Please pass in a valid Customer object") }

        layoutCar(car: car)
    }
}

extension CarDetailsViewController {
    private func layoutCar(car: Car) {
        carPriceLbl.text = "\(car.price) HUF / day"
        carModelTitle.title = "\(car.brand) \(car.model)"
        carColorLbl.text = "\(car.color)"
        currentKmLbl.text = "\(car.currentKm) km"
        licencePlateLbl.text = "\(car.licencePlate)"
        stationNameLbl.text = "\(car.station.name)"

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
        debugPrint("\(car.station.longitude) | \(car.station.latitude)")
        let locationAnnotation = MKPointAnnotation()
        locationAnnotation.coordinate = CLLocationCoordinate2D(latitude: car.station.latitude, longitude: car.station.longitude)
        locationAnnotation.title = "\(car.brand) \(car.model)"
        carLocationMapView.addAnnotation(locationAnnotation)
        Helper.centerMapOnLocation(locationAnnotation.coordinate, mapView: carLocationMapView)

    }

    static func instantiate(car: Car) -> CarDetailsViewController {

      guard let carDetailsVC = UIStoryboard(name: "Main", bundle: nil)
        // swiftlint:disable:next line_length
        .instantiateViewController(withIdentifier: "CarDetailsViewController") as? CarDetailsViewController else { fatalError("Unexpectedly failed getting CustomerDetailsViewController from Storyboard") }

      carDetailsVC.car = car

      return carDetailsVC
    }
}
