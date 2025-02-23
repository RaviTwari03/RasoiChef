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
            
            orderedQuantity = getTotalOrderedQuantity(for: item.itemID)
            
            let intakeLimit = item.intakeLimit
            AddIncreaseDishButton.minimumValue = 1
            AddIncreaseDishButton.maximumValue = Double(intakeLimit - orderedQuantity)  // Set max limit based on remaining
            AddIncreaseDishButton.value = 1
            
            AddDishItemCounterLabel.text = "1"
            AddDishImage.image = UIImage(named: item.imageURL)
            kitchenName.text = item.kitchenName
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
        
        // Function to get total ordered quantity for an item
        private func getTotalOrderedQuantity(for itemId: String) -> Int {
            return CartViewController.cartItems.filter { $0.menuItem?.itemID == itemId || $0.chefSpecial?.dishID == itemId }.reduce(0) { $0 + $1.quantity }
        }
        
        @IBAction func stepperValueChanged(_ sender: UIStepper) {
            let intakeLimit = selectedItem?.intakeLimit ?? selectedChefSpecialtyDish?.intakeLimit ?? 1
            let remainingLimit = intakeLimit - orderedQuantity
            
            if Int(sender.value) > remainingLimit {
                sender.value = Double(remainingLimit)  // Reset to max remaining
                showAlert(message: "You cannot add more than the intake limit.")
            }
            AddDishItemCounterLabel.text = "\(Int(sender.value))"
        }
        
        private func showAlert(message: String) {
            let alert = UIAlertController(title: "Limit Exceeded",
                                          message: message,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }

    
    
    
    //    MARK: - For cart
  
    @IBAction func addDishButtonTapped(_ sender: UIButton) {

        let quantityToAdd = Int(AddDishItemCounterLabel.text ?? "1") ?? 1
               let specialRequest = AddDishRequestTextField.text ?? ""
               
               let intakeLimit = selectedItem?.intakeLimit ?? selectedChefSpecialtyDish?.intakeLimit ?? 1
        orderedQuantity = getTotalOrderedQuantity(for: selectedItem?.itemID ?? selectedChefSpecialtyDish?.dishID ?? "")

               if orderedQuantity + quantityToAdd > intakeLimit {
                   showAlert(message: "You have reached the intake limit for this item.")
                   return
               }
               
               var cartItem: CartItem?
               
               if let item = selectedItem {
                   cartItem = CartItem(
                       userAdress: "Galgotias University",
                       quantity: quantityToAdd,
                       specialRequest: specialRequest,
                       menuItem: item
                   )
               } else if let chefDish = selectedChefSpecialtyDish {
                   cartItem = CartItem(
                       userAdress: "Galgotias University",
                       quantity: quantityToAdd,
                       specialRequest: specialRequest,
                       chefSpecial: chefDish
                   )
               }
               
               guard let cartItem = cartItem else {
                   print("Error: No valid item selected to add to cart.")
                   return
               }
               
               CartViewController.cartItems.append(cartItem)
               KitchenDataController.cartItems = CartViewController.cartItems
               
               NotificationCenter.default.post(name: NSNotification.Name("CartUpdated"), object: nil)
               
               if self.presentingViewController != nil {
                   self.dismiss(animated: true, completion: nil)
               }
           }
           
           @IBAction func crossButtonTapped(_ sender: Any) {
               self.dismiss(animated: true)
           }
       }
