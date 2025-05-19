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
    
    // Add standard meal type order
    static let standardMealOrder: [MealType] = [.breakfast, .lunch, .snacks, .dinner]
    
    var isExpanded: Bool = false
    var selectedDay: WeekDay = .monday // Default to Monday

    
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
                  
                  // Debug prints to identify nil outlets
//                  print("=== IBOutlet Debug ===")
//                  print("dishNameLabel: \(dishNameLabel != nil)")
//                  print("ratingLabel: \(ratingLabel != nil)")
//                  print("dishprice: \(dishprice != nil)")
//                  print("dishTime: \(dishTime != nil)")
//                  print("dishDeliveryExpected: \(dishDeliveryExpected != nil)")
//                  print("dishDescription: \(dishDescription != nil)")
//                  print("dishImge: \(dishImge != nil)")
//                  print("vegImage: \(vegImage != nil)")
//                  print("cardViewKitchenMenu: \(cardViewKitchenMenu != nil)")
//                  print("dishIntakLimit: \(dishIntakLimit != nil)")
//                  print("addButton: \(addButton != nil)")
//                  print("stepperStackView: \(stepperStackView != nil)")
//                  print("quantityLabel: \(quantityLabel != nil)")
//                  print("stepper: \(stepper != nil)")
                  
                  // Set up observers
                  NotificationCenter.default.addObserver(
                      self,
                      selector: #selector(cartUpdated),
                      name: NSNotification.Name("CartUpdated"),
                      object: nil
                  )
                  
                  NotificationCenter.default.addObserver(
                      self,
                      selector: #selector(handleOrderPlacement),
                      name: NSNotification.Name("OrderPlaced"),
                      object: nil
                  )
                  
                  // Initial stepper setup - with safe unwrapping
                  if let stepper = stepper {
                      stepper.minimumValue = 0
                      stepper.stepValue = 1
                      stepper.layer.cornerRadius = 11
                      stepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
                  }
                  
                  // Initial UI state - with safe unwrapping
                  stepperStackView?.isHidden = true
                  addButton?.isHidden = false
                  quantityLabel?.text = "0"
                  
                  // Apply initial styling
                  setupCardStyle()
              }

    deinit {
        NotificationCenter.default.removeObserver(self)
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

    func checkAvailability(for menuItem: MenuItem) -> Bool {
        let currentHour = Calendar.current.component(.hour, from: Date())
        
        // Check time-based availability
        let isAvailable: Bool = {
            guard let mealType = menuItem.availableMealTypes else {
                return false
            }
            switch mealType {
            case .breakfast where currentHour < 6:   return true  // Until 6 AM
            case .lunch where currentHour < 11:      return true  // Until 11 AM
            case .snacks where currentHour < 15:     return true  // Until 3 PM
            case .dinner where currentHour < 19:     return true  // Until 7 PM
            default: return false
            }
        }()
        
        // Check intake limit
        let hasAvailableIntake = menuItem.intakeLimit > 0
        
        return isAvailable && hasAvailableIntake
    }

    func updateMealDetails(with menuItem: MenuItem, at indexPath: IndexPath) {
        // Update meal name and price
        dishNameLabel.text = menuItem.name
        dishprice.text = "₹\(menuItem.price)"
        
        // Update rating
        ratingLabel.text = String(format: "%.1f", menuItem.rating)
        
        // Update meal image
        if let imageURL = URL(string: menuItem.imageURL) {
            loadImage(from: imageURL)
        } else {
            dishImge.image = UIImage(systemName: "photo") // Fallback image
        }
        
        // Update meal type and timing details
        if let mealType = menuItem.availableMealTypes {
            dishTime.text = mealType.rawValue.capitalized
        } else {
            dishTime.text = "Not specified"
        }
        
        // Update delivery time
        if let receivingTime = menuItem.recievingDeadline {
            dishDeliveryExpected.text = "Delivery Expected by \(receivingTime)"
        }
        
        // Update description
        dishDescription.text = menuItem.description
        
        // Update intake limit
        updateIntakeLimit(for: indexPath)
        
        // Apply card style
        applyCardStyle1()
        
        // Set up stepper
        stepper.minimumValue = 0
        stepper.stepValue = 1
        stepper.layer.cornerRadius = 11
        stepperStackView.spacing = 8
        
        // Check cart state
        let cartQuantity = CartViewController.cartItems
            .filter { $0.menuItem?.itemID == menuItem.itemID }
            .reduce(0) { $0 + $1.quantity }
        
        // Update UI based on cart state
        stepperStackView.isHidden = cartQuantity == 0
        addButton.isHidden = cartQuantity > 0
        stepper.value = Double(cartQuantity)
        quantityLabel.text = "\(cartQuantity)"
    }

    private func setupCardStyle() {
        // Ensure the card view exists before applying styles
        guard let cardView = cardViewKitchenMenu else { return }
        
        cardView.layer.cornerRadius = 15
        cardView.layer.masksToBounds = false
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 2.5
        cardView.layer.shadowOpacity = 0.4
        cardView.backgroundColor = .white
    }

    func applyCardStyle1() {
        setupCardStyle()
    }
   
    @IBAction func addButtonTapped(_ sender: Any) {
        delegate?.KitchenMenuListaddButtonTapped(in: self)
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

    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        guard let collectionView = self.superview as? UICollectionView,
              let indexPath = collectionView.indexPath(for: self) else { return }
        
        let menuItems = KitchenDataController.filteredMenuItems.filter { $0.availableDays == selectedDay }
        guard indexPath.row < menuItems.count else { return }
        let menuItem = menuItems[indexPath.row]
        
        let newQuantity = Int(sender.value)
        
        // Animate quantity label update
        UIView.transition(with: quantityLabel, duration: 0.2, options: .transitionCrossDissolve) {
            self.quantityLabel.text = "\(newQuantity)"
        }
        
        if newQuantity == 0 {
            // Animate visibility changes
            UIView.animate(withDuration: 0.3) {
                self.stepperStackView.isHidden = true
                self.addButton.isHidden = false
            }
            CartViewController.cartItems.removeAll { $0.menuItem?.itemID == menuItem.itemID }
        } else {
            if let existingItemIndex = CartViewController.cartItems.firstIndex(where: { $0.menuItem?.itemID == menuItem.itemID }) {
                CartViewController.cartItems[existingItemIndex].quantity = newQuantity
            } else {
                CartViewController.cartItems.append(CartItem(userAdress: "", quantity: newQuantity, menuItem: menuItem))
            }
        }
        
        NotificationCenter.default.post(
            name: NSNotification.Name("CartUpdated"),
            object: nil,
            userInfo: [
                "menuItemID": menuItem.itemID,
                "quantity": newQuantity,
                "isChefSpecial": false
            ]
        )
        
        updateIntakeLimit(for: indexPath)
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

    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.dishImge.image = UIImage(named: "defaultFoodImage")
                }
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.dishImge.image = image
                }
            } else {
                DispatchQueue.main.async {
                    self?.dishImge.image = UIImage(named: "defaultFoodImage")
                }
            }
        }.resume()
    }
}
