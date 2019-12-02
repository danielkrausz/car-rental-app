//
//  CustomerDetailsViewController.swift
//  CarRent
//
//  Created by Dániel Krausz on 2019. 11. 11..
//  Copyright © 2019. Dániel Krausz. All rights reserved.
//

import UIKit
import Foundation
import Moya
import KeychainAccess

let keychain = Keychain(service: "car-rent-cred")

let username = try? keychain.get("username")
let password = try? keychain.get("password")

public let provider = MoyaProvider<CarRentService>(plugins: [CredentialsPlugin { _ -> URLCredential? in
   return URLCredential(user: username!, password: password!, persistence: .permanent)
    }
])

class CustomerDetailsViewController: UIViewController {
    private var customer: Customer?
    var delegate: CustomarDetailDelegate?

    @IBOutlet weak var customerProfileImage: UIImageView!
    @IBOutlet weak var customerLicenceId: UILabel!
    @IBOutlet weak var drivingLicenceBackImage: UIImageView!
    @IBOutlet weak var drivingLicenceFrontImage: UIImageView!
    @IBOutlet weak var customerEnabledSwitch: UISwitch!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var customerNameNav: UINavigationItem!
    @IBOutlet weak var customerPhone: UILabel!
    @IBAction func customerSwitchClicked(_ sender: Any) {
        if customerEnabledSwitch.isOn {
            provider.request(.enable(customerId: customer!.customerId)) { [weak self] result in
              guard let self = self else { return }

              switch result {
              case .success(let response):
                    debugPrint("Customer enable")
                    debugPrint(response)
                    self.customer!.enabled = true
                    self.delegate?.updateCellWith(customer: self.customer!)
              case .failure:
                debugPrint("Enable Switch failed")
                //TODO: UI ALERT
              }
            }
        } else {
            provider.request(.disable(customerId: customer!.customerId)) { [weak self] result in
              guard let self = self else { return }

              switch result {
              case .success(let response):
                    self.customer!.enabled = false
                    debugPrint(response)
                    debugPrint("Customer disable")
                    self.delegate?.updateCellWith(customer: self.customer!)
              case .failure:
                debugPrint("Disable Switch failed")
                //TODO: UI ALERT
              }
            }

        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let customer = customer else { fatalError("Please pass in a valid Customer object") }

        layoutCustomer(customer: customer)
    }
}

protocol CustomarDetailDelegate {
    func updateCellWith(customer: Customer)
}

extension CustomerDetailsViewController {
    private func layoutCustomer(customer: Customer) {
        customerName.text = customer.firstName + " " + customer.lastName
        customerPhone.text = customer.phone
        customerNameNav.title = customer.firstName + " " + customer.lastName
        customerLicenceId.text = customer.licenceCardNumber
        if customer.enabled {
            customerEnabledSwitch.setOn(true, animated: true)
        } else {
            customerEnabledSwitch.setOn(false, animated: true)
        }

        provider.request(.image(imageId: customer.drivingLicenceFrontId)) { [weak self] result in
                      guard let self = self else { return }

                      switch result {
                      case .success(let response):
                            debugPrint(response)
                            debugPrint("Driving licence front image")
                            let image = UIImage.init(data: response.data)
                            self.drivingLicenceFrontImage.image = image
                      case .failure:
                        debugPrint("Image failed")
                        //TODO: UI ALERT
                      }
                    }

        provider.request(.image(imageId: customer.drivingLicenceBackId)) { [weak self] result in
          guard let self = self else { return }

          switch result {
          case .success(let response):
                debugPrint(response)
                debugPrint("Driving licence back image")
                let image = UIImage.init(data: response.data)
                self.drivingLicenceBackImage.image = image
          case .failure:
            debugPrint("Image failed")
            //TODO: UI ALERT
          }
        }

        provider.request(.image(imageId: customer.profileImageId)) { [weak self] result in
          guard let self = self else { return }

          switch result {
          case .success(let response):
                debugPrint(response)
                debugPrint("Profile image")
                let image = UIImage.init(data: response.data)
                self.customerProfileImage.image = image
          case .failure:
            debugPrint("Image failed")
            //TODO: UI ALERT
          }
        }

    }

    static func instantiate(customer: Customer) -> CustomerDetailsViewController {

      guard let vc = UIStoryboard(name: "Main", bundle: nil)
        // swiftlint:disable:next line_length
        .instantiateViewController(withIdentifier: "CustomerDetailsViewController") as? CustomerDetailsViewController else { fatalError("Unexpectedly failed getting CustomerDetailsViewController from Storyboard") }

      vc.customer = customer

      return vc
    }

}
