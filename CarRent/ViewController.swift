//
//  ViewController.swift
//  CarRent
//
//  Created by Dániel Krausz on 2019. 10. 21..
//  Copyright © 2019. Dániel Krausz. All rights reserved.
//

import UIKit
import Moya

class ViewController: UIViewController {
    let provider = MoyaProvider<CarRentService>()

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func showAlertButtonTapped(_ responseMessage : String) {

        let alert = UIAlertController(title: "HTTP Response", message: responseMessage, preferredStyle: .alert)

                let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
                })
                alert.addAction(ok)
                let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { action in
                })
                alert.addAction(cancel)
                DispatchQueue.main.async(execute: {
                   self.present(alert, animated: true)
           })

       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }


    @IBAction func LoginAction(_ sender: Any) {
        let user = emailTextField.text
        let password = passwordTextField.text

        
        
        let provider = MoyaProvider<CarRentService>(plugins: [CredentialsPlugin { _ -> URLCredential? in
            return URLCredential(user: user!, password: password!, persistence: .none)
          }
        ])
        
       provider.request(.login) { result in
           switch result {
           case let .success(moyaResponse):
               let data = moyaResponse.data // Data, your JSON response is probably in here!
               let statusCode = moyaResponse.statusCode // Int - 200, 401, 500, etc
               
                let avc = UIAlertController(
                  title: "Login",
                  message: String(statusCode),
                  preferredStyle: .alert
                )
            
               self.present(avc, animated: true, completion: nil)

               // do something in your app
           case let .failure(error):
                print("error")
                
        }
       }
    }
    
}


