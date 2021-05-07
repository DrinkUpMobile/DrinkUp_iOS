//
//  HistoryCell.swift
//  DrinkUp_iOS
//
//  Created by Kristopher Jackson on 4/27/21.
//

import UIKit

class HistoryCell: UITableViewCell {
    
    static let reuseID = "HistoryCell"
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func set(amount: Int?) {
        guard let amount = amount else {
            return
        }
        self.amountLabel.text = "\(amount) mL of water"
    }

    public func set(date: Date?) {
        guard let date = date else {
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        self.timeLabel.text = dateFormatter.string(from: date)
        
        
    }

}
