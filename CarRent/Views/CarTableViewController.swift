//
//  CarTableViewController.swift
//  CarRent
//
//  Created by Dániel Krausz on 2019. 10. 27..
//  Copyright © 2019. Dániel Krausz. All rights reserved.
//

import UIKit
import Moya
import KeychainAccess

class CarTableViewController: UIViewController {

    var refreshControl = UIRefreshControl()

    @IBOutlet weak var carTableView: UITableView!
    @IBOutlet weak var loadMessage: UILabel!
    @IBOutlet weak var loadMessageContainer: UIView!
    // MARK: - View State
    private var state: State = .loading {
      didSet {
        switch state {
        case .ready:
          loadMessageContainer.isHidden = true
          carTableView.reloadData()
        case .loading:
          loadMessageContainer.isHidden = false
          loadMessage.text = "Loading cars ..."
        case .error:
          loadMessageContainer.isHidden = false
          loadMessage.text = """
                              Something went wrong!
                              Try again later.
                            """
        }
      }
    }

    @objc func refresh(sender: AnyObject) {
        provider.request(.cars) { [weak self] result in
          guard let self = self else { return }

          switch result {
          case .success(let response):
            do {
                let string1 = String(data: response.data, encoding: String.Encoding.utf8) ?? "Data could not be printed"
                self.loadMessage.text = string1

                self.state = .ready(try JSONDecoder().decode([Car].self, from: response.data))

            } catch {
              self.state = .error
                debugPrint(error)
            }
          case .failure:
            self.state = .error
          }
        }
        carTableView.reloadData()
        refreshControl.endRefreshing()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        carTableView.addSubview(refreshControl)

        let keychain = Keychain(service: "car-rent-cred")

        let username = try? keychain.get("username")
        let password = try? keychain.get("password")
        let provider = MoyaProvider<CarRentService>(plugins: [CredentialsPlugin { _ -> URLCredential? in
           return URLCredential(user: username!, password: password!, persistence: .none)
            }
        ])

        state = .loading

        provider.request(.carStates) { [weak self] result in
          guard let self = self else { return }

          switch result {
          case .success(let response):
            do {
                let defaults = UserDefaults.standard
                let carStates = try JSONDecoder().decode([String].self, from: response.data)
                defaults.set(carStates, forKey: "CarStates")

            } catch {
              self.state = .error
                debugPrint(error)
            }
          case .failure:
            self.state = .error
          }
        }

        provider.request(.cars) { [weak self] result in
          guard let self = self else { return }

          switch result {
          case .success(let response):
            do {
                self.state = .ready(try JSONDecoder().decode([Car].self, from: response.data))
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

extension CarTableViewController {
  enum State {
    case loading
    case ready([Car])
    case error
  }
}

// MARK: - UITableView Delegate & Data Source
extension CarTableViewController: UITableViewDelegate, UITableViewDataSource {
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CarCell.reuseIdentifier, for: indexPath) as? CarCell ?? CarCell()

    guard case .ready(let items) = state else { return cell }

    cell.configureWith(car: items[indexPath.item])

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

    let carDetailsVC = CarDetailsViewController.instantiate(car: items[indexPath.item])
    navigationController?.pushViewController(carDetailsVC, animated: true)
  }
}
