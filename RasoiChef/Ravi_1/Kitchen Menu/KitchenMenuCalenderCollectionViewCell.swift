//
//  KitchenMenuCalenderCollectionViewCell.swift
//  kitchen
//
//  Created by Ravi Tiwari on 18/01/25.
//

import UIKit

class KitchenMenuCalenderCollectionViewCell: UICollectionViewCell {
  
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var dayLabel: UILabel!
    

    override func awakeFromNib() {
            super.awakeFromNib()
            setupAppearance()
        }
        
        private func setupAppearance() {
            contentView.layer.cornerRadius = 16
            contentView.layer.borderWidth = 2
            contentView.layer.borderColor = UIColor(hex: "ED7A57").cgColor
            contentView.layer.masksToBounds = true
        }
        
        override var isSelected: Bool {
            didSet {
                contentView.backgroundColor = isSelected ? UIColor(hex: "ED7A57") : .white
                monthLabel.textColor = isSelected ? .white : .black
                dateLabel.textColor = isSelected ? .white : .black
                dateLabel.font = isSelected ? UIFont.boldSystemFont(ofSize: 15) : UIFont.boldSystemFont(ofSize: 15)
                dayLabel.textColor = isSelected ? .white : .black
            }
        }
        
        func updateMenuListDate(for indexPath: IndexPath) {
            let calendar = Calendar.current
            let today = Date()
            
            if let futureDate = calendar.date(byAdding: .day, value: indexPath.row, to: today) {
                let dateFormatter = DateFormatter()
                
                dateFormatter.dateFormat = "MMM" // Month in short format (e.g., Jan, Feb)
                monthLabel.text = dateFormatter.string(from: futureDate)
                
                dateFormatter.dateFormat = "d" // Day of the month
                dateLabel.text = dateFormatter.string(from: futureDate)
                
                dateFormatter.dateFormat = "EEE" // Day of the week in short format (e.g., Mon, Tue)
                dayLabel.text = dateFormatter.string(from: futureDate)
                
                // Highlight today’s date if needed
                if calendar.isDate(today, inSameDayAs: futureDate) {
                    dayLabel.textColor = .systemRed
                } else {
                    dayLabel.textColor = .label
                }
            }
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
