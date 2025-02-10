//
//  CartViewController.swift
//  kitchen
//
//  Created by Ravi Tiwari on 19/01/25.
//

import UIKit



class CartViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,AddItemDelegate,CartPayCellDelegate,CartItemTableViewCellDelegate {
    
    
    
    func didTapPlaceOrder() {
        
        let order = createOrderFromCart(cartItems: CartViewController.cartItems)
        OrderDataController.shared.addOrder(order: order)
        // Assuming "My Orders" is a tab in your UITabBarController
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 1 // Change this to the index of the "My Orders" tab
            
            
        }
        print("Order placed: \(order)")
        CartViewController.cartItems.removeAll() // Clear cart items after order
        CartItem.reloadData() // Reload cart table view

    }
    struct CartItem1 {
            var userAdress: String
            var quantity: Int
            var specialRequest: String?
            var menuItem: MenuItem? // Optional MenuItem
            var chefSpecialtyDish: ChefSpecialtyDish? // Optional ChefSpecialtyDish

            // Initializer for CartItem
            init(userAdress: String, quantity: Int, specialRequest: String? = nil, menuItem: MenuItem? = nil, chefSpecialtyDish: ChefSpecialtyDish? = nil) {
                self.userAdress = userAdress
                self.quantity = quantity
                self.specialRequest = specialRequest
                self.menuItem = menuItem
                self.chefSpecialtyDish = chefSpecialtyDish
            }
        }
    
    
    @IBOutlet var CartItem: UITableView!
    
    static var cartItems: [CartItem] = []
     
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Cart"
        CartItem.register(UINib(nibName: "UserCartAddress", bundle: nil), forCellReuseIdentifier: "UserCartAddress")
        
        CartItem.register(UINib(nibName: "CartPay", bundle: nil), forCellReuseIdentifier: "CartPay")
        CartItem.register(UINib(nibName: "CartItems", bundle: nil), forCellReuseIdentifier: "CartItems")
        CartItem.register(UINib(nibName: "CartDelivery", bundle: nil), forCellReuseIdentifier: "CartDelivery")
        CartItem.register(UINib(nibName: "CartBill", bundle: nil), forCellReuseIdentifier: "CartBill")
        CartItem.register(UINib(nibName: "AddItemInCart", bundle: nil), forCellReuseIdentifier: "AddItemInCart")
        CartItem.register(UITableViewCell.self, forCellReuseIdentifier: "EmptyCartPlaceholder")
        
        CartItem.delegate = self
        CartItem.dataSource = self
        CartItem.reloadData()
        
    }
    
    
    
    func createOrderFromCart(cartItems: [CartItem]) -> Order {
            // Create order items from cart items
            let orderItems = cartItems.map { cartItem -> OrderItem in
                return OrderItem(
                    menuItemID: cartItem.menuItem.itemID,
                    quantity: cartItem.quantity,
                    price: cartItem.menuItem.price * Double(cartItem.quantity)
                )
            }
            
            // Calculate the total amount from all cart items
            let totalAmount = cartItems.reduce(0.0) { $0 + ($1.menuItem.price * Double($1.quantity)) }
            
            // Get the kitchen name from the first cart item (assuming all items come from the same kitchen)
           // let kitchenName = cartItems.first?.menuItem.kitchenName ?? "Unknown Kitchen"
            
            // Create the Order object
            let order = Order(
                orderID: UUID().uuidString,  // Generate a unique order ID
                userID: "user123",           // Replace with actual user ID
                kitchenName: cartItems.first?.menuItem.kitchenName ?? "",
                kitchenID: cartItems.first?.menuItem.kitchenID ?? "",    // Pass the kitchen name here
                items: orderItems,
                status: .placed,
                totalAmount: totalAmount,
                deliveryAddress: cartItems.first?.userAdress ?? "Unknown Address",
                deliveryDate: Date(),  // Use the actual delivery date selected by the user
                deliveryType: "Delivery"  // Specify the delivery type (e.g., delivery or pickup)
            )
            
            return order
        }
        
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4 // Four sections: Address, Cart Items, Bill, and Payment
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1 // Address Section (1 row)
        case 1:
            return CartViewController.cartItems.isEmpty ? 1 : CartViewController.cartItems.count
        case 2:
            return CartViewController.cartItems.isEmpty ? 0 : 1 // Bill Section (1 row)
        case 3:
            return CartViewController.cartItems.isEmpty ? 0 : 1
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            // Address Section
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCartAddress", for: indexPath) as? UserCartAddressTableViewCell else {
                return UITableViewCell()
            }
            cell.updateAddress(with: indexPath)
            return cell
            
        case 1:
            // Cart Items Section
            if CartViewController.cartItems.isEmpty {
                // Placeholder cell for an empty cart
                let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCartPlaceholder", for: indexPath)
                cell.textLabel?.text = "Your cart is empty. Add some items!🙁"
                cell.textLabel?.textAlignment = .center
                cell.textLabel?.textColor = .gray
                
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartItems", for: indexPath) as? CartItemTableViewCell else {
                    
                    return UITableViewCell()
                }
                cell.delegate = self
//                cell.updateCartItem(for: indexPath)
                cell.updateCartItem(for: indexPath)
                return cell
            }
            
        case 2:
            
            if CartViewController.cartItems.isEmpty {
                return UITableViewCell() // No cell needed when the cart is empty
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartBill", for: indexPath) as? CartBillTableViewCell else {
                    return UITableViewCell()
                }
                let totalPrice = calculateTotalItemPrice()
                cell.itemPriceLabel.text = String(format: "₹ %.2f", totalPrice)
                
                // Example: Update other labels like GST, delivery charges, etc.
                let gst = totalPrice * 0.18 // 18% GST
                cell.gstLabel.text = String(format: "₹ %.2f", gst)
                cell.deliveryChargesLabel.text = "₹ 50.00" // Example static delivery charge
                cell.discountLabel.text = "-₹ 20.00" // Example static discount
                cell.totalAmount.text = String(format: "₹ %.2f", totalPrice + gst + 50 - 20)
                
                return cell
            }
            
        case 3:
            // Payment Section
            //            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartPay", for: indexPath) as? CartPayTableViewCell else {
            //                    return UITableViewCell()
            //                }
            //                let totalPrice = calculateTotalItemPrice()
            //                cell.TotalAmountLabel.text = String(format: "₹%.2f", totalPrice)
            //                cell.delegate = self // Assign delegate to handle button action
            //                return cell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartPay", for: indexPath) as? CartPayTableViewCell else {
                return UITableViewCell()
            }
            cell.addButtonUpdate()
            let grandTotal = calculateGrandTotal()
            cell.TotalAmountLabel.text = String(format: "₹%.2f", grandTotal)
            cell.delegate = self
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 70 // Address Section Height
        case 1:
            return 110 // Cart Item Section Height
        case 2:
            return 250 // Bill Section Height
        case 3:
            return 70// Payment Section Height
        default:
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Delivery Address"
        case 1:
            return "Cart Items"
        case 2:
            return CartViewController.cartItems.isEmpty ? nil : "Bill Summary"
        case 3:
            return CartViewController.cartItems.isEmpty ? nil : "Payment"
        default:
            return nil
        }
    }
    
    
    
    
    func presentAddItemModal(with item: MenuItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let addItemVC = storyboard.instantiateViewController(withIdentifier: "AddItemModallyViewController") as? AddItemModallyViewController {
            addItemVC.selectedItem = item
            addItemVC.delegate = self // Set the delegate
            self.present(addItemVC, animated: true, completion: nil)
        }
        
    }
    
//    func didAddItemToCart(_ item: CartItem) {
//        KitchenDataController.cartItems.append(item)
//        updateTabBarBadge()
//        CartItem.reloadData()
//        //       print("Item added to cart: \(item.menuItemID), Total items: \(KitchenDataController.cartItems.count)")
//    }
//    
    func didAddItemToCart(_ item: CartItem1) {
        // Add item to cart
               // KitchenDataController.cartItems.append!
                
                // Log based on item type
                if let menuItem = item.menuItem {
                    print("Added MenuItem to cart: \(menuItem.name), Total items: \(KitchenDataController.cartItems.count)")
                } else if let chefSpecialtyDish = item.chefSpecialtyDish {
                    print("Added ChefSpecialtyDish to cart: \(chefSpecialtyDish.name), Total items: \(KitchenDataController.cartItems.count)")
                }
                
                // Update tab bar badge and reload table
                updateTabBarBadge()
                CartItem.reloadData()
           }
    
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CartItem.reloadData()
        updateTabBarBadge()// Reload the table view when the view appears
    }
    @objc func updateCart() {
        CartItem.reloadData()
    }
    //    func calculateTotalItemPrice() -> Double {
    //        return CartViewController.cartItems.reduce(0) { $0 + ($1.MenuItem.price * Double($1.quantity)) }
    //    }
    //    func calculateTotalItemPrice() -> Double {
    //        return CartViewController.cartItems.reduce(into: 0) { total, cartItem in
    //            if let menuItem = fetchMenuItem(by: cartItem.MenuItem) {
    //                return total + (menuItem.price * Double(cartItem.quantity))
    //            }
    //            return total
    //        }
    //    }
    func calculateTotalItemPrice() -> Double {
        return CartViewController.cartItems.reduce(0) { total, cartItem in
            total + ((cartItem.menuItem?.price ?? 0) * Double(cartItem.quantity))
        }
    }
    
    
    // Example function to fetch a MenuItem by ID
    func fetchMenuItem(by id: Int) -> MenuItem? {
        return KitchenDataController.menuItems.first /*{ $0.id == id }*/
    }
    func calculateGrandTotal() -> Double {
        let totalPrice = calculateTotalItemPrice()
        let gst = totalPrice * 0.18 // 18% GST
        let deliveryCharges = 50.0
        let discount = 20.0
        return totalPrice + gst + deliveryCharges - discount
    }
    func updateTabBarBadge() {
        if let tabItems = self.tabBarController?.tabBar.items {
            let cartTabItem = tabItems[2] // Replace with the correct index for the "Cart" tab
            let itemCount = CartViewController.cartItems.count
            cartTabItem.badgeValue = itemCount > 0 ? "\(itemCount)" : nil
        }
    }

    func didTapRemoveButton(cell: CartItemTableViewCell) {
        guard let indexPath = CartItem.indexPath(for: cell) else {
            print("⚠️ Invalid indexPath: Cell not found in tableView")
            return
        }

        guard indexPath.row < KitchenDataController.cartItems.count else {
            print("⚠️ Index out of bounds: \(indexPath.row), cart count: \(KitchenDataController.cartItems.count)")
            return
        }

        // Remove the item from cart
        KitchenDataController.cartItems.remove(at: indexPath.row)

        // Check if the cart is empty after removal
        if KitchenDataController.cartItems.isEmpty {
            print("🛒 Cart is now empty, reloading table to show placeholder and other sections.")
            CartItem.reloadData() // Reload table to reflect empty cart
        } else {
            print("✅ Item removed, updating UI")
            CartItem.deleteRows(at: [indexPath], with: .fade)
        }

        updateTabBarBadge() // Update the cart badge count
    }

    func didAddItemToCart(_ item: CartItem) {
        // Add item to cart
               // KitchenDataController.cartItems.append!
                
//                // Log based on item type
//                if let menuItem = item.menuItem {
//                    print("Added MenuItem to cart: \(menuItem.name), Total items: \(KitchenDataController.cartItems.count)")
//                } else if let chefSpecialtyDish = item.chefSpecialtyDish {
//                    print("Added ChefSpecialtyDish to cart: \(chefSpecialtyDish.name), Total items: \(KitchenDataController.cartItems.count)")
//                }
                
                // Update tab bar badge and reload table
                updateTabBarBadge()
                CartItem.reloadData()
    }
    


    
}
