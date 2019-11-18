//
//  CarDetailsViewController.swift
//  CarRent
//
//  Created by Dániel Krausz on 2019. 11. 18..
//  Copyright © 2019. Dániel Krausz. All rights reserved.
//

import UIKit
import Foundation
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
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let car = car else { fatalError("Please pass in a valid Customer object") }

        layoutCar(car: car)
        
        // Do any additional setup after loading the view.
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

extension CarDetailsViewController {
    private func layoutCar(car: Car) {
        carPriceLbl.text = "\(car.price) HUF / day"
        carModelTitle.title = "\(car.brand) \(car.model)"
        carColorLbl.text = "\(car.color)"
        currentKmLbl.text = "\(car.currentKm) km"
        licencePlateLbl.text = "\(car.licencePlate)"
        
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
        locationAnnotation.coordinate = CLLocationCoordinate2D(latitude: car.station.longitude, longitude: car.station.latitude)
        locationAnnotation.title = "\(car.brand) \(car.model)"
        carLocationMapView.addAnnotation(locationAnnotation)
        centerMapOnLocation(locationAnnotation.coordinate, mapView: carLocationMapView)
        

    }

    static func instantiate(car: Car) -> CarDetailsViewController {

      guard let carDetailsVC = UIStoryboard(name: "Main", bundle: nil)
        // swiftlint:disable:next line_length
        .instantiateViewController(withIdentifier: "CarDetailsViewController") as? CarDetailsViewController else { fatalError("Unexpectedly failed getting CustomerDetailsViewController from Storyboard") }

      carDetailsVC.car = car

      return carDetailsVC
    }
    
    func centerMapOnLocation(_ location: CLLocationCoordinate2D, mapView: MKMapView) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: location,
                                                  latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }

}


