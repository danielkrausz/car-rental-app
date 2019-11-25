//
//  RentTableViewController.swift
//  rentRent
//
//  Created by Dániel Krausz on 2019. 11. 25..
//  Copyright © 2019. Dániel Krausz. All rights reserved.
//

import UIKit
import Moya
import Foundation
import KeychainAccess

class RentTableViewController: UIViewController {
    var rentRefreshControl = UIRefreshControl()
    
    @IBOutlet var rentTableView: UITableView!
    @IBOutlet weak var loadMessage: UILabel!
    @IBOutlet weak var loadMessageContainer: UIView!
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
        provider.request(.unclosedRents) { [weak self] result in
          guard let self = self else { return }

          switch result {
          case .success(let response):
            do {
                let string1 = String(data: response.data, encoding: String.Encoding.utf8) ?? "Data could not be printed"
                self.loadMessage.text = string1

                self.state = .ready(try JSONDecoder().decode([Rent].self, from: response.data))

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
        
        rentRefreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        rentRefreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        rentTableView.addSubview(rentRefreshControl)

        state = .loading

        provider.request(.unclosedRents) { [weak self] result in
          guard let self = self else { return }

          switch result {
          case .success(let response):
            do {
                let string1 = String(data: response.data, encoding: String.Encoding.utf8) ?? "Data could not be printed"
                self.loadMessage.text = string1
                let rentList = try JSONDecoder().decode([Rent].self, from: response.data)
                debugPrint("Rent list size: \(rentList.count)")
                self.state = .ready(try JSONDecoder().decode([Rent].self, from: response.data))

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

extension RentTableViewController {
  enum State {
    case loading
    case ready([Rent])
    case error
  }
}

// MARK: - UITableView Delegate & Data Source
extension RentTableViewController: UITableViewDelegate, UITableViewDataSource {
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: RentCell.reuseIdentifier, for: indexPath) as? RentCell ?? RentCell()

    guard case .ready(let items) = state else { return cell }

    cell.configureWith(rent: items[indexPath.item])

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

//    let rentDetailsVC = rentDetailsViewController.instantiate(rent: items[indexPath.item])
//    navigationController?.pushViewController(rentDetailsVC, animated: true)
  }
}
