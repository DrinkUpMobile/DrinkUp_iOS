//
//  ViewController.swift
//  DrinkUp_iOS
//
//  Created by Kristopher Jackson on 1/28/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /// API Check firebase to see if user is signed in
        
        
//        if !signedIn {
        
        /// Transition to log in page
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true, completion: nil)
        return
        
//        }
        
        
        
    }


}

