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
    @IBOutlet weak var emailBackgroundView: RoundedView!
    @IBOutlet weak var passwordBackgroundView: RoundedView!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.emailTextField.autocorrectionType = .no
        
//        self.emailBackgroundView.layer.masksToBounds = false
//        self.emailBackgroundView.addShadow(shadowRadius: 3,
//                                           shadowOpacity: 1,
//                                           shadowColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.12),
//                                           shadowOffset: CGSize(width: 0, height: 2))
//        
//        self.passwordBackgroundView.layer.masksToBounds = false
//        self.passwordBackgroundView.addShadow(shadowRadius: 3,
//                                              shadowOpacity: 1,
//                                              shadowColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.12),
//                                              shadowOffset: CGSize(width: 0, height: 2))
//        
//        self.logInButtonView.layer.masksToBounds = false
//        self.logInButtonView.addShadow(shadowRadius: 3,
//                                   shadowOpacity: 1,
//                                   shadowColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.12),
//                                   shadowOffset: CGSize(width: 0, height: 2))
//        
//        self.signUpButtonView.layer.masksToBounds = false
//        self.signUpButtonView.addShadow(shadowRadius: 3,
//                                   shadowOpacity: 1,
//                                   shadowColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.12),
//                                   shadowOffset: CGSize(width: 0, height: 2))
       
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
                    
                    let storyboard = UIStoryboard(name: "Auth", bundle: nil)
                    let viewController = storyboard.instantiateViewController(identifier: ContinueSignUpViewController.storyboardID) as! ContinueSignUpViewController
                    viewController.email = email
                    self.navigationController?.pushViewController(viewController, animated: true)
                
                } else {
                    
                    self.messageLabel.text = error?.localizedDescription ?? "Error"
                    self.messageLabel.textColor = .systemRed
                    
                }
                
            }
            
        }
    }
}
