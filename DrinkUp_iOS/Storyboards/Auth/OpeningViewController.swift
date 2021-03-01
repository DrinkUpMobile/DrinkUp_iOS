import UIKit
import FirebaseUI

class OpeningViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func loginPressed(_ sender: UIButton){
        
        // Get default auth UI objects
        guard let authUI = FUIAuth.defaultAuthUI() else {
            return
        }
        
        // Set self as app delegate
        authUI.delegate = self
        authUI.providers = [FUIEmailAuth()]
        
        // Get reference to auth UI view controller
        let authViewController = authUI.authViewController()
        self.present(authViewController, animated: true, completion: nil)
        
    }

}

extension OpeningViewController: FUIAuthDelegate {
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if let error = error {
        print(error.localizedDescription)
        return /// Do something here... Error
    }
    
    self.dismiss(animated: true, completion: nil)
  }
    
}
