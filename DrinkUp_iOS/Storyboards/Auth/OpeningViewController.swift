



import UIKit
import FirebaseUI

class OpeningViewController: UIViewController {
    
    
    @IBOutlet weak var mainLabel: UILabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainLabel.text = "Hydrate.\nHealthy.\nHappy."
        self.mainLabel.font = .systemFont(ofSize: 50, weight: .heavy)
        self.view.setVerticalGradientBackground(topColor: #colorLiteral(red: 0.2666666667, green: 0.6340025601, blue: 1, alpha: 1), bottomColor: #colorLiteral(red: 0.2666666667, green: 0.374138948, blue: 1, alpha: 1))
        
        /// Enables 'slide to dismiss' for views added to stack
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: SignUpViewController.storyboardID)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    @IBAction func logInPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: LoginViewController.storyboardID)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension OpeningViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        /// Prevents 'slide to dismiss' for view on the root of stack
        (navigationController!.viewControllers.count > 1) ? true : false
    }
    
}
