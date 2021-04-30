import UIKit
import Firebase

class ContinueSignUpViewController: UIViewController {
    
    static let storyboardID = "ContinueSignUpViewController"
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var nextButton: RoundedButton!
    
    @IBOutlet weak var firstNameBackgroundView: RoundedView!
    @IBOutlet weak var lastNameBackgroundView: RoundedView!
    @IBOutlet weak var ageNameBackgroundView: RoundedView!
    @IBOutlet weak var weightNameBackgroundView: RoundedView!

    
    var email: String!
    
    let datePicker: UIDatePicker = {
        
        let datePicker = UIDatePicker()
        datePicker.date = Date()
        datePicker.locale = .current
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) { datePicker.preferredDatePickerStyle = .wheels }
        datePicker.addTarget(self, action: #selector(updateTextFieldWithDate(_:)), for: .valueChanged)
        return datePicker
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.firstNameBackgroundView.layer.masksToBounds = false
        self.firstNameBackgroundView.addShadow(shadowRadius: 3,
                                           shadowOpacity: 1,
                                           shadowColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.12),
                                           shadowOffset: CGSize(width: 0, height: 2))
        
        self.lastNameBackgroundView.layer.masksToBounds = false
        self.lastNameBackgroundView.addShadow(shadowRadius: 3,
                                           shadowOpacity: 1,
                                           shadowColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.12),
                                           shadowOffset: CGSize(width: 0, height: 2))
        
        self.weightNameBackgroundView.layer.masksToBounds = false
        self.weightNameBackgroundView.addShadow(shadowRadius: 3,
                                              shadowOpacity: 1,
                                              shadowColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.12),
                                              shadowOffset: CGSize(width: 0, height: 2))
        
        
        self.ageTextField.delegate = self
        self.ageTextField.inputView = self.datePicker
        self.ageNameBackgroundView.layer.masksToBounds = false
        self.ageNameBackgroundView.addShadow(shadowRadius: 3,
                                                shadowOpacity: 1,
                                                shadowColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.12),
                                                shadowOffset: CGSize(width: 0, height: 2))
        
        
        self.nextButton.layer.masksToBounds = false
        self.nextButton.addShadow(shadowRadius: 3,
                                   shadowOpacity: 1,
                                   shadowColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.12),
                                   shadowOffset: CGSize(width: 0, height: 2))
        
    }
    
    @IBAction func closePressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createAccountPressed(_ sender: Any) {
        
        guard let firstName = self.firstNameTextField.text else {
            self.setError(NSLocalizedString("GENERIC_ERROR", comment: "Error"))
            return
        }
        
        guard let lastName = self.lastNameTextField.text else {
            self.setError(NSLocalizedString("GENERIC_ERROR", comment: "Error"))
            return
        }
        
        guard let age = self.ageTextField.text else {
            self.setError(NSLocalizedString("GENERIC_ERROR", comment: "Error"))
            return
        }

        guard let weight = self.weightTextField.text else {
            self.setError(NSLocalizedString("GENERIC_ERROR", comment: "Error"))
            return
        }
        
        /// User is not signed in
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        let userCollection = db.collection("users")
        let userDocument = userCollection.document(uid)
        
        let userData: [String : Any] = ["firstName" : firstName,
                        "lastName": lastName,
                        "age": age,
                        "weight": Int(weight) ?? 0,
                        "email": self.email]
        
        userDocument.setData(userData, merge: true) { (error) in
            DispatchQueue.main.async {
                if let error = error {
                    self.setError(error.localizedDescription)
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
    }
    
    @objc private func updateTextFieldWithDate(_ sender: Any?) {
        let picker = self.ageTextField.inputView as? UIDatePicker
        
        if let date = picker?.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM d, yyyy"
            self.ageTextField.text = "\(formatter.string(from: date))"
        }
    }
        
    private func setError(_ text: String) {
        self.errorAlert(title: "Uh-oh!", message: text)
    }
    
    private func errorAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive))
        self.present(alert, animated: true, completion: nil)
    }
    
}



extension ContinueSignUpViewController: UITextFieldDelegate {
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let picker = self.ageTextField.inputView as? UIDatePicker
        if let date = picker?.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM d, yyyy"
            self.ageTextField.text = "\(formatter.string(from: date))"
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    
}
