
import UIKit
import Firebase
import FirebaseUI

class ProfileViewController: UIViewController {
    
    static let storyboardID = "ProfileViewController"

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var updateProfileButton: RoundedButton!
    @IBOutlet weak var roundedImageView: RoundedImageView!
    @IBOutlet weak var headerContainerView: UIView!
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var firstNameTextField: InputFieldView!
    @IBOutlet weak var lastNameTextField: InputFieldView!
    @IBOutlet weak var emailTextField: InputFieldView!
    @IBOutlet weak var weightTextField: InputFieldView!
    @IBOutlet weak var dobTextField: InputFieldView!
    
    let userCollection = Firestore.firestore().collection("users").document(Auth.auth().currentUser?.uid ?? "")
    
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
        
        self.enableButton(false)
        
        self.dobTextField.delegate = self
        self.dobTextField.textField.inputView = self.datePicker
        
        self.getDataFromFirebase() {
        
            self.firstNameTextField.delegate = self
            self.lastNameTextField.delegate = self
            self.emailTextField.delegate = self
            self.dobTextField.delegate = self
            self.weightTextField.delegate = self
            
        
        }
        
        self.headerContainerView.addShadow(shadowRadius: 3, shadowOpacity: 1, shadowColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2), shadowOffset: CGSize(width: 0, height: 2))
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.enableButton(false)
        self.view.endEditing(true)
        
        /// Initialize keyboard observer
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.getDataFromFirebase() {
        
            self.firstNameTextField.delegate = self
            self.lastNameTextField.delegate = self
            self.emailTextField.delegate = self
            self.dobTextField.delegate = self
            self.weightTextField.delegate = self
            
        
        }
        
    }
    
    @objc private func keyboardWillAppear(notification: Notification) {
        
        guard let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else {
            return
        }
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight + 20, right: 0)
        self.scrollView.contentInset = insets
        self.scrollView.scrollIndicatorInsets = insets
    }
    
    @objc private func keyboardWillDisappear() {
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.scrollView.contentInset = insets
        self.scrollView.scrollIndicatorInsets = insets
    }
    
    @objc private func updateTextFieldWithDate(_ sender: Any?) {
        let picker = self.dobTextField.textField.inputView as? UIDatePicker
        
        if let date = picker?.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM d, yyyy"
            self.dobTextField.textField.text = "\(formatter.string(from: date))"
        }
    }
    
    @IBAction func logOutButton(_ sender: Any) {
        
        do {
            
            try Auth.auth().signOut()
            self.goToLogInPage()
            
        } catch(let error) {
            
            self.errorAlert(title: "Something went wrong!", message: error.localizedDescription)
            
        }
        
    }
    
    @IBAction func close(_ sender: Any) {
        guard let navigationController = self.navigationController else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        navigationController.popViewController(animated: true)
    }
    
    @IBAction func tapProfilePicture(_ sender: Any) {
        let alert = UIAlertController(title: "How would you like to add a photo?", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            let vc = UIImagePickerController()
            vc.sourceType = .camera
            vc.allowsEditing = true
            vc.delegate = self
            self.present(vc, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            let vc = UIImagePickerController()
            vc.sourceType = .photoLibrary
            vc.allowsEditing = true
            vc.delegate = self
            self.present(vc, animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func updateTapped(_ sender: Any) {
        
        let firstName = self.firstNameTextField.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let lastName = self.lastNameTextField.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let email = self.emailTextField.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let dob = self.dobTextField.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let weightString = self.weightTextField.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "0"
        
        if firstName.isEmpty || lastName.isEmpty || email.isEmpty || dob.isEmpty || weightString.isEmpty {
            let alert = UIAlertController(title: nil, message: "Fields cannot be empty!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let weight = Int(weightString)
        
        let data: [String: Any] = [
        
            "firstName": firstName,
            "lastName": lastName,
            "email":  email,
            "age": dob,
            "weight": weight ?? NSNull(),
        
        ]
        
        self.userCollection.setData(data, merge: true) { (error) in
            if let error = error {
                let alert = UIAlertController(title: "Something went wrong!", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
                self.present(alert, animated: true)
                return
            }
            
            let alert = UIAlertController(title: nil, message: "Your information has been updated 🎉", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alert, animated: true, completion: nil)
            
            self.enableButton(false)
            self.view.endEditing(true)
            self.firstNameTextField.resignFirstResponder()
            self.lastNameTextField.resignFirstResponder()
            self.dobTextField.resignFirstResponder()
            self.emailTextField.resignFirstResponder()
            self.weightTextField.resignFirstResponder()
            
        }
        
    }
    
    private func getDataFromFirebase(_ completion: @escaping () -> Void) {
        
        self.userCollection.addSnapshotListener { (snapshot, error) in
            if let error = error {
                let alert = UIAlertController(title: "Something went wrong!", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
                self.present(alert, animated: true, completion: {
                    completion()
                })
                return
            }
            
            guard let snapshot = snapshot else {
                completion()
                return
            }
            
            let firstName = snapshot.data()?["firstName"] as? String ?? ""
            let lastName = snapshot.data()?["lastName"] as? String ?? ""
            
            self.headerLabel.text = "\(firstName) \(lastName)"
            
            self.firstNameTextField.textField.text = firstName
            self.lastNameTextField.textField.text = lastName
            self.emailTextField.textField.text = snapshot.data()?["email"] as? String ?? ""
            self.dobTextField.textField.text = snapshot.data()?["age"] as? String ?? ""
            self.weightTextField.textField.text = "\(snapshot.data()?["weight"] as? Int ?? 0)"
            
            let profilePicture = snapshot.data()?["profilePicture"] as? String ?? ""
            
            let reference = Storage.storage().reference(withPath: "profilePictures").child(profilePicture)
            self.roundedImageView.sd_setImage(with: reference, placeholderImage: nil)
            
            completion()
            
        }
        
    }
    
    private func enableButton(_ enable: Bool) {
        self.updateProfileButton.isEnabled = enable
        self.updateProfileButton.backgroundColor = enable ? #colorLiteral(red: 0.0932898894, green: 0.7137736678, blue: 0.9685057998, alpha: 1) : .systemGray5
    }
    
    private func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    private func errorAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    /// Call this function to navigate to the log in page
    private func goToLogInPage() {
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: AuthNavigationController.storyboardID) as! AuthNavigationController
        viewController.modalPresentationStyle = .fullScreen  // covers the entire screen rather than partially (comment this out to see the difference)
        viewController.modalTransitionStyle = .crossDissolve // transition animation
        self.present(viewController, animated: true, completion: nil)
    }
    
}


extension ProfileViewController: InputFieldViewDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let picker = self.dobTextField.textField.inputView as? UIDatePicker
        if let date = picker?.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM d, yyyy"
            self.dobTextField.textField.text = "\(formatter.string(from: date))"
        }
    }
    
    func inputFieldViewDidChangeSelection(_ textField: UITextField) {
        self.enableButton(true)
    }
    
}


extension ProfileViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            return
        }
        
        let imageName = "\(self.randomString(length: 10)).jpeg"
        
        let imageRef = Storage.storage().reference(withPath: "profilePictures").child(imageName)
        _ = imageRef.putData(data, metadata: nil, completion: { metadata, error in
            
            if let error = error {
                self.errorAlert(title: "Something Went Wrong!", message: error.localizedDescription)
                return
            }
            
            guard let uid = Auth.auth().currentUser?.uid else {
                self.errorAlert(title: "Something Went Wrong!", message: "User not signed in.")
                return
            }
            
            Firestore.firestore().collection("users").document(uid).setData([
                "profilePicture": imageName,
            ], merge: true)
            
        })
    }
    
}


extension ProfileViewController: UINavigationControllerDelegate {
    
    
}
