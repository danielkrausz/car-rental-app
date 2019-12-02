//
//  RentTableViewController.swift
//  rentRent
//
//  Created by Dániel Krausz on 2019. 11. 25..
//  Copyright © 2019. Dániel Krausz. All rights reserved.
//

import UIKit
import Moya
import KeychainAccess

class RentTableViewController: UIViewController {
    var loadRentsIndicator = LoadIndicator()
    var rentTableSectionHeaders = ["Unclosed rents", "Active rents"]
    var rentItems: [[Rent]] = [[], []]
    //Connect storyboard UI components
    @IBOutlet var rentTableView: UITableView!
    @IBOutlet weak var loadMessage: UILabel!
    @IBOutlet weak var loadMessageContainer: UIView!
    //Custom refresh control
    var rentRefreshControl = UIRefreshControl()
    // MARK: - View State
    private var state: State = .loading {
      didSet {
        switch state {
        case .ready:
            loadMessageContainer.isHidden = true
            rentTableView.reloadData()
        case .loading:
              loadMessageContainer.isHidden = false
              loadMessage.text = "Loading rents ..."
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
//        rentItems.removeAll(keepingCapacity: true)
        rentItems[0].removeAll(keepingCapacity: false)
        rentItems[1].removeAll(keepingCapacity: false)
        provider.request(.unclosedRents) { [weak self] result in
          guard let self = self else { return }

          switch result {
          case .success(let response):
            do {
                let unclosedRents = try JSONDecoder().decode([Rent].self, from: response.data)
                for rentItem in unclosedRents {
                    self.rentItems[0].append(rentItem)
                }
                self.state = .ready
            } catch {
                self.state = .error
                debugPrint(error)
            }
          case .failure:
            self.state = .error
          }
        }

        provider.request(.activeRents) { [weak self] result in
          guard let self = self else { return }

          switch result {
          case .success(let response):
            do {
                let activeRents = try JSONDecoder().decode([Rent].self, from: response.data)
                for rentItem in activeRents {
                    self.rentItems[1].append(rentItem)
                }
                self.state = .ready
            } catch {
                self.state = .error
                debugPrint(error)
            }
          case .failure:
            self.state = .error
          }
        }

        rentTableView.reloadData()
        rentRefreshControl.endRefreshing()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        rentTableView.delegate = self
        rentTableView.dataSource = self

        rentRefreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        rentRefreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        rentTableView.addSubview(rentRefreshControl)

        state = .loading

        let keychain = Keychain(service: "car-rent-cred")

        let username = try? keychain.get("username")
        let password = try? keychain.get("password")
        let provider = MoyaProvider<CarRentService>(plugins: [CredentialsPlugin { _ -> URLCredential? in
           return URLCredential(user: username!, password: password!, persistence: .none)
            }
        ])
        loadRentsIndicator.displayActivityIndicatorAlert()
        provider.request(.unclosedRents) { [weak self] result in
          guard let self = self else { return }

          switch result {
          case .success(let response):
            do {
                let unclosedRents = try JSONDecoder().decode([Rent].self, from: response.data)
                for rentItem in unclosedRents {
                    self.rentItems[0].append(rentItem)
                }
                self.state = .ready
            } catch {
              self.state = .error
                debugPrint(error)
            }
          case .failure:
            self.state = .error
          }
        }

        provider.request(.activeRents) { [weak self] result in
          guard let self = self else { return }

          switch result {
          case .success(let response):
            do {
                let activeRents = try JSONDecoder().decode([Rent].self, from: response.data)
                for rentItem in activeRents {
                    self.rentItems[1].append(rentItem)
                }
                self.state = .ready
            } catch {
              self.state = .error
                debugPrint(error)
            }
          case .failure:
            self.state = .error
          }
        }
        loadRentsIndicator.dismissActivityIndicatorAlert()
    }
}

extension RentTableViewController {
  enum State {
    case loading
    case ready
    case error
  }
}

// MARK: - UITableView Delegate & Data Source
extension RentTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: RentCell.reuseIdentifier, for: indexPath) as? RentCell ?? RentCell()

    guard case .ready = state else { return cell }

        cell.configureWith(rent: rentItems[indexPath.section][indexPath.item])
    return cell
  }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard case .ready = state else { return 0 }
        return rentItems[section].count
  }

    func numberOfSections(in tableView: UITableView) -> Int {
        return rentTableSectionHeaders.count
  }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)

        guard case .ready = state else { return }

        let rentDetailsVC = RentDetailsViewController.instantiate(rent: rentItems[indexPath.section][indexPath.item])
    navigationController?.pushViewController(rentDetailsVC, animated: true)
  }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let sectionHeader = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 22))
        sectionHeader.backgroundColor = .gray
            let sectionText = UILabel()
            sectionText.frame = CGRect.init(x: 5, y: 5, width: sectionHeader.frame.width-10, height: sectionHeader.frame.height-10)
            sectionText.text = rentTableSectionHeaders[section]
            sectionText.font = .systemFont(ofSize: 14, weight: .bold) // my custom font
        sectionText.textColor = .white // my custom colour

            sectionHeader.addSubview(sectionText)

            return sectionHeader
        }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 22 // my custom height
        }
}
