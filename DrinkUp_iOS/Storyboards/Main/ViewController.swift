//
//  ViewController.swift
//  DrinkUp_iOS
//
//  Created by Kristopher Jackson on 1/28/21.
//

import UIKit
import FirebaseAuthUI

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

    @IBAction func loginPressed(_ sender: UIButton){
      //get default auth UI objects
      let authUI = FUIAuth.defaultAuthUI()
      guard authUI != nil else {
        //default auth ui init failed
        return
      }
      //set self as app delegate
      authUI?.delegate = self
      //get reference to auth UI view controller
      let authViewController = authUI!.authViewController()
      //show
      present(authViewController, animated: true, completion: nil)
    }

}

extension ViewController: FUIAuthDelegate {
  func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?){
    //check for Error
    guard error == nil else{
      return
    }

    //how to get userid from authDataResult: authDataResult?.user.uid
    performSegue(withIdentifier: "idk", sender: self)
  }
}
