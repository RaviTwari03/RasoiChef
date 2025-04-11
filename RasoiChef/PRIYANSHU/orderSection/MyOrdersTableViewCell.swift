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
    
    var orderForDetail: Order?
    weak var delegate: MyOrderTableViewCellDelegate?
    var onInfoButtonTapped: (() -> Void)?
   
    @IBOutlet weak var orderIDLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var kitchenName: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var itemsLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var trackButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyCardStyle()
        contentView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func applyCardStyle() {
        // Round the corners of the content view to make it appear as a card
        cardView.layer.cornerRadius = 15
        cardView.layer.masksToBounds = true
        // Add shadow to create a card-like appearance
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 2.5
        cardView.layer.shadowOpacity = 0.4
        cardView.layer.masksToBounds = false
        // Add padding by adjusting the content insets
        cardView.layoutMargins = UIEdgeInsets(top: 15, left: 16, bottom: 15, right: 16)
        // Optionally, you can add a background color for the card
        cardView.backgroundColor = .white
    }
   
    func configure(order: Order) {
        self.orderForDetail = order
        orderIDLabel.text = "Order ID - \(order.orderID)"
        dateLabel.text = formatDate(order.deliveryDate)
        locationLabel.text = order.deliveryAddress
        kitchenName.text = order.kitchenName
        
        // Format items with names and quantities
        Task {
            var itemStrings: [String] = []
            
            for (index, item) in order.items.enumerated() {
                do {
                    // Try to find item in menu_items
                    let menuItemResponse = try await SupabaseController.shared.client.database
                        .from("menu_items")
                        .select("name")
                        .eq("item_id", value: item.menuItemID)
                        .single()
                        .execute()
                    
                    if let json = try JSONSerialization.jsonObject(with: menuItemResponse.data, options: []) as? [String: Any],
                       let itemName = json["name"] as? String {
                        itemStrings.append("\(index + 1). \(itemName) x\(item.quantity)")
                    } else {
                        // If not found in menu_items, try chef_specialty_dishes
                        let specialResponse = try await SupabaseController.shared.client.database
                            .from("chef_specialty_dishes")
                            .select("name")
                            .eq("dish_id", value: item.menuItemID)
                            .single()
                            .execute()
                        
                        if let json = try JSONSerialization.jsonObject(with: specialResponse.data, options: []) as? [String: Any],
                           let itemName = json["name"] as? String {
                            itemStrings.append("\(index + 1). \(itemName) x\(item.quantity)")
                        } else {
                            itemStrings.append("\(index + 1). Item #\(item.menuItemID) x\(item.quantity)")
                        }
                    }
                } catch {
                    print("Error fetching item name: \(error)")
                    itemStrings.append("\(index + 1). Item #\(item.menuItemID) x\(item.quantity)")
                }
            }
            
            // Update UI on main thread
            DispatchQueue.main.async {
                self.itemsLabel.text = itemStrings.joined(separator: "\n")
            }
        }
        
        // Update track button based on order status
        trackButton.isEnabled = order.status != .delivered
        trackButton.alpha = order.status != .delivered ? 1.0 : 0.5
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    @IBAction func infoButtonTapped(_ sender: UIButton) {
        onInfoButtonTapped?()
    }
    
    @IBAction func trackButtonTapped(_ sender: Any) {
        if let order = orderForDetail {
            delegate?.didTapTrackButton(forOrder: order)
        }
    }
}

extension MyOrdersTableViewCell: CartPayCellDelegate {
    func didTapPlaceOrder() {
        if let order = orderForDetail {
            orderIDLabel.text = "Order ID - \(order.orderID)"
            dateLabel.text = formatDate(order.deliveryDate)
            locationLabel.text = order.deliveryAddress
            kitchenName.text = order.kitchenName
        }
    }
}

