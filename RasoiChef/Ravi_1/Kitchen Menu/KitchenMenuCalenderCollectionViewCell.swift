//
//  KitchenMenuCalenderCollectionViewCell.swift
//  kitchen
//
//  Created by Ravi Tiwari on 18/01/25.
//

import UIKit

protocol KitchenMenuCalenderCellDelegate: AnyObject {
    func didSelectDate(_ date: Date)
}


class KitchenMenuCalenderCollectionViewCell: UICollectionViewCell {
  
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var dayLabel: UILabel!
    


    override func awakeFromNib() {
            super.awakeFromNib()
            setupAppearance()
        }
        
        private func setupAppearance() {
            contentView.layer.cornerRadius = 15
            contentView.layer.borderWidth = 1
            contentView.layer.borderColor = UIColor(hex: "ED7A57").cgColor
            contentView.layer.masksToBounds = true
        }
        
        override var isSelected: Bool {
            didSet {
                updateSelectionAppearance(selected: isSelected)
            }
        }
        
        private func updateSelectionAppearance(selected: Bool) {
            contentView.backgroundColor = selected ? UIColor(hex: "ED7A57") : .white
            contentView.layer.borderWidth = selected ? 0 : 1
            monthLabel.textColor = selected ? .white : .black
            dateLabel.textColor = selected ? .white : .black
            dayLabel.textColor = selected ? .white : .black
        }
        
        func updateMenuListDate(for indexPath: IndexPath) -> Bool {
            let calendar = Calendar.current
            let today = Date()
            var isToday = false

            if let futureDate = calendar.date(byAdding: .day, value: indexPath.row, to: today) {
                let dateFormatter = DateFormatter()
                
                dateFormatter.dateFormat = "MMM"
                monthLabel.text = dateFormatter.string(from: futureDate)
                
                dateFormatter.dateFormat = "d"
                dateLabel.text = dateFormatter.string(from: futureDate)
                
                dateFormatter.dateFormat = "EEE"
                dayLabel.text = dateFormatter.string(from: futureDate)
                
                // Check if the current cell represents today's date
                if calendar.isDate(today, inSameDayAs: futureDate) {
                    isToday = true
                    isSelected = true  // Automatically mark today's date as selected
                }
            }
            return isToday
        }
    }

    extension UIColor {
        convenience init(hex: String) {
            var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
            
            var rgb: UInt64 = 0
            Scanner(string: hexSanitized).scanHexInt64(&rgb)
            
            let red = CGFloat((rgb >> 16) & 0xFF) / 255.0
            let green = CGFloat((rgb >> 8) & 0xFF) / 255.0
            let blue = CGFloat(rgb & 0xFF) / 255.0
             
            self.init(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
