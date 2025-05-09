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
    @IBOutlet weak var itemsHeaderLabel: UILabel?
    @IBOutlet weak var paymentDetailsLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyCardStyle()
        contentView.layer.cornerRadius = 10
        
        // Defensive: Always configure itemsLabel to avoid truncation
        itemsLabel.numberOfLines = 0
        itemsLabel.lineBreakMode = .byWordWrapping
        itemsLabel.adjustsFontSizeToFitWidth = false
        itemsLabel.minimumScaleFactor = 1.0
        itemsLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        itemsLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        itemsLabel.translatesAutoresizingMaskIntoConstraints = false

        if let itemsHeaderLabel = itemsHeaderLabel, let paymentDetailsLabel = paymentDetailsLabel {
            itemsHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
            paymentDetailsLabel.translatesAutoresizingMaskIntoConstraints = false

            // Remove all constraints related to these labels (to avoid duplicates)
            if let superview = itemsLabel.superview {
                for constraint in superview.constraints {
                    if constraint.firstItem as? UILabel == itemsLabel || constraint.secondItem as? UILabel == itemsLabel ||
                        constraint.firstItem as? UILabel == paymentDetailsLabel || constraint.secondItem as? UILabel == paymentDetailsLabel ||
                        constraint.firstItem as? UILabel == itemsHeaderLabel || constraint.secondItem as? UILabel == itemsHeaderLabel {
                        superview.removeConstraint(constraint)
                    }
                }
            }
            // Add constraints to ensure proper vertical stacking and stretching
            NSLayoutConstraint.activate([
                itemsHeaderLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
                itemsHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                itemsHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

                itemsLabel.topAnchor.constraint(equalTo: itemsHeaderLabel.bottomAnchor, constant: 4),
                itemsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                itemsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                itemsLabel.bottomAnchor.constraint(equalTo: paymentDetailsLabel.topAnchor, constant: -8),

                paymentDetailsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                paymentDetailsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                paymentDetailsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
            ])
        }
        
        // Configure location label
        locationLabel.numberOfLines = 2
        locationLabel.lineBreakMode = .byWordWrapping
        kitchenName.setContentHuggingPriority(.required, for: .vertical)
        kitchenName.setContentCompressionResistancePriority(.required, for: .vertical)
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
        
        // Set loading state
        itemsLabel.text = "Loading items..."
        
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

