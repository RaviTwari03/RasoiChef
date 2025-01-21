//
//  MyOrdersTableViewCell.swift
//  RasoiChef
//
//  Created by Batch - 1 on 15/01/25.
//

import UIKit

protocol MyOrderTableViewCellDelegate: AnyObject {
    func didTapTrackButton(forOrder order: Order)
}

class MyOrdersTableViewCell: UITableViewCell {
    
    var orderForDetail:Order?
   
            @IBOutlet weak var orderIDLabel: UILabel!
            @IBOutlet weak var dateLabel: UILabel!
            @IBOutlet weak var kitchenName: UILabel!
            @IBOutlet weak var locationLabel: UILabel!
            @IBOutlet weak var itemsLabel: UILabel!
            @IBOutlet weak var paymentDetailsButton: UIButton!
        

    
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
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 5
        cardView.layer.shadowOpacity = 0.2
        cardView.layer.masksToBounds = false
            // Add padding by adjusting the content insets
        cardView.layoutMargins = UIEdgeInsets(top: 15, left: 16, bottom: 15, right: 16)
            
            // Optionally, you can add a background color for the card
        cardView.backgroundColor = .white
        }
   
    func configure(order: Order) {
        orderForDetail = order
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
    
    // for track button 
    
        @IBOutlet weak var trackButton: UIButton!
        
        weak var delegate: MyOrderTableViewCellDelegate?
//        var order: Order!
        @IBAction func trackButtonTapped(_ sender: Any) {
            delegate?.didTapTrackButton(forOrder: orderForDetail!)
            
        }
        
  
}
