//
//  SubscriptionCartItemsCollectionTableViewCell.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 13/02/25.
//

import UIKit

class SubscriptionCartItemsCollectionTableViewCell: UITableViewCell {

    
    @IBOutlet weak var SubscriptionName: UILabel!
    @IBOutlet weak var selectedRange: UILabel!
    @IBOutlet weak var subscriptionPrice: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var increaseStepper: UIStepper!
    
    
    var cartItem: CartItem?  // Store reference for updates

       override func awakeFromNib() {
           super.awakeFromNib()
           
           // Configure stepper
           increaseStepper.minimumValue = 1
           increaseStepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
       }

       func configure(with item: CartItem) {
           guard let subscription = item.subscriptionDetails else { return }

           cartItem = item  // Store reference for later updates
           
           SubscriptionName.text = "Subscription Plan"
           selectedRange.text = "Start: \(subscription.startDate ?? "N/A") - End: \(subscription.endDate ?? "N/A")"
           subscriptionPrice.text = "₹\(subscription.totalPrice ?? 0.0)"
           quantityLabel.text = "\(item.quantity)"
           increaseStepper.value = Double(item.quantity)
       }

       @objc func stepperValueChanged(_ sender: UIStepper) {
           guard var cartItem = cartItem else { return }

           let newQuantity = Int(sender.value)
           quantityLabel.text = "\(newQuantity)"
           
           // Update quantity in the cartItem model
           cartItem.quantity = newQuantity
       }
   }
