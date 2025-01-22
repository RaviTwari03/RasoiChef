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
    var menuItems: [MenuItem] = []
    
    
    
    
    
    @IBOutlet var AddDishNameLabel: UILabel!
    
    @IBOutlet var AddDishRatingLabel: UILabel!
    @IBOutlet var AddDishPriceLabel: UILabel!
    @IBOutlet var DishDescriptionLabel: UILabel!
    @IBOutlet var AddDishButton: UIButton!
    @IBOutlet var AddDishRequestTextField: UITextField!
    
    @IBOutlet var AddDishItemCounterLabel: UILabel!
    @IBOutlet var AddIncreaseDishButton: UIStepper!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureModalSize()
        guard let item = selectedItem else {
            print("Error: No item data passed.")
            return}
        
        AddDishNameLabel.text = item.name
        AddDishRatingLabel.text = "⭐ \(item.rating)"
        AddDishPriceLabel.text = "₹\(item.price)"
        DishDescriptionLabel.text = item.description
        
       
        AddDishRequestTextField.text = ""
        AddDishItemCounterLabel.text = "1"
        AddIncreaseDishButton.value = 1
    
       
    }
    private func configureModalSize() {
        // Set the modal presentation style
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    func presentAddItemModally(selectedItem: MenuItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let addItemVC = storyboard.instantiateViewController(withIdentifier: "AddItemModallyViewController") as? AddItemModallyViewController {
            addItemVC.selectedItem = selectedItem // Pass the selected item here
            self.present(addItemVC, animated: true, completion: nil)
        }
    }
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        AddDishItemCounterLabel.text = "\(Int(sender.value))"
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfScreenPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    
    
    
    //    MARK: - For cart
  
    @IBAction func addDishButtonTapped(_ sender: UIButton) {
        guard let item = selectedItem else { return }
        let quantity = Int(AddDishItemCounterLabel.text ?? "1") ?? 1
        let specialRequest = AddDishRequestTextField.text ?? ""

     
        let cartItem = CartItem(
            userAdress: "Galgotias University", // Replace "nil" with an actual address if needed
            
           
            quantity: quantity,
            specialRequest: specialRequest,
            menuItem: MenuItem(
                itemID: "item001",
                kitchenID: "kitchen001",
                name: "Vegetable Poha",
                description: "A light, nutritious dish made with flattened rice, salted veggies, and flavorful spices.",
                price: 70.0,
                rating: 4.1,
                availableMealTypes: [.breakfast],
                portionSize: "250 gm",
                intakeLimit: 20,
                imageURL: "VegetablePoha",
                orderDeadline: "Order Before 6 am."
            ),
            MenuItem(
                itemID: "item002",
                kitchenID: "kitchen001",
                name: "Veg Thali",
                description: "A hearty combo of Veg Soya Keema, Arhar Dal, Butter Rotis, Plain Rice, and Mix Veg.",
                price: 130.0,
                rating: 4.4,
                availableMealTypes: [.lunch],
                portionSize: "500 gm",
                intakeLimit: 15,
                imageURL: "VegThali",
                orderDeadline: "Order Before 11 am."
                
            ),
            MenuItem(
                itemID: "item003",
                kitchenID: "kitchen001",
                name: "Spring Roll",
                description: "Crispy rolls stuffed with spiced veggies, perfect for a delightful snack.",
                price: 50.0,
                rating: 4.3,
                availableMealTypes: [.snacks],
                portionSize: "6 pieces",
                intakeLimit: 10,
                imageURL: "SpringRoll",
                orderDeadline: "Order Before 3 pm."
            ),
            MenuItem(
                itemID: "item004",
                kitchenID: "kitchen002",
                name: "Masala Dosa",
                description: "A crispy rice pancake filled with spiced potato filling, served with chutneys and sambar.",
                price: 120.0,
                rating: 4.5,
                availableMealTypes: [.dinner],
                portionSize: "1 piece",
                intakeLimit: 25,
                imageURL: "MasalaDosa",
                orderDeadline: "Order Before 7 pm."
            ))
        KitchenDataController.cartItems.append(cartItem)
            print("Item added to cart: \(cartItem)")  // Log the added item
//            CartItem.reloadData()  // Refresh the table view
            

       
        CartViewController.cartItems.append(cartItem)
        if self.presentingViewController != nil {
            self.dismiss(animated: true, completion: nil)
        }
    }

        
    }



