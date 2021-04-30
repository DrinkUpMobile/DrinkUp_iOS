//
//  DataSelect.swift
//  DrinkUp_iOS
//
//  Created by Kristopher Jackson on 3/30/21.
//

import UIKit

class DataSelect: UIViewController {
    
    static let storyboardID = "DataSelect"
    
    var selected: (Decimal?, UIButton?) = (nil, nil)
    
    @IBOutlet weak var hundred: RoundedButton!
    @IBOutlet weak var twoHundred: RoundedButton!
    @IBOutlet weak var threeHundred: RoundedButton!
    @IBOutlet weak var fourHundred: RoundedButton!
    @IBOutlet weak var fiveHundred: RoundedButton!
    @IBOutlet weak var sixHundred: RoundedButton!
    
    @IBOutlet weak var addAmount: RoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func amountPressed(_ sender: Any) {
        guard let sender = sender as? UIButton else {
            return
        }
        
        guard let text = sender.titleLabel?.text else {
            return
        }
        
        
        if sender != self.selected.1 {
            sender.isSelected = true
            self.selected.1?.isSelected = false
            
            let amount = text.split(separator: " ")
            
            self.selected.1 = sender
            self.selected .0 = Decimal(Double(amount[0]) ?? 0)
            
            
            self.addAmount.isEnabled = true
            self.addAmount.backgroundColor = #colorLiteral(red: 0.0932898894, green: 0.7137736678, blue: 0.9685057998, alpha: 1)
            
        } else {
            return
        }
        
    }
    
    @IBAction func addAmountPressed(_ sender: Any) {
        
        guard let amount = self.selected.0 else {
            return
        }
        
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
    
}
