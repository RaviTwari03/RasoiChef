//
//  CartViewController.swift
//  kitchen
//
//  Created by Ravi Tiwari on 19/01/25.
//

import UIKit



class CartViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,AddItemDelegate,CartPayCellDelegate,CartItemTableViewCellDelegate,SubscribeYourPlanButtonDelegate {
 
    
  
   
    @IBOutlet var CartItem: UITableView!

    var cartItems: [CartItem] = []
       var totalPrice: Int = 0

       static var cartItems: [CartItem] = []
       static var subscriptionPlan1 : [SubscriptionPlan] = []
      
       func didTapPlaceOrder() {
           let order = createOrderFromCart(cartItems: CartViewController.cartItems)
           OrderDataController.shared.addOrder(order: order)

           let banner = CustomBannerView()
              banner.show(in: self.view, message: "Order Placed Successfully!")
              
           // Clear cart items and reload table view
           CartViewController.cartItems.removeAll() // Clear cart items after order
           CartItem.reloadData() // Reload cart table view
           
           // Notify MyOrdersViewController to reload data
                  MyOrdersViewController.shared.loadData()
          
           // Add a delay before changing the tab, to allow the user to see the pop-up
           DispatchQueue.main.asyncAfter(deadline: .now() + 3) { // After banner is gone
                   if let tabBarController = self.tabBarController {
                       tabBarController.selectedIndex = 1 // Change this to the index of the "My Orders" tab
                   }
               }
       }
    
       override func viewDidLoad() {
           super.viewDidLoad()
           self.title = "Cart"
          
        
           
           CartItem.register(UINib(nibName: "UserCartAddress", bundle: nil), forCellReuseIdentifier: "UserCartAddress")
           
           CartItem.register(UINib(nibName: "CartPay", bundle: nil), forCellReuseIdentifier: "CartPay")
           CartItem.register(UINib(nibName: "CartItems", bundle: nil), forCellReuseIdentifier: "CartItems")
           CartItem.register(UINib(nibName: "SubscriptionCartItems", bundle: nil), forCellReuseIdentifier: "SubscriptionCartItems")
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
                       menuItemID: cartItem.menuItem?.name ?? " ",
                       quantity: cartItem.quantity,
                       price: (cartItem.menuItem?.price ?? 0) * Double(cartItem.quantity)
                   )
               }
               
               // Calculate the total amount from all cart items
           let totalAmount = cartItems.reduce(0.0) { $0 + (($1.menuItem?.price ?? 0) * Double($1.quantity)) }
               
               // Get the kitchen name from the first cart item (assuming all items come from the same kitchen)
              // let kitchenName = cartItems.first?.menuItem.kitchenName ?? "Unknown Kitchen"
               
               // Create the Order object
               let order = Order(
                   orderID: String(UUID().uuidString.replacingOccurrences(of: "-", with: "").prefix(4)),  // Generate a unique order ID
                   userID: "user123",           // Replace with actual user ID
                   kitchenName: cartItems.first?.menuItem?.kitchenName ?? "",
                   kitchenID: cartItems.first?.menuItem?.kitchenName ?? "",    // Pass the kitchen name here
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
           return 5 // Four sections: Address, Cart Items, Bill, and Payment
       }
       
       
       

       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           let hasCartItems = !CartViewController.cartItems.isEmpty
           let hasSubscriptions = !CartViewController.subscriptionPlan1.isEmpty
           let hasAnyItems = hasCartItems || hasSubscriptions  // ✅ Check if either exists

           switch section {
               case 0:
                   return 1 // Address Section (Always 1 row)
                   
               case 1:
                   if hasCartItems {
                       return CartViewController.cartItems.count  // ✅ Show cart items count
                   } else if hasSubscriptions, CartViewController.subscriptionPlan1.count == 1 {
                       return 0  // ✅ Hide section if only 1 subscription plan exists
                   } else {
                       return 1  // ✅ Show empty cart placeholder when both are empty
                   }
                   
               case 2:
                   return hasSubscriptions ? CartViewController.subscriptionPlan1.count : 0
                   
               case 3, 4:
                   return hasAnyItems ? 1 : 0  // ✅ Show these sections only if cart or subscription exists
                   
               default:
                   return 0
           }
       }


       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let hasCartItems = !CartViewController.cartItems.isEmpty
           let hasSubscriptions = !CartViewController.subscriptionPlan1.isEmpty
           let hasAnyItems = hasCartItems || hasSubscriptions // ✅ Check if either exists

           switch indexPath.section {
               case 0:
                   // ✅ Address Section (Always Present)
                   guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCartAddress", for: indexPath) as? UserCartAddressTableViewCell else {
                       return UITableViewCell()
                   }
                   cell.updateAddress(with: indexPath)
                   cell.separatorInset = .zero
                   return cell
                   
               case 1:
               if CartViewController.cartItems.isEmpty && CartViewController.subscriptionPlan1.isEmpty {
                   // Show empty cart message only if both lists are empty
                   let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCartPlaceholder", for: indexPath)
                   cell.textLabel?.text = "Your cart is empty. Add some items! 🙁"
                   cell.textLabel?.textAlignment = .center
                   cell.textLabel?.textColor = .gray
                   return cell
               } else {
                   guard indexPath.row < CartViewController.cartItems.count else {
                       return UITableViewCell() // Prevents index out of range crash
                   }
                   
                   guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartItems", for: indexPath) as? CartItemTableViewCell else {
                       return UITableViewCell()
                   }
                   
                   cell.delegate = self
                   cell.separatorInset = .zero
                   cell.updateCartItem(for: indexPath)
                   return cell
               }

               case 2:
                   // ✅ Subscription Plan Section
                   guard hasSubscriptions, indexPath.row < CartViewController.subscriptionPlan1.count else {
                       return UITableViewCell() // Hide if no subscriptions
                   }
                   
                   let subscriptionPlan = CartViewController.subscriptionPlan1[indexPath.row]
                   if let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionCartItems", for: indexPath) as? SubscriptionCartItemsCollectionTableViewCell {
                       cell.configureWithSubscription(subscriptionPlan)
                       cell.separatorInset = .zero
                       return cell
                   }

                   let cell = UITableViewCell()
                   cell.textLabel?.text = "Unknown Subscription Plan"
                   return cell

               case 3:
                   // ✅ Payment Section (Bill)
                   guard hasAnyItems else { return UITableViewCell() } // ✅ Hide if no items
                   
                   guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartBill", for: indexPath) as? CartBillTableViewCell else {
                       return UITableViewCell()
                   }
                   
                   let totalPrice = calculateTotalItemPrice()
                   cell.itemPriceLabel.text = String(format: "₹ %.2f", totalPrice)
                   cell.separatorInset = .zero

                   // Example: Update other labels like GST, delivery charges, etc.
                   let gst = totalPrice * 0.18 // 18% GST
                   cell.gstLabel.text = String(format: "₹ %.2f", gst)
                   cell.deliveryChargesLabel.text = "₹ 50.00" // Static delivery charge
                   cell.discountLabel.text = "-₹ 20.00" // Static discount
                   cell.totalAmount.text = String(format: "₹ %.2f", totalPrice + gst + 50 - 20)
                   return cell

               case 4:
                   // ✅ Grand Total and Payment Button Section
                   guard hasAnyItems else { return UITableViewCell() } // ✅ Hide if no items
                   
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
               return 120 // Cart Item Section Height
           case 2:
               return 120 // Bill Section Height
           case 3:
               return 250// Payment Section Height
           case 4:
               return 70
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
           case 4:
               return "Order Details"
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
       
       func didAddItemToCart(_ item: CartItem) {
           KitchenDataController.cartItems.append(item)
           updateTabBarBadge()
           CartItem.reloadData()
           //       print("Item added to cart: \(item.menuItemID), Total items: \(KitchenDataController.cartItems.count)")
       }
       
       
       func addSubscriptionPlan(_ plan: SubscriptionPlan) {
               CartViewController.subscriptionPlan1.append(plan)  // ✅ Add new plan
               DispatchQueue.main.async {
                   self.CartItem?.reloadData()  // ✅ Refresh table view
               }
           }
       
       override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           CartItem.reloadData()
           updateTabBarBadge()// Reload the table view when the view appears
           print("🔄 Reloading cart data... Subscription items: \(CartViewController.subscriptionPlan1.count)")
              CartItem.reloadData() // ✅ Refresh table when the view appears
       }
       @objc func updateCart() {
           CartItem.reloadData()
       }
      
   //    func calculateTotalItemPrice() -> Double {
   //        return CartViewController.cartItems.reduce(0) { total, cartItem in
   //            switch (cartItem.menuItem, cartItem.chefSpecial) {
   //            case let (menuItem?, nil):
   //                print(menuItem.name)
   //                return total + ((menuItem.price ?? 0) * Double(cartItem.quantity))
   //
   //            case let (nil, chefDish?):
   //                print(chefDish.name)
   //                return total + (chefDish.price * Double(cartItem.quantity))
   //
   //            default:
   //                return total
   //            }
   //        }
   //    }
       func calculateTotalItemPrice() -> Double {
           // Calculate total from cart items
           let cartTotal = CartViewController.cartItems.reduce(0) { total, cartItem in
               if let menuItem = cartItem.menuItem {
                   print(menuItem.name)
                   return total + (menuItem.price * Double(cartItem.quantity)) // ✅ Assuming price is non-optional
               }
               
               if let chefDish = cartItem.chefSpecial {
                   print(chefDish.name)
                   return total + (chefDish.price * Double(cartItem.quantity))
               }
               
               return total // If neither menuItem nor chefSpecial exists, return current total
           }
           
           // Calculate total from subscription plans
           let subscriptionTotal = CartViewController.subscriptionPlan1.reduce(0) { total, plan in
               return total + (plan.totalPrice ?? 0) ?? 0 // ✅ Assuming totalPrice is non-optional
           }

           return cartTotal + subscriptionTotal // ✅ Combined total
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

               guard indexPath.row < CartViewController.cartItems.count else {
                   print("⚠️ Index out of bounds: \(indexPath.row), cart count: \(CartViewController.cartItems.count)")
                   return
               }

               // Remove the item from cart
               CartViewController.cartItems.remove(at: indexPath.row)

               // Check if the cart is empty after removal
               if CartViewController.cartItems.isEmpty {
                   print("🛒 Cart is now empty, reloading table to show placeholder and other sections.")
                   CartItem.reloadData() // Reload table to reflect empty cart
               } else {
                   print("✅ Item removed, updating UI")
                   CartItem.deleteRows(at: [indexPath], with: .fade)
               }

               updateTabBarBadge() // Update the cart badge count
           }

       func didTapSeeMorePlanYourMeal() {
               // Handle navigation or UI update when "See More Plans" is clicked
               print("See More Plans tapped")
           }

           func didAddItemToSubscriptionCart(_ item: SubscriptionPlan) {
               // Convert SubscriptionPlan to CartItem
               let cartItem = RasoiChef.CartItem(userAdress: "", quantity: 1, menuItem: nil, subscriptionDetails: item)

               // Add to cart
               CartViewController.cartItems.append(cartItem)

               // Reload table to reflect changes
               CartItem.reloadData()
               
               // Update Tab Bar Badge
               updateTabBarBadge()
               
               print("Subscription plan added to cart: \(item.planID)")
           }
       
       

       
   }
