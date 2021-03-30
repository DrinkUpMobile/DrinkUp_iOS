//
//  DataSelect.swift
//  DrinkUp_iOS
//
//  Created by Kristopher Jackson on 3/30/21.
//

import UIKit

class DataSelect: UIViewController {
    
    static let storyboardID = "DataSelect"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
