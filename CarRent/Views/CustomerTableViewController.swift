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

class CustomerTableViewController: UITableViewController {
    
    let provider = MoyaProvider<CarRentService>(plugins: [CredentialsPlugin { _ -> URLCredential? in
        return URLCredential(user: "admin", password: "admin", persistence: .none)
      }
    ])
    
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
        
        state = .loading

        provider.request(.customers) { [weak self] result in
          guard let self = self else { return }

          switch result {
          case .success(let response):
            do {
              self.state = .ready(try response.map(CarRentServiceResponse<Customer>.self).data.results)
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
