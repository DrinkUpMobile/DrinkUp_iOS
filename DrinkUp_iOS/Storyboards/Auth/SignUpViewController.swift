//
//  SignUpViewController.swift
//  DrinkUp_iOS
//
//  Created by Kristopher Jackson on 2/11/21.
//

import UIKit
import Firebase

struct UserInfo {
    var email: String!
    var firstName: String!
    var lastName: String!
}

class SignUpViewController: UIViewController {
    
    static let storyboardID = "SignUpViewController"
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        if let email = emailTextField.text,
           let password = passwordTextField.text,
           let confirm = confirmPasswordTextField.text {
            
            if password != confirm {
                self.messageLabel.text = "Passwords are not equal"
                self.messageLabel.textColor = .systemRed
                return
            }
            
            FirebaseAuthManager.createUser(email: email, password: password) { (success, error) in
                if success {
                    let user = UserInfo(email: email, firstName: "Kris", lastName: "Jackson")
                    
                    let db = Firestore.firestore()
                    db.collection("users").document(Auth.auth().currentUser!.uid).setData([
                        "email" : user.email as Any,
                        "firstName": user.firstName as Any,
                        "lastName": user.lastName as Any
                    ])
                
                } else {
                    
                    self.messageLabel.text = error?.localizedDescription ?? "Error"
                    self.messageLabel.textColor = .systemRed
                    
                }
                
            }
            
        }
    }
}
