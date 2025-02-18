//
//  WeekDaysCollectionViewCell.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 31/01/25.
//

import UIKit
protocol WeekDaysSelectionDelegate: AnyObject {
    func didSelectDay(_ day: String)
}


class WeekDaysCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: WeekDaysSelectionDelegate?
    @IBOutlet var weekDaysLabel: UILabel!
    

    private var day: String = ""

        var onTap: (() -> Void)? // Closure to handle tap events

        override func awakeFromNib() {
            super.awakeFromNib()
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            self.addGestureRecognizer(tapGesture)
            setupUI()
        }

        func configure(with day: String) {
            self.day = day
            weekDaysLabel.text = String(day.prefix(1)) // Show only the first letter
            weekDaysLabel.font = UIFont.boldSystemFont(ofSize: 20)
            weekDaysLabel.textAlignment = .center
        }

        @objc func handleTap() {
            delegate?.didSelectDay(day)  // Notify delegate
            highlightSelection(true)
        }

        func highlightSelection(_ isSelected: Bool) {
            self.contentView.backgroundColor = isSelected ? UIColor.accent : UIColor.clear
            weekDaysLabel.textColor = isSelected ? .white : .black
        }

        private func setupUI() {
            self.layer.cornerRadius = 10
            self.clipsToBounds = true
        }
    }
