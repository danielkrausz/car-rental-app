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

    var carRegistrationFormData: [String: String] = [:]
    var stationPicker = UIPickerView()
    var carStatePicker = UIPickerView()

    let stationList = [String](arrayLiteral: "Station 1", "Station 2", "Station 3")
    var carStatesList = [String]()

    @IBOutlet weak var carPriceLbl: UILabel!
    @IBOutlet weak var carModelTitle: UINavigationItem!
    @IBOutlet weak var licencePlateLbl: UILabel!
    @IBOutlet weak var carColorLbl: UILabel!
    @IBOutlet weak var currentKmLbl: UILabel!
    @IBOutlet weak var engineTypeImg: UIImageView!
    @IBOutlet weak var carLocationMapView: MKMapView!
    @IBOutlet weak var stationNameLbl: UITextField!
    @IBOutlet weak var carStateLbl: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = UserDefaults.standard
        carStatesList = defaults.object(forKey: "CarStates") as? [String] ?? [String]()

        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        //Init picker views
        stationNameLbl.inputView = stationPicker
        carStateLbl.inputView = carStatePicker
        stationPicker.delegate = self
        carStatePicker.delegate = self

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
        carStateLbl.text = "\(car.state)"

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

extension CarDetailsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == stationPicker {
            return stationList.count
        } else if pickerView == carStatePicker {
            return carStatesList.count
        }
        return -1
    }

    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == stationPicker {
            return stationList[row]
        } else if pickerView == carStatePicker {
            return carStatesList[row]
        }
        return "Error"
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == stationPicker {
             stationNameLbl.text = stationList[row]
            carRegistrationFormData["stationId"] = String(pickerView.selectedRow(inComponent: 0))
        } else if pickerView == carStatePicker {
            carStateLbl.text = carStatesList[row]
            carRegistrationFormData["state"] = carStatesList[row]
        }
    }
}
