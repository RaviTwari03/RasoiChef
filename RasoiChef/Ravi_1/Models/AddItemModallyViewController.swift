//
//  AddItemModallyViewController.swift
//  kitchen
//
//  Created by Ravi Tiwari on 18/01/25.
//

import UIKit

protocol AddItemDelegate: AnyObject {
    func didAddItemToCart(_ item: CartItem)
   
}


class AddItemModallyViewController: UIViewController, UIViewControllerTransitioningDelegate {
    weak var delegate: AddItemDelegate?
    
    var selectedItem: MenuItem?
    var selectedChefSpecialtyDish: ChefSpecialtyDish?

@IBOutlet var AddDishNameLabel: UILabel!
    
    @IBOutlet var AddDishRatingLabel: UILabel!
    @IBOutlet var AddDishPriceLabel: UILabel!
    @IBOutlet var DishDescriptionLabel: UILabel!
    @IBOutlet var AddDishButton: UIButton!
    @IBOutlet var AddDishRequestTextField: UITextField!
    
    @IBOutlet var AddDishItemCounterLabel: UILabel!
    @IBOutlet var AddIncreaseDishButton: UIStepper!
    
    @IBOutlet weak var AddDishImage: UIImageView!
    
    @IBOutlet weak var kitchenName: UILabel!
    


    
    var orderedQuantity: Int = 0  // Tracks total ordered quantity
        
        override func viewDidLoad() {
            super.viewDidLoad()
            configureModalSize()
            AddDishButton.layer.cornerRadius = 11
            NotificationCenter.default.post(name: NSNotification.Name("CartUpdated"), object: nil)
            if let item = selectedItem {
                setupUI(item: item)
            } else if let chefDish = selectedChefSpecialtyDish {
                setupUI(chefDish: chefDish)
            } else {
                print("Error: No data passed.")
            }
        }
        
        private func setupUI(item: MenuItem) {
            AddDishNameLabel.text = item.name
            AddDishRatingLabel.text = "\(item.rating)"
            AddDishPriceLabel.text = "₹\(item.price)"
            DishDescriptionLabel.text = item.description
            AddDishRequestTextField.text = ""
            
            updateIntakeLimits(for: item)
            
            AddDishImage.image = UIImage(named: item.imageURL)
            kitchenName.text = item.kitchenName
        }
        
        private func updateIntakeLimits(for item: MenuItem) {
            // Get current quantities
            let cartQuantity = CartViewController.cartItems
                .filter { $0.menuItem?.itemID == item.itemID }
                .reduce(0) { $0 + $1.quantity }
            
            let placedOrdersQuantity = OrderHistoryController.placedOrders
                .flatMap { $0.items }
                .filter { $0.menuItem?.itemID == item.itemID }
                .reduce(0) { $0 + $1.quantity }
            
            orderedQuantity = cartQuantity + placedOrdersQuantity
            let remainingIntake = max(0, item.intakeLimit - orderedQuantity)
            
            // Update stepper
            AddIncreaseDishButton.minimumValue = 1
            AddIncreaseDishButton.maximumValue = Double(remainingIntake)
            AddIncreaseDishButton.value = remainingIntake > 0 ? 1 : 0
            
            // Update UI
            AddDishItemCounterLabel.text = "\(Int(AddIncreaseDishButton.value))"
            AddDishButton.isEnabled = remainingIntake > 0
            AddDishButton.alpha = remainingIntake > 0 ? 1.0 : 0.5
        }
        
        private func setupUI(chefDish: ChefSpecialtyDish) {
            AddDishNameLabel.text = chefDish.name
            AddDishRatingLabel.text = "\(chefDish.rating)"
            AddDishPriceLabel.text = "₹\(chefDish.price)"
            DishDescriptionLabel.text = chefDish.description
            AddDishRequestTextField.text = ""
            
            orderedQuantity = getTotalOrderedQuantity(for: chefDish.dishID)
            
            let intakeLimit = chefDish.intakeLimit
            AddIncreaseDishButton.minimumValue = 1
            AddIncreaseDishButton.maximumValue = Double(intakeLimit - orderedQuantity)  // Set max limit based on remaining
            AddIncreaseDishButton.value = 1
            
            AddDishItemCounterLabel.text = "1"
            AddDishImage.image = UIImage(named: chefDish.imageURL)
            kitchenName.text = chefDish.kitchenName
        }
        
        private func configureModalSize() {
            self.modalPresentationStyle = .custom
            self.transitioningDelegate = self
        }
        
        private func getTotalOrderedQuantity(for itemId: String) -> Int {
            let cartQuantity = CartViewController.cartItems
                .filter { $0.menuItem?.itemID == itemId }
                .reduce(0) { $0 + $1.quantity }
            
            let placedOrdersQuantity = OrderHistoryController.placedOrders
                .flatMap { $0.items }
                .filter { $0.menuItem?.itemID == itemId }
                .reduce(0) { $0 + $1.quantity }
            
            return cartQuantity + placedOrdersQuantity
        }
        
        @IBAction func stepperValueChanged(_ sender: UIStepper) {
            guard let item = selectedItem else { return }
            
            let newTotal = orderedQuantity + Int(sender.value)
            if newTotal > item.intakeLimit {
                sender.value = Double(item.intakeLimit - orderedQuantity)
                showAlert(message: "Cannot exceed intake limit of \(item.intakeLimit).\nAlready ordered: \(orderedQuantity)")
                return
            }
            
            AddDishItemCounterLabel.text = "\(Int(sender.value))"
        }
        
        private func showAlert(message: String) {
            let alert = UIAlertController(
                title: "Intake Limit",
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }

    
    
    
    //    MARK: - For cart
  
    @IBAction func addDishButtonTapped(_ sender: UIButton) {
        guard let item = selectedItem else { return }
        
        let quantityToAdd = Int(AddDishItemCounterLabel.text ?? "1") ?? 1
        let newTotal = orderedQuantity + quantityToAdd
        
        if newTotal > item.intakeLimit {
            showAlert(message: "Cannot add \(quantityToAdd) items.\nAlready ordered: \(orderedQuantity)\nTotal limit: \(item.intakeLimit)")
            return
        }
        
        let cartItem = CartItem(
            userAdress: "Galgotias University",
            quantity: quantityToAdd,
            specialRequest: AddDishRequestTextField.text ?? "",
            menuItem: item
        )
        
        CartViewController.cartItems.append(cartItem)
        KitchenDataController.cartItems = CartViewController.cartItems
        
        NotificationCenter.default.post(
            name: NSNotification.Name("CartUpdated"),
            object: nil,
            userInfo: [
                "menuItemID": item.itemID,
                "quantity": quantityToAdd,
                "isChefSpecial": false
            ]
        )
        
        dismiss(animated: true, completion: nil)
    }
           
           @IBAction func crossButtonTapped(_ sender: Any) {
               self.dismiss(animated: true)
           }
       }
