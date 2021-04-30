//
//  HistoryCell.swift
//  DrinkUp_iOS
//
//  Created by Kristopher Jackson on 4/27/21.
//

import UIKit

class HistoryDateCell: UITableViewCell {
    
    static let reuseID = "HistoryDateCell"
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
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
        dateFormatter.dateFormat = "LLL"
        
        let components = date.get(.day, .month)
        self.dayLabel.text = "\(components.day ?? 0)"
        self.monthLabel.text = dateFormatter.string(from: date)
        
        let secondaryDateFormatter = DateFormatter()
        secondaryDateFormatter.dateStyle = .none
        secondaryDateFormatter.timeStyle = .short
        self.timeLabel.text = secondaryDateFormatter.string(from: date)
        
        
    }
}
