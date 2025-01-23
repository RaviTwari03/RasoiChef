//
//  pastOrderTableViewCell.swift
//  RasoiChef
//
//  Created by Batch - 1 on 16/01/25.
//

import UIKit

class pastOrderTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var pastOrderViewCell: UIView!
    @IBOutlet weak var orderIDLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

     @IBOutlet weak var kitchenName: UILabel!
     @IBOutlet weak var locationLabel: UILabel!

    @IBOutlet weak var itemsLabel: UILabel!
    
    @IBOutlet weak var paymentDetailsButton: UIButton!
    @IBOutlet weak var trackButton: UIButton!

    
    
    
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
    
    func configure(order: Order) {
        orderIDLabel.text = "Order ID - \(order.orderID)"
        dateLabel.text = formatDate(order.deliveryDate)
        locationLabel.text = order.deliveryAddress
        kitchenName.text = order.kitchenID
        
        let numberedItems = order.items.enumerated().map { index, item in
               return "\(index + 1). \(item.menuItemID)"
           }.joined(separator: "\n")
           
           itemsLabel.text = numberedItems
        

    }
    

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    var onInfoButtonTapped: (() -> Void)?

    @IBAction func infoButtonTapped(_ sender: UIButton) {
        onInfoButtonTapped?()
    }

    
}
