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
        pastOrderViewCell.layer.borderWidth = 0.5
        pastOrderViewCell.layer.borderColor = UIColor.black.cgColor
            // Round the corners of the content view to make it appear as a card
        pastOrderViewCell.layer.cornerRadius = 16
        pastOrderViewCell.layer.masksToBounds = true

        pastOrderViewCell.layoutMargins = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
            
            // Optionally, you can add a background color for the card
        pastOrderViewCell.backgroundColor = .white
        }
    
    func configure(order: Order) {
        orderIDLabel.text = "Order ID - \(order.orderID)"
        dateLabel.text = formatDate(order.deliveryDate)
        locationLabel.text = order.deliveryAddress
        kitchenName.text = order.kitchenName
        
        // Set loading state for items
        itemsLabel.text = "Items :\nLoading items..."
        Task {
            do {
                // Fetch order with items
                let response = try await SupabaseController.shared.client.database
                    .from("orders")
                    .select("order_items")
                    .eq("order_id", value: order.orderID)
                    .single()
                    .execute()
                
                print("Order response: \(String(data: response.data, encoding: .utf8) ?? "No data")")
                
                // Parse the response data
                guard let json = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any] else {
                    print("Failed to parse order response")
                    DispatchQueue.main.async {
                        self.itemsLabel.text = "Error loading items"
                    }
                    return
                }
                
                // Handle both string and array formats for order_items
                var orderItems: [[String: Any]] = []
                
                if let orderItemsString = json["order_items"] as? String {
                    // If order_items is a string, parse it as JSON
                    if let data = orderItemsString.data(using: .utf8),
                       let parsedItems = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                        orderItems = parsedItems
                    }
                } else if let itemsArray = json["order_items"] as? [[String: Any]] {
                    // If order_items is already an array
                    orderItems = itemsArray
                }
                
                print("Found order items: \(orderItems)")
                var itemStrings: [String] = []
                
                for (index, item) in orderItems.enumerated() {
                    guard let menuItemID = item["menu_item_id"] as? String,
                          let quantity = item["quantity"] as? Int else {
                        print("Missing required fields in order item: \(item)")
                        continue
                    }
                    
                    // Try to find item name in menu_items
                    do {
                        let menuItemResponse = try await SupabaseController.shared.client.database
                            .from("menu_items")
                            .select("name")
                            .eq("item_id", value: menuItemID)
                            .single()
                            .execute()
                        
                        if let menuJson = try? JSONSerialization.jsonObject(with: menuItemResponse.data, options: []) as? [String: Any],
                           let itemName = menuJson["name"] as? String {
                            itemStrings.append("\(index + 1). \(itemName) x\(quantity)")
                            continue
                        }
                    } catch {
                        print("Error fetching menu item: \(error)")
                    }
                    
                    // Try chef_specialty_dishes if not found in menu_items
                    do {
                        let specialResponse = try await SupabaseController.shared.client.database
                            .from("chef_specialty_dishes")
                            .select("name")
                            .eq("dish_id", value: menuItemID)
                            .single()
                            .execute()
                        
                        if let specialJson = try? JSONSerialization.jsonObject(with: specialResponse.data, options: []) as? [String: Any],
                           let itemName = specialJson["name"] as? String {
                            itemStrings.append("\(index + 1). \(itemName) x\(quantity)")
                            continue
                        }
                    } catch {
                        print("Error fetching specialty dish: \(error)")
                    }
                    
                    // If we couldn't find the item name in either table
                    itemStrings.append("\(index + 1). Item #\(menuItemID) x\(quantity)")
                }
                
                // Update UI on main thread
                DispatchQueue.main.async {
                    if itemStrings.isEmpty {
                        self.itemsLabel.text = "No items found"
                    } else {
                        self.itemsLabel.text = itemStrings.joined(separator: "\n")
                    }
                }
            } catch {
                print("Error fetching order items: \(error)")
                DispatchQueue.main.async {
                    self.itemsLabel.text = "Error loading items"
                }
            }
        }
        
        // Update track button based on order status
       // trackButton.isEnabled = order.status != .delivered
       // trackButton.alpha = order.status != .delivered ? 1.0 : 0.5
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
