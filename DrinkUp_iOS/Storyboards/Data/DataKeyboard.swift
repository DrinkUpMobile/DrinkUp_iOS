//
//  DataKeyboard.swift
//  DrinkUp_iOS
//
//  Created by Kristopher Jackson on 3/30/21.
//

import UIKit


class DataKeyboard: UIViewController {
    
    @IBOutlet weak var close: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var addAmountButton: RoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textField.isUserInteractionEnabled = false
        
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
    
    @IBAction func addAmountPressed(_ sender: Any) {
        guard let text = self.textField.text else {
            return
        }
        
        let amount = Decimal(Double(text) ?? 0)
        
        HydrationAPI.addDrink(amount: amount) { (error) in
            if let error = error {
                let alertController = UIAlertController(title: "Something Went Wrong!",
                                                        message: error.localizedDescription,
                                                        preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func customAmountPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Data", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: DataSelect.storyboardID)
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overFullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func digitPressed(_ sender: Any) {
        guard let sender = sender as? UIButton,
              let text = sender.titleLabel?.text else {
            return
        }
        
        self.textField.text?.append(text)
        
        if self.textField.text != nil {
            self.addAmountButton.isEnabled = true
            self.addAmountButton.backgroundColor = .systemBlue
        }
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        _ = self.textField.text?.popLast()
        
        if self.textField.text?.isEmpty ?? true {
            self.addAmountButton.isEnabled = false
            self.addAmountButton.backgroundColor = .secondarySystemBackground
        }
    }
    
}
