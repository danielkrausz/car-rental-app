//
//  CarRegisterViewController.swift
//  CarRent
//
//  Created by Dániel Krausz on 2019. 11. 20..
//  Copyright © 2019. Dániel Krausz. All rights reserved.
//

import UIKit

class CarRegisterViewController: UIViewController {
    var carRegistrationFormData: [String: Any] = [:]
    var stationPicker = UIPickerView()
    var engineTypePicker = UIPickerView()

    let stationList = [String](arrayLiteral: "Station 1", "Station 2", "Station 3")
    let engineTypeList = [String](arrayLiteral: "DIESEL", "ELECTRIC", "BENZINE")
    @IBOutlet weak var stationTextField: UITextField!
    @IBOutlet weak var mileageTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var licencePlateTextField: UITextField!
    @IBOutlet weak var colorTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var engineTypeTextField: UITextField!
    @IBAction func cancelCarRegister(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func saveCarRegistration(_ sender: Any) {
        carRegistrationFormData["brand"] = brandTextField.text
        carRegistrationFormData["model"] = modelTextField.text
        carRegistrationFormData["color"] = colorTextField.text
        carRegistrationFormData["kmHour"] = mileageTextField.text
        carRegistrationFormData["price"] = priceTextField.text
        carRegistrationFormData["licencePlate"] = licencePlateTextField.text
        debugPrint(carRegistrationFormData)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //Hide keyboard on tap
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        //Init picker views
        stationTextField.inputView = stationPicker
        engineTypeTextField.inputView = engineTypePicker
        stationPicker.delegate = self
        engineTypePicker.delegate = self
    }
}

extension CarRegisterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == stationPicker {
            return stationList.count
        } else if pickerView == engineTypePicker {
            return engineTypeList.count
        }
        return -1
    }

    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == stationPicker {
            return stationList[row]
        } else if pickerView == engineTypePicker {
            return engineTypeList[row]
        }
        return "Error"
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == stationPicker {
             stationTextField.text = stationList[row]
            carRegistrationFormData["stationId"] = pickerView.selectedRow(inComponent: 0)
        } else if pickerView == engineTypePicker {
            engineTypeTextField.text = engineTypeList[row]
            carRegistrationFormData["engineType"] = engineTypeList[row]
        }
    }
}
