//
//  CustomerTableViewController.swift
//  CarRent
//
//  Created by Dániel Krausz on 2019. 10. 27..
//  Copyright © 2019. Dániel Krausz. All rights reserved.
//

import UIKit
import Foundation
import Moya
import KeychainAccess

class CustomerTableViewController: UIViewController {

    enum CustomerTableSection: Int {
        case pending = 0, enabled
    }

    let sectionHeaderHight: CGFloat = 25

    var customerData = [CustomerTableSection: [[String: String]]]()

//    func sortCustomers() {
//        customerData[.pending] = [Customer].filter({$0.enabled == true})
//    }

    @IBAction func logoutAction(_ sender: UIBarButtonItem) {
        let keychain = Keychain(service: "car-rent-cred")

        do {
            try keychain.remove("username")
        } catch let error {
            print("error: \(error)")
        }

        do {
            try keychain.remove("password")
        } catch let error {
            print("error: \(error)")
        }

        self.performSegue(withIdentifier: "logoutSegue", sender: self)

    }
    @IBOutlet weak var customerTableView: UITableView!
    @IBOutlet weak var loadMessage: UILabel!
    @IBOutlet weak var loadMessageContainer: UIView!
    // MARK: - View State
    private var state: State = .loading {
      didSet {
        switch state {
        case .ready:
          loadMessageContainer.isHidden = true
          customerTableView.reloadData()
        case .loading:
          loadMessageContainer.isHidden = false
          loadMessage.text = "Loading customers ..."
        case .error:
          loadMessageContainer.isHidden = false
          loadMessage.text = """
                              Something went wrong!
                              Try again later.
                            """
        }
      }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let keychain = Keychain(service: "car-rent-cred")

        let username = try? keychain.get("username")
        let password = try? keychain.get("password")
        let provider = MoyaProvider<CarRentService>(plugins: [CredentialsPlugin { _ -> URLCredential? in
           return URLCredential(user: username!, password: password!, persistence: .permanent)
            }
        ])

        state = .loading

        provider.request(.customers) { [weak self] result in
          guard let self = self else { return }

          switch result {
          case .success(let response):
            do {
                let string1 = String(data: response.data, encoding: String.Encoding.utf8) ?? "Data could not be printed"
                self.loadMessage.text = string1

                self.state = .ready(try JSONDecoder().decode([Customer].self, from: response.data))

            } catch {
              self.state = .error
                debugPrint(error)
            }
          case .failure:
            self.state = .error
          }
        }
    }
}

extension CustomerTableViewController {
  enum State {
    case loading
    case ready([Customer])
    case error
  }
}

// MARK: - UITableView Delegate & Data Source
extension CustomerTableViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CustomerCell.reuseIdentifier, for: indexPath) as? CustomerCell ?? CustomerCell()

    guard case .ready(let items) = state else { return cell }

    cell.configureWith(customer: items[indexPath.item])

    return cell
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard case .ready(let items) = state else { return 0 }

    return items.count
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)

    guard case .ready(let items) = state else { return }

    let customerDetaislVC = CustomerDetailsViewController.instantiate(customer: items[indexPath.item])
    navigationController?.pushViewController(customerDetaislVC, animated: true)
  }
}
