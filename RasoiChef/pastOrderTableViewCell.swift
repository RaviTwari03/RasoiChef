//
//  pastOrderTableViewCell.swift
//  RasoiChef
//
//  Created by Batch - 1 on 16/01/25.
//

import UIKit

class pastOrderTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var pastOrderViewCell: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyCardStyle()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    private func applyCardStyle() {
            // Round the corners of the content view to make it appear as a card
        pastOrderViewCell.layer.cornerRadius = 16
        pastOrderViewCell.layer.masksToBounds = true

            // Add shadow to create a card-like appearance
        pastOrderViewCell.layer.shadowColor = UIColor.black.cgColor
        pastOrderViewCell.layer.shadowOffset = CGSize(width: 0, height: 2)
        pastOrderViewCell.layer.shadowRadius = 5
        pastOrderViewCell.layer.shadowOpacity = 0.3
        pastOrderViewCell.layer.masksToBounds = false
            
            // Add padding by adjusting the content insets
        pastOrderViewCell.layoutMargins = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
            
            // Optionally, you can add a background color for the card
        pastOrderViewCell.backgroundColor = .white
        }
    
}
