//
//  OpeningViewController.swift
//  DrinkUp_iOS
//
//  Created by Kristopher Jackson on 2/23/21.
//

import UIKit
import FirebaseUI

class OpeningViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
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
        authUI?.providers = [FUIEmailAuth()]
      //get reference to auth UI view controller
      let authViewController = authUI!.authViewController()
      //show
      present(authViewController, animated: true, completion: nil)
    }

}

extension OpeningViewController: FUIAuthDelegate {
  func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?){
    if let error = error {
        print(error.localizedDescription)
        return /// DO something here. Error
    }
    
    self.dismiss(animated: true, completion: nil)
  }
}
