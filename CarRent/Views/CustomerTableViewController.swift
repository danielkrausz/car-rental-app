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

class CustomerTableViewController: UITableViewController {
    
    @IBOutlet var customerTableView: UITableView!
    @IBOutlet weak var loadMessage: UILabel!
    // MARK: - View State
    private var state: State = .loading {
      didSet {
        switch state {
        case .ready:
          loadMessage.isHidden = true
        case .loading:
          loadMessage.isHidden = false
          loadMessage.text = "Loading customers ..."
        case .error:
          loadMessage.isHidden = false
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
           return URLCredential(user: username!, password: password!, persistence: .none)
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
                debugPrint(try response.mapJSON())
                
                self.state = .ready(try response.map(CarRentServiceResponse<Customer>.self).results)
            } catch {
              self.state = .error
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
extension CustomerTableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: CustomerCell.reuseIdentifier, for: indexPath) as? CustomerCell ?? CustomerCell()

      guard case .ready(let items) = state else { return cell }

        cell.configureWith(customer: items[indexPath.item])

      return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard case .ready(let items) = state else { return 0 }

    return items.count
  }

    override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)

    guard case .ready(let items) = state else { return }
  }
}
