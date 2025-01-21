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
    
    func updateMenuListDate(for indexPath: IndexPath){
        let menuDate = KitchenDataController.dateItem[indexPath.row]
        monthLabel.text = menuDate.month
        dayLabel.text = menuDate.dayOfWeek
//        dateLabel.text = menuDate.date
        dateLabel.text = String(menuDate.date)
//        dayLabel.textColor = .systemGrayav
        
        
        
    }
    
    
}
