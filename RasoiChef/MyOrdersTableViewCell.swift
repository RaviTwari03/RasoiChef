//
//  MyOrdersTableViewCell.swift
//  RasoiChef
//
//  Created by Batch - 1 on 15/01/25.
//

import UIKit

class MyOrdersTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var cardView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyCardStyle()

        
        contentView.layer.cornerRadius = 10
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
//        
    }
    private func applyCardStyle() {
            // Round the corners of the content view to make it appear as a card
        cardView.layer.cornerRadius = 16
        cardView.layer.masksToBounds = true

            // Add shadow to create a card-like appearance
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 5
        cardView.layer.shadowOpacity = 0.3
        cardView.layer.masksToBounds = false
            
            // Add padding by adjusting the content insets
        cardView.layoutMargins = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
            
            // Optionally, you can add a background color for the card
        cardView.backgroundColor = .white
        }
    
}
