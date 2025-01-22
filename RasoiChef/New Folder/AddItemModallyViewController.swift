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
    var cartItems: [CartItem] = []

    weak var delegate: AddItemDelegate?
    
    
    @IBOutlet var AddDishNameLabel: UILabel!
    
    @IBOutlet var AddDishRatingLabel: UILabel!
    @IBOutlet var AddDishPriceLabel: UILabel!
    @IBOutlet var DishDescriptionLabel: UILabel!
    @IBOutlet var AddDishButton: UIButton!
    @IBOutlet var AddDishRequestTextField: UITextField!
    
    @IBOutlet var AddDishItemCounterLabel: UILabel!
    @IBOutlet var AddIncreaseDishButton: UIStepper!
    
    
    var selectedItem: MenuItem? // Replace MenuItem with the actual type of your menu item
    var menuItems: [MenuItem] = []
    
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
        
        // Set default values for other fields
        AddDishRequestTextField.text = ""
        AddDishItemCounterLabel.text = "1"
        AddIncreaseDishButton.value = 1 // Default stepper value
        // Use selectedItem as needed
        if selectedItem != nil {
            //                print("Received item: \(item.name)") // Adjust for your MenuItem structure
        }
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
            
            // Create a new CartItem instance
            let cartItem = CartItem(
                userAdress: "nil", // Replace "nil" with an actual address if needed
                cartItemID: UUID().uuidString,
                menuItemID: item.kitchenID, // Ensure `MenuItem` has a `kitchenID` property
                quantity: quantity,
                specialRequest: specialRequest,
                menuItem: item
            )
            
            // Pass the cartItem to the CartViewController via delegate
            delegate?.didAddItemToCart(cartItem)
            
            // Dismiss the modal
            self.dismiss(animated: true, completion: nil)
        }
        
       
        
    }


    

