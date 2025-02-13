//
//  SubscriptionCartItemsCollectionTableViewCell.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 13/02/25.
//

import UIKit

class SubscriptionCartItemsCollectionTableViewCell: UITableViewCell {

    
    @IBOutlet weak var SubscriptionName1: UILabel!
    @IBOutlet weak var selectedRange1: UILabel!
    @IBOutlet weak var subscriptionPrice1: UILabel!
    @IBOutlet weak var quantityLabel1: UILabel!
    @IBOutlet weak var increaseStepper1: UIStepper!
    
    
    var cartItem: CartItem?  // Store reference for updates

       override func awakeFromNib() {
           super.awakeFromNib()
           
          //  Configure stepper
           increaseStepper1.minimumValue = 1
           increaseStepper1.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
       }

       func configure(with item: CartItem) {
           guard let subscription = item.subscriptionDetails else { return }

           cartItem = item  // Store reference for later updates
           
           SubscriptionName1.text = "Subscription Plan"
           selectedRange1.text = "\(subscription.startDate ?? "N/A") - \(subscription.endDate ?? "N/A")"
           subscriptionPrice1.text = "₹\(subscription.totalPrice ?? 0.0)"
           quantityLabel1.text = "\(item.quantity)"
           increaseStepper1.value = Double(item.quantity)
       }

       @objc func stepperValueChanged(_ sender: UIStepper) {
           guard var cartItem = cartItem else { return }

           let newQuantity = Int(sender.value)
           quantityLabel1.text = "\(newQuantity)"
           
           // Update quantity in the cartItem model
           cartItem.quantity = newQuantity
       }
   }
