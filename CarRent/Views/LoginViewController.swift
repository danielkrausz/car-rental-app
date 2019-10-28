//
//  ViewController.swift
//  CarRent
//
//  Created by Dániel Krausz on 2019. 10. 21..
//  Copyright © 2019. Dániel Krausz. All rights reserved.
//

import UIKit
import Moya
import KeychainAccess

class LoginViewController: UIViewController {
    let provider = MoyaProvider<CarRentService>()

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    func displayLoginPendingAlert() -> UIAlertController {
            //create an alert controller
        let pending = UIAlertController(title: "Logging in...", message: nil, preferredStyle: .alert)

            //create an activity indicator
            let indicator = UIActivityIndicatorView(frame: pending.view.bounds)
            indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            //add the activity indicator as a subview of the alert controller's view
            pending.view.addSubview(indicator)
            indicator.isUserInteractionEnabled = false // required otherwise if there buttons in the UIAlertController you will not be able to press them
            indicator.startAnimating()

        self.present(pending, animated: true, completion: nil)

            return pending
    }

    @IBAction func loginAction(_ sender: Any) {

        let user = emailTextField.text
        let password = passwordTextField.text

        if (user ?? "").isEmpty || (password ?? "").isEmpty {
            return
            //TODO Better error handling
        }

        let loadingLogin = displayLoginPendingAlert()

        let provider = MoyaProvider<CarRentService>(plugins: [CredentialsPlugin { _ -> URLCredential? in
            return URLCredential(user: user!, password: password!, persistence: .none)
          }
        ])

       provider.request(.login) { result in
           switch result {
           case let .success(moyaResponse):
               let data = moyaResponse.data // Data, your JSON response is probably in here!
               let statusCode = moyaResponse.statusCode // Int - 200, 401, 500, etc

//                let avc = UIAlertController(
//                  title: "Login",
//                  message: String(statusCode),
//                  preferredStyle: .alert
//                )
               let keychain = Keychain(service: "car-rent-cred")

               do {
                try keychain.set(user!, key: "username")
               } catch let error {
                   print(error)
               }

               do {
                try keychain.set(password!, key: "password")
               } catch let error {
                   print(error)
               }
               self.performSegue(withIdentifier: "loginSegue", sender: self)
               // do something in your app
           case let .failure(error):
            loadingLogin.dismiss(animated: true, completion: nil)
            let alert = UIAlertController(title: "Login failed", message: "Wrong username or password.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)

        }
       }
    }

}
