//
//  KitchenMenuCollectionViewCell.swift
//  kitchen
//
//  Created by Ravi Tiwari on 18/01/25.
//

import UIKit

protocol KitchenMenuDetailsCellDelegate: AnyObject {
    func KitchenMenuListaddButtonTapped(in cell: KitchenMenuCollectionViewCell)
}


class KitchenMenuCollectionViewCell: UICollectionViewCell  {
    
    var isExpanded: Bool = false

    
    @IBOutlet var vegImage: UIImageView!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var dishNameLabel: UILabel!
    @IBOutlet var dishDescription: UILabel!
    @IBOutlet var dishprice: UILabel!
    @IBOutlet var dishImge: UIImageView!
    @IBOutlet var dishTime: UILabel!
    @IBOutlet var dishDeliveryExpected: UILabel!
    
    @IBOutlet var cardViewKitchenMenu: UIView!
    @IBOutlet var dishIntakLimit: UILabel!
    
    @IBOutlet var addButton: UIButton!
    @IBOutlet var stepperStackView: UIStackView!
    @IBOutlet var quantityLabel: UILabel!
    @IBOutlet var stepper: UIStepper!
       
    

    weak var delegate: KitchenMenuDetailsCellDelegate?
          
        override func awakeFromNib() {
                  super.awakeFromNib()
                  NotificationCenter.default.addObserver(self, selector: #selector(cartUpdated), name: NSNotification.Name("CartUpdated"), object: nil)
                  NotificationCenter.default.addObserver(self, selector: #selector(handleOrderPlacement), name: NSNotification.Name("OrderPlaced"), object: nil)
          
                  // Ensure outlets are not nil before modifying them
                  if let stepperStackView = stepperStackView, let stepper = stepper {
                      stepperStackView.isHidden = true
                      stepper.layer.cornerRadius = 11
                      stepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
                  } else {
                      print("Error: stepperStackView or stepper is nil")
                  }
              }


    @objc func cartUpdated() {
        if let collectionView = self.superview as? UICollectionView,
           let indexPath = collectionView.indexPath(for: self),
           indexPath.row < KitchenDataController.menuItems.count {
            
            // Update the quantity label if the item is in the cart
            let menuItem = KitchenDataController.menuItems[indexPath.row]
            let orderedQuantity = CartViewController.cartItems
                .filter { $0.menuItem?.itemID == menuItem.itemID }
                .reduce(0) { $0 + $1.quantity }
            
            // Update UI safely
            DispatchQueue.main.async {
                if orderedQuantity > 0 {
                    self.stepperStackView.isHidden = false
                    self.addButton.isHidden = true
                    self.quantityLabel.text = "\(orderedQuantity)"
                    self.stepper.value = Double(orderedQuantity)
                } else {
                    self.stepperStackView.isHidden = true
                    self.addButton.isHidden = false
                    self.quantityLabel.text = "0"
                }
            }
            
            // Update intake limit
            updateIntakeLimit(for: indexPath)
        }
    }

    @objc private func handleOrderPlacement() {
        // Safely handle UI updates on main thread
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // Safely update stepper stack view
            if let stepperStackView = self.stepperStackView {
                stepperStackView.isHidden = true
            }
            
            // Safely update add button
            if let addButton = self.addButton {
                addButton.isHidden = false
                addButton.isEnabled = true
                addButton.alpha = 1.0
            }
        }
    }

            func updateMealDetails(with menuItem: MenuItem, at indexPath: IndexPath) {
                vegImage.image = UIImage(named: "vegImage")
                ratingLabel.text = "\(menuItem.rating)"
                dishNameLabel.text = menuItem.name
                
                // Update intake limit using the passed indexPath
                updateIntakeLimit(for: indexPath)

                let words = menuItem.description.split(separator: " ")
                if words.count > 9 {
                    let truncatedText = words.prefix(9).joined(separator: " ") + "...read more"
                    let attributedString = NSMutableAttributedString(string: truncatedText)
                    let readMoreRange = (truncatedText as NSString).range(of: "...read more")
                    
                    attributedString.addAttribute(.foregroundColor, value: UIColor.systemGreen, range: readMoreRange)
                    attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: readMoreRange)
                    
                    dishDescription.attributedText = attributedString
                    dishDescription.isUserInteractionEnabled = true
                    
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(readMoreTapped))
                    dishDescription.addGestureRecognizer(tapGesture)
                } else {
                    dishDescription.text = menuItem.description
                }

                dishTime.text = "\(menuItem.availableMealTypes.map { $0.rawValue.capitalized }.joined(separator: ", "))"
                dishDeliveryExpected.text = menuItem.orderDeadline
                dishImge.image = UIImage(named: menuItem.imageURL)
                dishprice.text = "₹\(menuItem.price)"
                dishIntakLimit.text = "Intake limit: \(menuItem.intakeLimit)"
                
                if menuItem.mealCategory.contains(.veg) {
                    vegImage.image = UIImage(systemName: "dot.square")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
                } else {
                    vegImage.image = UIImage(systemName: "dot.square")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
                }

                applyCardStyle1()
            }

            func applyCardStyle1() {
                cardViewKitchenMenu.layer.cornerRadius = 15
                cardViewKitchenMenu.layer.masksToBounds = false
                cardViewKitchenMenu.layer.shadowColor = UIColor.black.cgColor
                cardViewKitchenMenu.layer.shadowOffset = CGSize(width: 0, height: 2)
                cardViewKitchenMenu.layer.shadowRadius = 2.5
                cardViewKitchenMenu.layer.shadowOpacity = 0.4
                cardViewKitchenMenu.backgroundColor = .white
            }
           
            @IBAction func addButtonTapped(_ sender: Any) {
                delegate?.KitchenMenuListaddButtonTapped(in: self)
                
                // Hide Add Button and Show Stepper
                addButton.isHidden = true
                stepperStackView.isHidden = false

                // Set initial quantity to 1
                stepper.value = 1
                quantityLabel.text = "1"

                if let collectionView = self.superview as? UICollectionView,
                   let indexPath = collectionView.indexPath(for: self) {
                    updateIntakeLimit(for: indexPath)
                }
            }

            @objc func readMoreTapped() {
                isExpanded.toggle()

                let fullText = KitchenDataController.menuItems.first(where: { $0.name == dishNameLabel.text })?.description ?? ""
                dishDescription.text = isExpanded ? fullText : fullText.split(separator: " ").prefix(9).joined(separator: " ") + "...read more"
                
                UIView.animate(withDuration: 0.3) {
                    self.superview?.superview?.layoutIfNeeded()
                }
                
                if let collectionView = self.superview as? UICollectionView {
                    if collectionView.indexPath(for: self) != nil {
                        collectionView.performBatchUpdates(nil, completion: nil)
                    }
                }
            }


    @objc func stepperValueChanged(_ sender: UIStepper) {
        let newQuantity = Int(sender.value)
        quantityLabel.text = "\(newQuantity)"

        guard let collectionView = self.superview as? UICollectionView,
              let indexPath = collectionView.indexPath(for: self) else { return }

        let menuItem = KitchenDataController.menuItems[indexPath.row]
        // Check if this is a chef special dish
        let chefSpecial = KitchenDataController.chefSpecialtyDishes.first { $0.dishID == menuItem.itemID }
        let isChefSpecial = chefSpecial != nil

        // Find or create cart item
        if let cartItemIndex = CartViewController.cartItems.firstIndex(where: {
            if isChefSpecial {
                return $0.chefSpecial?.dishID == menuItem.itemID
            } else {
                return $0.menuItem?.itemID == menuItem.itemID
            }
        }) {
            // Update existing cart item
            CartViewController.cartItems[cartItemIndex].quantity = newQuantity
            
            if newQuantity == 0 {
                CartViewController.cartItems.remove(at: cartItemIndex)
                addButton.isHidden = false
                stepperStackView.isHidden = true
            }
        } else if newQuantity > 0 {
            // Create new cart item
            let newCartItem: CartItem
            if let chefSpecial = chefSpecial {
                newCartItem = CartItem(userAdress: "", quantity: newQuantity, chefSpecial: chefSpecial)
            } else {
                newCartItem = CartItem(userAdress: "", quantity: newQuantity, menuItem: menuItem)
            }
            CartViewController.cartItems.append(newCartItem)
            addButton.isHidden = true
            stepperStackView.isHidden = false
        }

        updateIntakeLimit(for: indexPath)
        
        // Post notification with the updated item info
        NotificationCenter.default.post(
            name: NSNotification.Name("CartUpdated"),
            object: nil,
            userInfo: [
                "menuItemID": menuItem.itemID,
                "quantity": newQuantity,
                "isChefSpecial": isChefSpecial
            ]
        )
    }





    func updateIntakeLimit(for indexPath: IndexPath) {
        let menuItem = KitchenDataController.menuItems[indexPath.row]
        let chefSpecial = KitchenDataController.chefSpecialtyDishes.first { $0.dishID == menuItem.itemID }
        let isChefSpecial = chefSpecial != nil
        
        // Get total ordered quantity from both current cart and placed orders
        let cartQuantity = CartViewController.cartItems
            .filter {
                if isChefSpecial {
                    return $0.chefSpecial?.dishID == menuItem.itemID
                } else {
                    return $0.menuItem?.itemID == menuItem.itemID
                }
            }
            .reduce(0) { $0 + $1.quantity }
        
        let placedOrdersQuantity = OrderHistoryController.placedOrders
            .flatMap { $0.items }
            .filter {
                if isChefSpecial {
                    return $0.chefSpecial?.dishID == menuItem.itemID
                } else {
                    return $0.menuItem?.itemID == menuItem.itemID
                }
            }
            .reduce(0) { $0 + $1.quantity }
        
        let totalOrderedQuantity = cartQuantity + placedOrdersQuantity
        let intakeLimit = isChefSpecial ? chefSpecial?.intakeLimit ?? menuItem.intakeLimit : menuItem.intakeLimit
        let remainingIntake = max(intakeLimit - totalOrderedQuantity, 0)

        // Update UI
        dishIntakLimit.text = "Intake limit: \(remainingIntake)"
        addButton.isEnabled = remainingIntake > 0
        addButton.alpha = remainingIntake > 0 ? 1.0 : 0.5

        // Update stepper
        stepper.maximumValue = Double(remainingIntake + cartQuantity) ?? 0.0
        stepper.minimumValue = 0
        stepper.value = Double(cartQuantity)
        stepper.isEnabled = true
        quantityLabel.text = "\(cartQuantity)"

        // Toggle visibility
        stepperStackView.isHidden = cartQuantity == 0
        addButton.isHidden = cartQuantity > 0
    }

    func setAvailability(_ isAvailable: Bool) {
        // Remove any existing blur view first
        contentView.subviews.forEach { view in
            if view is UIVisualEffectView {
                view.removeFromSuperview()
            }
        }
        
        if !isAvailable {
            // Add blur effect
            let blurEffect = UIBlurEffect(style: .light)
            let blurView = UIVisualEffectView(effect: blurEffect)
            blurView.frame = contentView.bounds
            blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            contentView.addSubview(blurView)
            contentView.sendSubviewToBack(blurView)
            
            // Disable interaction
            isUserInteractionEnabled = false
            addButton.isEnabled = false
            contentView.alpha = 0.7
        } else {
            // Enable interaction
            isUserInteractionEnabled = true
            addButton.isEnabled = true
            contentView.alpha = 1.0
        }
    }
}
