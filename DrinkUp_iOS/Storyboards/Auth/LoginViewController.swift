import UIKit

class LoginViewController: UIViewController {
    
    static let storyboardID = "LoginViewController"
    
    @IBOutlet weak var logInButtonView: UIView!
    @IBOutlet weak var signUpButtonView: UIView!
    @IBOutlet weak var emailBackgroundView: RoundedView!
    @IBOutlet weak var passwordBackgroundView: RoundedView!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTextfield.autocorrectionType = .no
        
        self.emailBackgroundView.layer.masksToBounds = false
        self.emailBackgroundView.addShadow(shadowRadius: 3,
                                           shadowOpacity: 1,
                                           shadowColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.12),
                                           shadowOffset: CGSize(width: 0, height: 2))
        
        self.passwordBackgroundView.layer.masksToBounds = false
        self.passwordBackgroundView.addShadow(shadowRadius: 3,
                                              shadowOpacity: 1,
                                              shadowColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.12),
                                              shadowOffset: CGSize(width: 0, height: 2))
        
        self.logInButtonView.layer.masksToBounds = false
        self.logInButtonView.addShadow(shadowRadius: 3,
                                   shadowOpacity: 1,
                                   shadowColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.12),
                                   shadowOffset: CGSize(width: 0, height: 2))
        
        self.signUpButtonView.layer.masksToBounds = false
        self.signUpButtonView.addShadow(shadowRadius: 3,
                                   shadowOpacity: 1,
                                   shadowColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.12),
                                   shadowOffset: CGSize(width: 0, height: 2))
        
        
        
        self.logInButton.layer.cornerRadius = 8
        self.logInButton.layer.masksToBounds = true
        
        self.signUpButton.layer.borderWidth = 0
        self.signUpButton.layer.cornerRadius = 8
        self.signUpButton.layer.masksToBounds = true
        self.signUpButton.layer.borderColor = Colors.main.cgColor
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /// Configure super view
        /// Add rounded corners to iPhone X family
        if window?.safeAreaInsets.bottom ?? 0 > 0 {
            self.view.layer.cornerRadius = 40
            self.view.layer.masksToBounds = true
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /// Configure super view
        /// Remove rounded corners to iPhone X family
        if window?.safeAreaInsets.bottom ?? 0 > 0 {
            self.view.layer.cornerRadius = 0
            self.view.layer.masksToBounds = true
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        /// Configure super view
        /// Add rounded corners to iPhone X family
        if window?.safeAreaInsets.bottom ?? 0 > 0 {
            self.view.layer.cornerRadius = 40
            self.view.layer.masksToBounds = true
        }
        
        self.view.endEditing(true)
    }
    
    @IBAction func closedPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        guard let email = self.emailTextfield.text,
              let password = self.passwordTextfield.text else {
            return
        }
        
        FirebaseAuthManager.signIn(email: email, pass: password) { (success, error) in
            if let error = error {
                self.setError(error.localizedDescription)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }

    @IBAction func goToSignUp(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: SignUpViewController.storyboardID) as! SignUpViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func setError(_ text: String) {
        let alert = UIAlertController(title: "Uh-Oh!", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive))
        self.present(alert, animated: true, completion: nil)
    }
}
