//
//  subscriptionPlansTableViewCell.swift
//  RasoiChef
//
//  Created by Batch - 1 on 22/01/25.
//

import UIKit

class subscriptionPlansTableViewCell: UITableViewCell {
    @IBOutlet weak var orderIDLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var kitchenName: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var planName: UILabel!
    @IBOutlet weak var symbol: UILabel!
    
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
    }
    
    private func applyCardStyle() {
            // Round the corners of the content view to make it appear as a card
        cardView.layer.cornerRadius = 16
        cardView.layer.masksToBounds = true
            // Add shadow to create a card-like appearance
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cardView.layer.shadowRadius = 5
        cardView.layer.shadowOpacity = 0.4
        cardView.layer.masksToBounds = false
            // Add padding by adjusting the content insets
        cardView.layoutMargins = UIEdgeInsets(top: 15, left: 16, bottom: 15, right: 16)
            
            // Optionally, you can add a background color for the card
        cardView.backgroundColor = .white
        }
   
}
