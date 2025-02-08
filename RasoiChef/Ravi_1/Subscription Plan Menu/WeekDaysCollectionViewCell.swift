//
//  WeekDaysCollectionViewCell.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 31/01/25.
//

import UIKit

class WeekDaysCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var weekDays: UILabel!
    

    var onTap: (() -> Void)? // Closure to handle tap events

        override func awakeFromNib() {
            super.awakeFromNib()
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            self.addGestureRecognizer(tapGesture)
        }

        @objc func handleTap() {
            onTap?() // Trigger the closure when the cell is tapped
        }

        func weekDay(day: String) {
            weekDays.text = String(day.prefix(1))
            weekDays.font = UIFont.boldSystemFont(ofSize: 18)
            weekDays.textAlignment = .center
        }
    }

