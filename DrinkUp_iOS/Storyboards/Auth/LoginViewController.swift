import UIKit

class LoginViewController: UIViewController {
    
    static let storyboardID = "LoginViewController"
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
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
    
    @IBAction func loginPressed(_ sender: Any) {
        guard let email = self.emailTextfield.text,
              let password = self.passwordTextfield.text else {
            return
        }
        
        FirebaseAuthManager.signIn(email: email, pass: password) { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
            } else {
                print("Email password failed!")
            }
        }
        
    }

    @IBAction func goToSignUp(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: SignUpViewController.storyboardID) as! SignUpViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    

}
