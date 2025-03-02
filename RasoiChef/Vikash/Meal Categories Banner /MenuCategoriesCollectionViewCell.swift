//
//  MenuCategoriesCollectionViewCell.swift
//  RasoiChef
//
//  Created by Batch - 1 on 24/01/25.
//

import UIKit

class MenuCategoriesCollectionViewCell: UICollectionViewCell {
        
    var mealTiming:MealTiming = .breakfast
    
    weak var delegate: MealCategoriesCollectionViewCellDelegate?

    @IBOutlet weak var mealImage: UIImageView!
    
    @IBOutlet weak var mealNameLabel: UILabel!
    
    @IBOutlet weak var kitchenNameLabel: UILabel!
    @IBOutlet weak var orderIntakeLimitLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var KitchenDistance: UILabel!
    
    @IBOutlet weak var Ratings: UILabel!
    
    @IBOutlet weak var vegNonVegIcon: UIImageView!
    
    @IBOutlet var stepperStackView: UIStackView!
    @IBOutlet var quantityLabel: UILabel!
    @IBOutlet var stepper: UIStepper!
    
    
    var menuItem: MenuItem?

    override func awakeFromNib() {
            super.awakeFromNib()
            stepperStackView.isHidden = true  // Hide stepper initially
            
            NotificationCenter.default.addObserver(self, selector: #selector(updateCartUI(_:)), name: NSNotification.Name("CartUpdated"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(updateCellUI(_:)), name: NSNotification.Name("UpdateMenuCategoryCell"), object: nil)
            
            NotificationCenter.default.addObserver(
self,selector: #selector(handleOrderPlacement),name: NSNotification.Name("OrderPlaced"),object: nil
            )

        


            stepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
        }
    
    
    func updateMealDetails(with menuItem: MenuItem) {
        self.menuItem = menuItem
        mealNameLabel.text = menuItem.name
        mealImage.image = UIImage(named: menuItem.imageURL ?? "")
        kitchenNameLabel.text = menuItem.kitchenName
        KitchenDistance.text = "\(menuItem.distance) km"
        Ratings.text = "\(menuItem.rating)"
        orderIntakeLimitLabel.text = "Intake limit: \(String(describing: menuItem.intakeLimit))"
        priceLabel.text = "₹\(menuItem.price)"
        descriptionLabel.text = menuItem.description

        if menuItem.mealCategory.contains(.veg) {
            vegNonVegIcon.image = UIImage(systemName: "dot.square")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
        } else {
            vegNonVegIcon.image = UIImage(systemName: "dot.square")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        }
        
        updateUIFromCart()
        // Disable "Add" button based on time
//            let currentHour = Calendar.current.component(.hour, from: Date())
//
//            switch mealTiming {
//            case .breakfast:
//                addButton.isEnabled = !(currentHour >= 7 && currentHour < 21)
//            case .lunch:
//                addButton.isEnabled = !(currentHour >= 11 && currentHour < 21)
//            case .snacks:
//                addButton.isEnabled = !(currentHour >= 16 && currentHour < 21)
//            case .dinner:
//                addButton.isEnabled = !(currentHour >= 20 && currentHour < 21)
//            }
//
//            if currentHour >= 21 || currentHour < 7 {
//                addButton.isEnabled = true // Re-enable after 9 PM
//            }
//
//            addButton.alpha = addButton.isEnabled ? 1.0 : 0.8
        
        
    }

    
    
    
    

    
    @IBAction func addButtonTapped(_ sender: Any) {
            delegate?.MealcategoriesButtonTapped(in: self)
        }

    @objc func stepperValueChanged(_ sender: UIStepper) {
        guard let menuItem = menuItem else { return }

        let maxLimit = menuItem.intakeLimit // Get available intake limit
        let newQuantity = min(Int(sender.value), maxLimit) // Prevent exceeding limit

        sender.value = Double(newQuantity) // Update stepper
        quantityLabel.text = "\(newQuantity)"

        if newQuantity == 0 {
            stepperStackView.isHidden = true
            addButton.isHidden = false
            removeItemFromCart()
        } else {
            updateCart(with: newQuantity)
        }
    }
    

    private func updateUIFromCart() {
        guard let item = menuItem else { return }

        let quantityInCart = CartViewController.cartItems
            .filter { $0.menuItem?.itemID == item.itemID }
            .reduce(0) { $0 + $1.quantity }

        updateStepperState(quantity: quantityInCart)
    }


        private func updateStepperState(quantity: Int) {
            if quantity > 0 {
                stepperStackView.isHidden = false
                addButton.isHidden = true
                stepper.value = Double(quantity)
                quantityLabel.text = "\(quantity)"
            } else {
                stepperStackView.isHidden = true
                addButton.isHidden = false
            }
        }

        private func updateCart(with quantity: Int) {
            NotificationCenter.default.post(
                name: NSNotification.Name("CartUpdated"),
                object: nil,
                userInfo: ["menuItemID": menuItem?.itemID ?? "", "quantity": quantity]
            )
        }

        private func removeItemFromCart() {
            NotificationCenter.default.post(
                name: NSNotification.Name("CartUpdated"),
                object: nil,
                userInfo: ["menuItemID": menuItem?.itemID ?? "", "quantity": 0]
            )
        }

    @objc private func updateCartUI(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let menuItemID = userInfo["menuItemID"] as? String,
              let quantity = userInfo["quantity"] as? Int,
              menuItemID == menuItem?.itemID else { return }

        updateStepperState(quantity: quantity)
    }


        @objc private func updateCellUI(_ notification: Notification) {
            guard let userInfo = notification.userInfo,
                  let updatedItemID = userInfo["menuItemID"] as? String,
                  let menuItem = menuItem else { return }

            if menuItem.itemID == updatedItemID {
                let cartQuantity = CartViewController.cartItems
                    .filter { $0.menuItem?.itemID == menuItem.itemID }
                    .reduce(0) { $0 + $1.quantity }

                updateStepperState(quantity: cartQuantity)
            }
        }

        deinit {
            NotificationCenter.default.removeObserver(self)
        }
    
    @objc private func handleOrderPlacement() {
        guard let menuItem = menuItem else { return }

        if menuItem.intakeLimit == 0 {
            addButton.isEnabled = false
            addButton.alpha = 0.5 // Visually indicate it's disabled
        }
    }

}
//}
