//
//  LoginViewController.swift
//  DrinkUp_iOS
//
//  Created by Kristopher Jackson on 2/4/21.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.email.keyboardType = .emailAddress /// Special keyboard for email
        self.email.font = .systemFont(ofSize: 16)
        self.email.placeholder = "Type email address..."
        
        self.password.font = .systemFont(ofSize: 16)
        self.password.isSecureTextEntry = true /// hides text when user types password. Shows this: "•••••••"
        self.password.placeholder = "Type password address..."
        
        self.button.layer.cornerRadius = 8 /// Rounded corners
        self.button.backgroundColor = .gray
        self.button.setTitle("Click me", for: .normal)
        self.button.titleLabel?.font = .boldSystemFont(ofSize: 16)
    
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        print("Clicked")
    }

}
