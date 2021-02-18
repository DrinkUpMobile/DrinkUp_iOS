//
//  LoginViewController.swift
//  DrinkUp_iOS
//
//  Created by Kristopher Jackson on 2/4/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.logInButton.layer.cornerRadius = 8
        self.logInButton.layer.masksToBounds = true
        
        self.signUpButton.layer.borderWidth = 2
        self.signUpButton.layer.cornerRadius = 8
        self.signUpButton.layer.masksToBounds = true
        self.signUpButton.layer.borderColor = Colors.main.cgColor
    
    }

}
