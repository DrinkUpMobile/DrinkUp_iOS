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
