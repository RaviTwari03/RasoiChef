//
//  AddItemCartTableViewCell.swift
//  kitchen
//
//  Created by Ravi Tiwari on 19/01/25.
//

import UIKit

class AddItemCartTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCellAppearance()
    }

    private func setupCellAppearance() {
           // Apply corner radius
           contentView.layer.cornerRadius = 15
           contentView.layer.masksToBounds = true
            
           // Add border
           contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.black.cgColor

           // Add shadow effect for a card-like appearance
           layer.shadowColor = UIColor.black.cgColor
           layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 2.5
           layer.shadowOpacity = 0.4
           layer.masksToBounds = false // Ensures shadow is visible outside contentView
       }

       override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)
       }

}
