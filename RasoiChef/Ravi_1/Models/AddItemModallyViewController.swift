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
            
            // Initial stepper setup
            AddIncreaseDishButton.minimumValue = 1
            AddIncreaseDishButton.stepValue = 1
            AddIncreaseDishButton.value = 1
            AddDishItemCounterLabel.text = "1"
            
            // Add observer for cart updates
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(cartUpdated(_:)),
                name: NSNotification.Name("CartUpdated"),
                object: nil
            )
            
            if let item = selectedItem {
                setupUI(item: item)
            } else if let chefDish = selectedChefSpecialtyDish {
                setupUI(chefDish: chefDish)
            }
        }
        
        deinit {
            NotificationCenter.default.removeObserver(self)
            updateCartBadge()
        }
        
        private func setupUI(item: MenuItem) {
            AddDishNameLabel.text = item.name
            AddDishRatingLabel.text = "\(item.rating)"
            AddDishPriceLabel.text = "₹\(item.price)"
            DishDescriptionLabel.text = item.description
            AddDishRequestTextField.text = ""
            
            updateAvailability(for: item)
            
            // Load image from URL
            if let imageURL = URL(string: item.imageURL) {
                loadImage(from: imageURL)
            } else {
                AddDishImage.image = UIImage(systemName: "photo") // Fallback image
            }
            
            kitchenName.text = item.kitchenName
        }
        
        private func setupUI(chefDish: ChefSpecialtyDish) {
            AddDishNameLabel.text = chefDish.name
            AddDishRatingLabel.text = "\(chefDish.rating)"
            AddDishPriceLabel.text = "₹\(chefDish.price)"
            DishDescriptionLabel.text = chefDish.description
            AddDishRequestTextField.text = ""
            
            updateAvailability(for: chefDish)
            
            // Load image from URL
            if let imageURL = URL(string: chefDish.imageURL) {
                loadImage(from: imageURL)
            } else {
                AddDishImage.image = UIImage(systemName: "photo") // Fallback image
            }
            
            kitchenName.text = chefDish.kitchenName
        }
        
        private func updateAvailability(for item: MenuItem) {
            // Calculate available quantity
            let cartQuantity = CartViewController.cartItems
                .filter { $0.menuItem?.itemID == item.itemID }
                .reduce(0) { $0 + $1.quantity }
            
            let placedOrdersQuantity = OrderHistoryController.placedOrders
                .flatMap { $0.items }
                .filter { $0.menuItem?.itemID == item.itemID }
                .reduce(0) { $0 + $1.quantity }
            
            let totalOrdered = cartQuantity + placedOrdersQuantity
            let remainingIntake = item.intakeLimit - totalOrdered
            
            // Update stepper and button
            AddIncreaseDishButton.maximumValue = Double(remainingIntake)
            AddIncreaseDishButton.value = 1
            AddDishItemCounterLabel.text = "1"
            
            AddDishButton.isEnabled = remainingIntake > 0
            AddDishButton.alpha = remainingIntake > 0 ? 1.0 : 0.5
        }
        
        private func updateAvailability(for chefDish: ChefSpecialtyDish) {
            // Calculate available quantity
            let cartQuantity = CartViewController.cartItems
                .filter { $0.chefSpecial?.dishID == chefDish.dishID }
                .reduce(0) { $0 + $1.quantity }
            
            let placedOrdersQuantity = OrderHistoryController.placedOrders
                .flatMap { $0.items }
                .filter { $0.chefSpecial?.dishID == chefDish.dishID }
                .reduce(0) { $0 + $1.quantity }
            
            let totalOrdered = cartQuantity + placedOrdersQuantity
            let remainingIntake = chefDish.intakeLimit - totalOrdered
            
            // Update stepper and button
            AddIncreaseDishButton.maximumValue = Double(remainingIntake)
            AddIncreaseDishButton.value = 1
            AddDishItemCounterLabel.text = "1"
            
            AddDishButton.isEnabled = remainingIntake > 0
            AddDishButton.alpha = remainingIntake > 0 ? 1.0 : 0.5
        }
        
        private func configureModalSize() {
            self.modalPresentationStyle = .custom
            self.transitioningDelegate = self
        }
        
        @IBAction func stepperValueChanged(_ sender: UIStepper) {
            let newValue = Int(sender.value)
            
            UIView.animate(withDuration: 0.2) {
                self.AddDishItemCounterLabel.text = "\(newValue)"
            }
        }
        
        @IBAction func addDishButtonTapped(_ sender: UIButton) {
            let quantityToAdd = Int(AddDishItemCounterLabel.text ?? "1") ?? 1
            
            if let chefDish = selectedChefSpecialtyDish {
                // Calculate total ordered
                let cartQuantity = CartViewController.cartItems
                    .filter { $0.chefSpecial?.dishID == chefDish.dishID }
                    .reduce(0) { $0 + $1.quantity }
                
                let placedOrdersQuantity = OrderHistoryController.placedOrders
                    .flatMap { $0.items }
                    .filter { $0.chefSpecial?.dishID == chefDish.dishID }
                    .reduce(0) { $0 + $1.quantity }
                
                let newTotal = placedOrdersQuantity + quantityToAdd
                
                if newTotal > chefDish.intakeLimit {
                    return
                }
                
                let cartItem = CartItem(
                    userAdress: "Galgotias University",
                    quantity: quantityToAdd,
                    specialRequest: AddDishRequestTextField.text ?? "",
                    chefSpecial: chefDish
                )
                
                CartViewController.cartItems.append(cartItem)
                
                // Update badge count
                updateCartBadge()
                
                // Show banner in parent view
                if let parentVC = self.presentingViewController {
                    let banner = BannerView()
                    banner.show(message: "\(quantityToAdd) item added", in: parentVC)
                }
                
                // Update UI before dismissing
                UIView.animate(withDuration: 0.2) {
                    self.AddDishButton.isEnabled = false
                    self.AddDishButton.alpha = 0.5
                    self.AddIncreaseDishButton.isEnabled = false
                }
                
                NotificationCenter.default.post(
                    name: NSNotification.Name("CartUpdated"),
                    object: nil,
                    userInfo: [
                        "menuItemID": chefDish.dishID,
                        "quantity": quantityToAdd,
                        "isChefSpecial": true,
                        "isInitialAdd": true
                    ]
                )
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.dismiss(animated: true)
                }
            } else if let item = selectedItem {
                // Check remaining intake for menu item
                let cartQuantity = CartViewController.cartItems
                    .filter { $0.menuItem?.itemID == item.itemID }
                    .reduce(0) { $0 + $1.quantity }
                
                let placedOrdersQuantity = OrderHistoryController.placedOrders
                    .flatMap { $0.items }
                    .filter { $0.menuItem?.itemID == item.itemID }
                    .reduce(0) { $0 + $1.quantity }
                
                let newTotal = cartQuantity + placedOrdersQuantity + quantityToAdd
                
                if newTotal > item.intakeLimit {
                    return
                }
                
                let cartItem = CartItem(
                    userAdress: "Galgotias University",
                    quantity: quantityToAdd,
                    specialRequest: AddDishRequestTextField.text ?? "",
                    menuItem: item
                )
                
                CartViewController.cartItems.append(cartItem)
                
                // Update badge count
                updateCartBadge()
                
                // Show banner in parent view
                if let parentVC = self.presentingViewController {
                    let banner = BannerView()
                    banner.show(message: "\(quantityToAdd) item added", in: parentVC)
                }
                
                // Update UI before dismissing
                UIView.animate(withDuration: 0.3) {
                    self.AddDishButton.isEnabled = false
                    self.AddDishButton.alpha = 0.5
                    self.AddIncreaseDishButton.isEnabled = false
                }
                
                NotificationCenter.default.post(
                    name: NSNotification.Name("CartUpdated"),
                    object: nil,
                    userInfo: [
                        "menuItemID": item.itemID,
                        "quantity": quantityToAdd,
                        "isChefSpecial": false
                    ]
                )
                
                // Delay dismiss to show UI update
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
        @objc private func cartUpdated(_ notification: Notification) {
            if let item = selectedItem {
                updateAvailability(for: item)
            } else if let chefDish = selectedChefSpecialtyDish {
                updateAvailability(for: chefDish)
            }
        }
        
        @IBAction func crossButtonTapped(_ sender: Any) {
            self.dismiss(animated: true)
        }
        
        private func updateCartBadge() {
            if let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController {
                if let tabItems = tabBarController.tabBar.items {
                    let cartTabItem = tabItems[2] // Cart tab is at index 2
                    let itemCount = CartViewController.cartItems.count
                    cartTabItem.badgeValue = itemCount > 0 ? "\(itemCount)" : nil
                }
            }
        }
        
        private func loadImage(from url: URL) {
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self,
                      let data = data,
                      let image = UIImage(data: data) else {
                    DispatchQueue.main.async {
                        self?.AddDishImage.image = UIImage(systemName: "photo") // Fallback image
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    self.AddDishImage.image = image
                }
            }.resume()
        }
    }
