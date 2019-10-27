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
    let provider = MoyaProvider<AdminLoginRequest>()

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
    }


    @IBAction func LoginAction(_ sender: Any) {
        
        let email = emailTextField.text
        let password = passwordTextField.text
        
        if (email == "" || password == "") {
            return
        }
        
        ExecLogin(email!, password!)
    }
    
    
    func ExecLogin(_ email: String,_ pass: String) {
        let url = NSURL(string: "https://penzfeldobas.herokuapp.com/login/admin")
        
        let request = NSMutableURLRequest(url: url! as URL)
        
        let username = email
        let password = pass
        let loginString = "\(username):\(password)"
        
        print("user: \(username)  |  password: \(password)")

        guard let loginData = loginString.data(using: String.Encoding.utf8) else {
            return
        }
        let base64LoginString = loginData.base64EncodedString()

        request.httpMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
       
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) -> Void in
            if let unwrappedData = data {
               
                do {
                    let tokenDictionary:NSDictionary = try JSONSerialization.jsonObject(with: unwrappedData, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                   
                    let token = tokenDictionary["access_token"] as? String
                }
                catch {
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                   
                    let alertView = UIAlertController(title: "Login failed",
                                                      message: "Wrong username or password." as String, preferredStyle:.alert)
                    let okAction = UIAlertAction(title: "Try Again!", style: .default, handler: nil)
                    alertView.addAction(okAction)
                    self.present(alertView, animated: true, completion: nil)
                    return
                }
            }
        }
        task.resume()

    }
}


