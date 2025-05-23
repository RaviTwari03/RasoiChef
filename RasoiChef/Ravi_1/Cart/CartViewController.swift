//
//  CartViewController.swift
//  kitchen
//
//  Created by Ravi Tiwari on 19/01/25.
//

import UIKit
import MapKit
import CoreLocation
import UserNotifications

protocol SubscriptionPlanDelegate: AnyObject {
    func didAddSubscriptionPlan(_ plan: SubscriptionPlan)
}

// Add this struct before the CartViewController class
struct SubscriptionPlanOrder: Encodable {
    let user_id: String
    let kitchen_id: String
    let plan_name: String
    let start_date: String
    let end_date: String
    let total_days: Int
    let meals_per_day: [String: Bool]
    let total_amount: Double
    let delivery_address: String
    let delivery_type: String
    let breakfast_included: Bool
    let lunch_included: Bool
    let snacks_included: Bool
    let dinner_included: Bool
    let daily_meal_limit: Int
}

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddItemDelegate, CartPayCellDelegate, CartItemTableViewCellDelegate, SubscribeYourPlanButtonDelegate, SubscriptionCartItemTableViewCellDelegate, CartDeliveryDelegate, CLLocationManagerDelegate, MKMapViewDelegate, MapViewControllerDelegate, UserCartAddressDelegate, UNUserNotificationCenterDelegate {
    
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private var selectedAddress: String? = nil
    private var geocoder = CLGeocoder()
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    weak var delegate: SubscriptionPlanDelegate?
    @IBOutlet var CartItem: UITableView!

    var cartItems: [CartItem] = []
       var totalPrice: Int = 0

       static var cartItems: [CartItem] = []
       static var subscriptionPlan1 : [SubscriptionPlan] = []
      
       // Add property to track delivery option
       private var isDeliverySelected: Bool = false
      
       @IBAction func placeOrderButtonTapped(_ sender: Any) {
           print("\n🔄 Starting order placement process...")
           
           guard !CartViewController.cartItems.isEmpty else {
               print("❌ Cart is empty")
               showAlert(title: "Empty Cart", message: "Please add items to your cart before placing an order.")
               return
           }
           
           // Create order from cart items
           guard let order = createOrderFromCart(cartItems: CartViewController.cartItems, subscriptionPlan: []) else {
               print("❌ Failed to create order from cart items")
               showAlert(title: "Order Creation Failed", message: "Unable to create order from cart items. Please try again.")
               return
           }
           
           // Save order to Supabase
           Task {
               do {
                   print("\n📤 Saving order to Supabase...")
                   try await SupabaseController.shared.insertOrder(order: order)
                   
                   // Add order to OrderDataController
                   OrderDataController.shared.addOrder(order: order)
                   
                   DispatchQueue.main.async {
                       print("✅ Order successfully placed and saved")
                       
                       // Clear the cart
                       CartViewController.cartItems.removeAll()
                       self.CartItem.reloadData()
                       self.updateTotalAmount()
                       
                       // Show success message
                       self.showAlert(
                           title: "Order Placed Successfully",
                           message: "Your order has been placed and will be delivered to your address."
                       )
                       
                       // Add to order history
                       OrderHistoryController.addOrder(OrderHistory(
                           orderID: order.orderID,
                           items: CartViewController.cartItems,
                           orderDate: Date()
                       ))
                       
                       // Update UI
                       NotificationCenter.default.post(name: NSNotification.Name("CartUpdated"), object: nil)
                   }
                   
               } catch {
                   print("❌ Error saving order to Supabase: \(error.localizedDescription)")
                   DispatchQueue.main.async {
                       self.showAlert(
                           title: "Order Failed",
                           message: "Failed to place your order. Please try again."
                       )
                   }
               }
           }
       }
       
       private func showAlert(title: String, message: String) {
           let alert = UIAlertController(
               title: title,
               message: message,
               preferredStyle: .alert
           )
           alert.addAction(UIAlertAction(title: "OK", style: .default))
           present(alert, animated: true)
       }
   
   private func formatTime(_ date: Date) -> String {
       let formatter = DateFormatter()
       formatter.dateFormat = "hh:mm a"
       return formatter.string(from: date)
   }
   
   // Function to update the badge count on My Orders tab
    @objc func updateMyOrdersBadge() {
       if let tabItems = self.tabBarController?.tabBar.items {
           let myOrdersTabItem = tabItems[1] // Assuming My Orders is at index 1
           
           // Fetch active orders count from database
           Task {
               do {
                   // Get current user ID
                   var userID = UserDefaults.standard.string(forKey: "userID")
                   if userID == nil {
                       if let session = try await SupabaseController.shared.getCurrentSession() {
                           userID = session.user.id.uuidString
                           UserDefaults.standard.set(userID, forKey: "userID")
                       }
                   }
                   
                   guard let finalUserID = userID else { return }
                   
                   // Fetch orders from database
                   let orders = try await SupabaseController.shared.fetchOrders(for: finalUserID)
                   
                   // Count only active orders (not delivered)
                   let activeOrdersCount = orders.filter { $0.status != .delivered }.count
                   
                   // Update badge on main thread
                   DispatchQueue.main.async {
                       myOrdersTabItem.badgeValue = activeOrdersCount > 0 ? "\(activeOrdersCount)" : nil
                   }
               } catch {
                   print("Error fetching orders for badge count: \(error)")
               }
           }
       }
   }
   @objc func reloadCart() {
       self.CartItem.reloadData()
   }

    
       override func viewDidLoad() {
           super.viewDidLoad()
           self.title = "Cart"
          
           // Setup location manager
           locationManager.delegate = self
           locationManager.desiredAccuracy = kCLLocationAccuracyBest
           
           NotificationCenter.default.addObserver(self, selector: #selector(reloadCart), name: NSNotification.Name("CartUpdated"), object: nil)

           // Add observer for app becoming active
           NotificationCenter.default.addObserver(self, selector: #selector(updateMyOrdersBadge), name: UIApplication.willEnterForegroundNotification, object: nil)

           
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
           
           // Request location authorization
           locationManager.requestWhenInUseAuthorization()
           
           // Request notification permissions
           requestNotificationPermissions()

           // Set notification delegate
           notificationCenter.delegate = self
       }
    
    
    func createOrderFromCart(cartItems: [CartItem], subscriptionPlan: [SubscriptionPlan]) -> Order? {
        var orderItems: [OrderItem] = []
        var totalAmount: Double = 0.0
        var kitchenName = ""
        var kitchenID = ""

        // Process regular cart items
        for cartItem in cartItems {
            var menuItemID = ""
            var price: Double = 0.0

            switch (cartItem.menuItem, cartItem.chefSpecial) {
            case let (menuItem?, nil):
                menuItemID = menuItem.itemID
                price = menuItem.price
                kitchenName = menuItem.kitchenName
                kitchenID = menuItem.kitchenID
            case let (nil, chefSpecial?):
                menuItemID = chefSpecial.dishID
                price = chefSpecial.price
                kitchenName = chefSpecial.kitchenName
                kitchenID = chefSpecial.kitchenID
            case let (menuItem?, chefSpecial?):
                menuItemID = menuItem.itemID
                price = menuItem.price + chefSpecial.price
                kitchenName = menuItem.kitchenName
                kitchenID = menuItem.kitchenID
            default:
                continue
            }

            let itemTotal = price * Double(cartItem.quantity)
            totalAmount += itemTotal

            orderItems.append(OrderItem(
                menuItemID: menuItemID,
                quantity: cartItem.quantity,
                price: itemTotal
            ))
        }

        // Generate 8-digit order number
        let orderNumber = String(format: "%08d", Int.random(in: 0...99999999))

        // Create the order
        return Order(
            orderID: UUID().uuidString,
            orderNumber: orderNumber,
            userID: UserDefaults.standard.string(forKey: "userID") ?? "",
            kitchenName: kitchenName,
            kitchenID: kitchenID,
            items: orderItems,
            item: nil,
            status: .placed,
            totalAmount: totalAmount,
            deliveryAddress: cartItems.first?.userAdress ?? "",
            deliveryDate: Date(),
            deliveryType: "Delivery"
        )
    }
       func numberOfSections(in tableView: UITableView) -> Int {
           return 6
       }
       
       
       

       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           let hasCartItems = !CartViewController.cartItems.isEmpty
           let hasSubscriptions = !CartViewController.subscriptionPlan1.isEmpty
           let hasAnyItems = hasCartItems || hasSubscriptions

           switch section {
               case 0:
                   return 1
                   
               case 1:
                   if hasCartItems {
                       return CartViewController.cartItems.count
                   } else if hasSubscriptions, CartViewController.subscriptionPlan1.count == 1 {
                       return 0
                   } else {
                       return 1
                   }
                   
               case 2:
                   return hasSubscriptions ? CartViewController.subscriptionPlan1.count : 0
                   
               case 3, 4, 5:
                   return hasAnyItems ? 1 : 0
                   
               default:
                   return 0
           }
       }


       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let hasCartItems = !CartViewController.cartItems.isEmpty
           let hasSubscriptions = !CartViewController.subscriptionPlan1.isEmpty
           let hasAnyItems = hasCartItems || hasSubscriptions

           switch indexPath.section {
               case 0:
                   guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCartAddress", for: indexPath) as? UserCartAddressTableViewCell else {
                       return UITableViewCell()
                   }
                   cell.delegate = self
                   cell.updateAddress(with: selectedAddress ?? "Select delivery address")
                   cell.separatorInset = .zero
                   return cell
                   
               case 1:
                   if CartViewController.cartItems.isEmpty && CartViewController.subscriptionPlan1.isEmpty {
                       let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCartPlaceholder", for: indexPath)
                       cell.textLabel?.text = "Your cart is empty. Add some items! 🙁"
                       cell.textLabel?.textAlignment = .center
                       cell.textLabel?.textColor = .gray
                       return cell
                   } else {
                       guard indexPath.row < CartViewController.cartItems.count else {
                           return UITableViewCell()
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
                   guard hasSubscriptions, indexPath.row < CartViewController.subscriptionPlan1.count else {
                       return UITableViewCell()
                   }
                   
                   let subscriptionPlan = CartViewController.subscriptionPlan1[indexPath.row]
                   if let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionCartItems", for: indexPath) as? SubscriptionCartItemsCollectionTableViewCell {
                       cell.configureWithSubscription(subscriptionPlan)
                       cell.separatorInset = .zero
                       cell.delegate = self
                       return cell
                   }
                   
                   let cell = UITableViewCell()
                   cell.textLabel?.text = "Unknown Subscription Plan"
                   return cell

               case 3:
                   guard hasAnyItems else { return UITableViewCell() }
                   
                   guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartDelivery", for: indexPath) as? CartDeliveryTableViewCell else {
                       return UITableViewCell()
                   }
                   cell.delegate = self
                   cell.separatorInset = .zero
                   return cell

               case 4:
                   guard hasAnyItems else { return UITableViewCell() }
                   
                   guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartBill", for: indexPath) as? CartBillTableViewCell else {
                       return UITableViewCell()
                   }
                   
                   let totalPrice = calculateTotalItemPrice()
                   cell.itemPriceLabel.text = String(format: "₹ %.2f", totalPrice)
                   cell.separatorInset = .zero

                   let gst = totalPrice * 0.18
                   cell.gstLabel.text = String(format: "₹ %.2f", gst)
                   
                   // Set delivery charges based on selection
                   let deliveryCharges = isDeliverySelected ? 50.00 : 0.00
                   cell.deliveryChargesLabel.text = String(format: "₹ %.2f", deliveryCharges)
                   
                   cell.discountLabel.text = "-₹ 20.00"
                   cell.totalAmount.text = String(format: "₹ %.2f", totalPrice + gst + deliveryCharges - 20)
                   return cell

               case 5:
                   guard hasAnyItems else { return UITableViewCell() }
                   
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
               return 100
           case 1:
               return 135
           case 2:
               return 120
           case 3:
               return 100
           case 4:
               return 250
           case 5:
               return 70
           default:
               return 44
           }
       }
       

       
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let hasCartItems = !CartViewController.cartItems.isEmpty
        let hasSubscriptions = !CartViewController.subscriptionPlan1.isEmpty
        let hasAnyItems = hasCartItems || hasSubscriptions

        switch section {
            case 0:
                return "Delivery Address"
            
            case 1:
                return hasCartItems ? "Cart Items" : (hasSubscriptions && CartViewController.subscriptionPlan1.count == 1 ? nil : "Your Cart is Empty")
            
            case 2:
                return hasSubscriptions ? "Subscription Details" : nil
            
            case 3:
                return hasAnyItems ? "Delivery Details" : nil
            
            case 4:
                return hasAnyItems ? "Bill Details" : nil
            
            case 5:
                return hasAnyItems ? "Payment" : nil
            
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
        CartViewController.cartItems.append(item)
        cartItems = CartViewController.cartItems
        updateTabBarBadge()
        
        CartItem.reloadData()
    }


       

    func addSubscriptionPlan(_ plan: SubscriptionPlan) {
            CartViewController.subscriptionPlan1.append(plan)  // ✅ Add new plan
            
            DispatchQueue.main.async {
                self.CartItem?.reloadData()
            }
            
            print(CartViewController.subscriptionPlan1)
            
            // Notify delegate
            delegate?.didAddSubscriptionPlan(plan)
        }
 

       @objc func updateCart() {
           CartItem.reloadData()
       }
      
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cartItems = CartViewController.cartItems
        CartItem.reloadData()
        updateMyOrdersBadge() // Update badge count when view appears
    }

       func calculateTotalItemPrice() -> Double {
           let cartTotal = CartViewController.cartItems.reduce(0) { total, cartItem in
               if let menuItem = cartItem.menuItem {
                   print(menuItem.name)
                   return total + (menuItem.price * Double(cartItem.quantity))
               }
               
               if let chefDish = cartItem.chefSpecial {
                   print(chefDish.name)
                   return total + (chefDish.price * Double(cartItem.quantity))
               }
               
               return total // If neither menuItem nor chefSpecial exists, return current total
           }
           
           // Calculate total from subscription plans
           let subscriptionTotal = CartViewController.subscriptionPlan1.reduce(0) { total, plan in
               return total + (plan.totalPrice ?? 0) ?? 0
           }

           return cartTotal + Double(Int(subscriptionTotal)) // ✅ Combined total
       }

       func fetchMenuItem(by id: Int) -> MenuItem? {
           return KitchenDataController.menuItems.first /*{ $0.id == id }*/
       }
       func calculateGrandTotal() -> Double {
           let totalPrice = calculateTotalItemPrice()
           let gst = totalPrice * 0.18
           let deliveryCharges = isDeliverySelected ? 50.0 : 0.0
           let discount = 20.0
           return totalPrice + gst + deliveryCharges - discount
       }
    
    
       func updateTabBarBadge() {
           if let tabItems = self.tabBarController?.tabBar.items {
               let cartTabItem = tabItems[2] 
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

               CartViewController.cartItems.remove(at: indexPath.row)

               if CartViewController.cartItems.isEmpty {
                   print("🛒 Cart is now empty, reloading table to show placeholder and other sections.")
                   CartItem.reloadData() // Reload table to reflect empty cart
               } else {
                   print("✅ Item removed, updating UI")
                   CartItem.deleteRows(at: [indexPath], with: .fade)
               }

               updateTabBarBadge()
           
           }

       func didTapSeeMorePlanYourMeal() {
               print("See More Plans tapped")
           }

           func didAddItemToSubscriptionCart(_ item: SubscriptionPlan) {
               let cartItem = RasoiChef.CartItem(userAdress: "", quantity: 1, menuItem: nil, subscriptionDetails: item)
               CartViewController.cartItems.append(cartItem)
               CartItem.reloadData()
                updateTabBarBadge()
               
               print("Subscription plan added to cart: \(item.planID)")
           }
       
    func SubscriptioncartdidTapRemoveButton(cell: SubscriptionCartItemsCollectionTableViewCell) {
        guard let indexPath = CartItem.indexPath(for: cell) else {
            print("⚠️ Invalid indexPath: Cell not found in tableView")
            return
        }

        guard indexPath.row < CartViewController.subscriptionPlan1.count else {
            print("⚠️ Index out of bounds: \(indexPath.row), subscription count: \(CartViewController.subscriptionPlan1.count)")
            return
        }

          CartViewController.subscriptionPlan1.remove(at: indexPath.row)

        if CartViewController.subscriptionPlan1.isEmpty {
            print("📦 Subscription list is empty, reloading table to show empty state.")
            CartItem.reloadData() // Reload entire table to reflect empty state
        } else {
            print("✅ Subscription removed, updating UI")
            CartItem.deleteRows(at: [indexPath], with: .fade)
        }

        updateTabBarBadge() // Update the tab bar badge
    }

    func deliveryOptionChanged(isDelivery: Bool) {
        isDeliverySelected = isDelivery
        // Reload the bill section to update delivery charges
        if let billSection = CartItem.numberOfSections > 4 ? 4 : nil {
            CartItem.reloadSections(IndexSet(integer: billSection), with: .none)
        }
        // Reload the payment section to update grand total
        if let paymentSection = CartItem.numberOfSections > 5 ? 5 : nil {
            CartItem.reloadSections(IndexSet(integer: paymentSection), with: .none)
        }
    }
    
    // MARK: - Location Manager Delegate Methods
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            showLocationPermissionAlert()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
        locationManager.stopUpdatingLocation()
        
        // Reverse geocode the location
        reverseGeocodeLocation(location)
    }
    
    private func reverseGeocodeLocation(_ location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            guard let self = self,
                  let placemark = placemarks?.first else { return }
            
            let address = [
                placemark.subThoroughfare,
                placemark.thoroughfare,
                placemark.locality,
                placemark.administrativeArea,
                placemark.postalCode
            ].compactMap { $0 }.joined(separator: ", ")
            
            self.selectedAddress = address
            
            DispatchQueue.main.async {
                if let addressCell = self.CartItem.cellForRow(at: IndexPath(row: 0, section: 0)) as? UserCartAddressTableViewCell {
                    addressCell.updateAddress(with: address)
                }
            }
        }
    }
    
    private func showLocationPermissionAlert() {
        let alert = UIAlertController(
            title: "Location Access Required",
            message: "Please enable location access in Settings to use this feature.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    // MARK: - Map View Controller
    
    func showMapViewController() {
        let mapVC = MapViewController()
        mapVC.delegate = self
        mapVC.currentLocation = self.currentLocation
        
        let navController = UINavigationController(rootViewController: mapVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    // Handle address selection from map
    func didSelectAddress(_ address: String, location: CLLocation) {
        self.selectedAddress = address
        self.currentLocation = location
        
        if let addressCell = self.CartItem.cellForRow(at: IndexPath(row: 0, section: 0)) as? UserCartAddressTableViewCell {
            addressCell.updateAddress(with: address)
        }
    }

    // MARK: - UserCartAddressDelegate
    func didTapChangeAddress() {
        showMapViewController()
    }

    // MARK: - CartPayCellDelegate
    func didTapPlaceOrder() {
        guard !CartViewController.cartItems.isEmpty || !CartViewController.subscriptionPlan1.isEmpty else {
            showAlert(title: "Empty Cart", message: "Please add items to your cart before placing an order.")
            return
        }
        guard let selectedAddress = selectedAddress else {
            showAlert(title: "Missing Address", message: "Please select a delivery address before placing your order.")
            return
        }
        Task {
            do {
                var userID = UserDefaults.standard.string(forKey: "userID")
                if userID == nil {
                    if let session = try await SupabaseController.shared.getCurrentSession() {
                        userID = session.user.id.uuidString
                        UserDefaults.standard.set(userID, forKey: "userID")
                    }
                }
                guard let finalUserID = userID else {
                    showAlert(title: "Error", message: "Please log in to place an order")
                    return
                }
                // If there are regular cart items, process them
                if !CartViewController.cartItems.isEmpty {
                    try await processRegularOrder(userID: finalUserID)
                }
                // If there are subscription plans, process them
                if !CartViewController.subscriptionPlan1.isEmpty {
                    try await processSubscriptionPlans(userID: finalUserID)
                }
                // Clear cart and update UI
                clearCartAndUpdateUI()
                showAlert(title: "Success", message: "Your order has been placed successfully!")
            } catch {
                showAlert(title: "Error", message: "Failed to place order: \(error.localizedDescription)")
                print("Error placing order: \(error)")
            }
        }
    }

    private func getUserID() async throws -> String {
        // Try to get user ID from UserDefaults first
        if let userID = UserDefaults.standard.string(forKey: "userID") {
            return userID
        }
        
        // Try to get from current session
        if let session = try await SupabaseController.shared.getCurrentSession() {
            let userID = session.user.id.uuidString
            UserDefaults.standard.set(userID, forKey: "userID")
            return userID
        }
        
        throw NSError(domain: "User not logged in", code: -1)
    }

    private func processRegularOrder(userID: String) async throws {
        let firstItem = CartViewController.cartItems[0]
        let kitchenName = firstItem.menuItem?.kitchenName ?? firstItem.chefSpecial?.kitchenName ?? "Unknown Kitchen"
        let kitchenID = firstItem.menuItem?.kitchenID ?? firstItem.chefSpecial?.kitchenID ?? ""
        
        let orderItems = CartViewController.cartItems.map { cartItem -> OrderItem in
            let itemID: String
            let price: Double
            
            if let menuItem = cartItem.menuItem {
                itemID = menuItem.itemID
                price = menuItem.price
            } else if let chefSpecial = cartItem.chefSpecial {
                itemID = chefSpecial.dishID
                price = chefSpecial.price
            } else {
                itemID = ""
                price = 0.0
            }
            
            return OrderItem(
                menuItemID: itemID,
                quantity: cartItem.quantity,
                price: price * Double(cartItem.quantity)
            )
        }
        
        let orderID = UUID().uuidString
        let orderNumber = String(format: "%08d", Int.random(in: 0...99999999))
        let order = Order(
            orderID: orderID,
            orderNumber: orderNumber,
            userID: userID,
            kitchenName: kitchenName,
            kitchenID: kitchenID,
            items: orderItems,
            item: nil,
            status: .placed,
            totalAmount: calculateGrandTotal(),
            deliveryAddress: selectedAddress ?? "No address selected",
            deliveryDate: Date(),
            deliveryType: isDeliverySelected ? "Delivery" : "Self-Pickup"
        )
        
        try await SupabaseController.shared.insertOrder(order: order)
        OrderDataController.shared.addOrder(order: order)
        
        // Schedule notification for regular order
        DispatchQueue.main.async { [weak self] in
            self?.scheduleOrderNotification(orderID: orderID, kitchenName: kitchenName)
        }
    }

    private func insertSubscriptionPlan(_ plan: SubscriptionPlan, userID: String) async throws {
        // Debug logging for all required fields
        print("\n🔍 Checking required fields for subscription plan:")
        print("kitchenID: \(plan.kitchenID ?? "nil")")
        print("planName: \(plan.planName ?? "nil")")
        print("startDate: \(plan.startDate ?? "nil")")
        print("endDate: \(plan.endDate ?? "nil")")
        print("totalPrice: \(plan.totalPrice ?? 0.0)")
        print("selectedAddress: \(selectedAddress ?? "nil")")
        print("userID: \(userID)")
        print("PlanIntakeLimit: \(plan.PlanIntakeLimit)")

        // Validate kitchen ID first
        guard let kitchenID = plan.kitchenID, !kitchenID.isEmpty else {
            let msg = "❌ Kitchen ID is required for subscription plan"
            print(msg)
            DispatchQueue.main.async {
                self.showAlert(title: "Error", message: "Please select a valid kitchen for your subscription plan.")
            }
            throw NSError(domain: "SubscriptionPlan", code: -1, userInfo: [NSLocalizedDescriptionKey: msg])
        }

        // Validate UUID format for kitchen ID
        guard UUID(uuidString: kitchenID) != nil else {
            let msg = "❌ Invalid kitchen ID format: \(kitchenID)"
            print(msg)
            DispatchQueue.main.async {
                self.showAlert(title: "Error", message: "Invalid kitchen selection. Please try again.")
            }
            throw NSError(domain: "SubscriptionPlan", code: -1, userInfo: [NSLocalizedDescriptionKey: msg])
        }

        // Map SubscriptionPlan to DBSubscriptionPlanOrder
        guard let planName = plan.planName,
              let startDateStr = plan.startDate,
              let endDateStr = plan.endDate,
              let totalPrice = plan.totalPrice,
              let deliveryAddress = selectedAddress else {
            let msg = """
            ❌ Missing required fields for subscription plan order:
            - planName: \(plan.planName ?? "nil")
            - startDate: \(plan.startDate ?? "nil")
            - endDate: \(plan.endDate ?? "nil")
            - totalPrice: \(plan.totalPrice ?? 0.0)
            - deliveryAddress: \(selectedAddress ?? "nil")
            """
            print(msg)
            DispatchQueue.main.async {
                self.showAlert(title: "Error", message: "Please ensure all subscription plan details are complete.")
            }
            throw NSError(domain: "SubscriptionPlan", code: -1, userInfo: [NSLocalizedDescriptionKey: msg])
        }

        // Convert dates to proper format
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "dd MMM yyyy"
        
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let startDate = inputDateFormatter.date(from: startDateStr),
              let endDate = inputDateFormatter.date(from: endDateStr) else {
            let msg = "❌ Invalid date format. Expected format: dd MMM yyyy (e.g., 19 May 2025)"
            print(msg)
            DispatchQueue.main.async {
                self.showAlert(title: "Error", message: "Invalid date format. Please try again.")
            }
            throw NSError(domain: "SubscriptionPlan", code: -1, userInfo: [NSLocalizedDescriptionKey: msg])
        }
        
        let formattedStartDate = outputDateFormatter.string(from: startDate)
        let formattedEndDate = outputDateFormatter.string(from: endDate)

        // Calculate total days
        let totalDays = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 1

        // Create meals_per_day JSONB object
        let mealsPerDay: [String: Bool] = [
            "breakfast": plan.PlanIntakeLimit > 0,
            "lunch": plan.PlanIntakeLimit > 0,
            "snacks": plan.PlanIntakeLimit > 0,
            "dinner": plan.PlanIntakeLimit > 0
        ]

        print("\n📦 Creating subscription plan order with values:")
        print("user_id: \(userID)")
        print("kitchen_id: \(kitchenID)")
        print("plan_name: \(planName)")
        print("start_date: \(formattedStartDate)")
        print("end_date: \(formattedEndDate)")
        print("total_days: \(totalDays + 1)")
        print("total_amount: \(totalPrice)")
        print("delivery_address: \(deliveryAddress)")
        print("delivery_type: \(isDeliverySelected ? "Delivery" : "Self-Pickup")")
        print("daily_meal_limit: \(plan.PlanIntakeLimit)")

        // Create the subscription plan order
        let dbOrder = SupabaseController.DBSubscriptionPlanOrder(
            subscription_id: nil, // Will be auto-generated by database
            user_id: userID,
            kitchen_id: kitchenID,
            plan_name: planName,
            start_date: formattedStartDate,
            end_date: formattedEndDate,
            total_days: totalDays + 1, // inclusive
            meals_per_day: mealsPerDay,
            total_amount: totalPrice,
            delivery_address: deliveryAddress,
            delivery_type: isDeliverySelected ? "Delivery" : "Self-Pickup",
            breakfast_included: mealsPerDay["breakfast"] ?? false,
            lunch_included: mealsPerDay["lunch"] ?? false,
            snacks_included: mealsPerDay["snacks"] ?? false,
            dinner_included: mealsPerDay["dinner"] ?? false,
            daily_meal_limit: plan.PlanIntakeLimit,
            created_at: nil, // Will be auto-generated by database
            updated_at: nil  // Will be auto-generated by database
        )

        print("\n[DEBUG] Attempting to insert subscription plan order:")
        print(dbOrder)

        do {
            try await SupabaseController.shared.insertSubscriptionPlanOrder(order: dbOrder)
            print("✅ Successfully inserted subscription plan order")
        } catch {
            let msg = "❌ Failed to insert subscription plan order: \(error.localizedDescription)"
            print(msg)
            DispatchQueue.main.async {
                self.showAlert(title: "Error", message: "Failed to process subscription plan. Please try again.")
            }
            throw error
        }
    }

    private func processSubscriptionPlans(userID: String) async throws {
        for plan in CartViewController.subscriptionPlan1 {
            do {
                try await insertSubscriptionPlan(plan, userID: userID)
            } catch {
                print("❌ Error processing subscription plan: \(error)")
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: "Failed to process subscription plan: \(error.localizedDescription)")
                }
            }
            // Schedule notification for subscription plan
            if let kitchenName = plan.kitchenName, let planName = plan.planName {
                DispatchQueue.main.async { [weak self] in
                    self?.scheduleSubscriptionNotification(planName: planName, kitchenName: kitchenName)
                }
            }
        }
    }

    private func clearCartAndUpdateUI() {
        CartViewController.cartItems.removeAll()
        CartViewController.subscriptionPlan1.removeAll()
        updateTabBarBadge()
        updateMyOrdersBadge()
        CartItem.reloadData()
    }

    // MARK: - Helper Methods
    func updateTotalAmount() {
        let grandTotal = calculateGrandTotal()
        if let paySection = CartItem.numberOfSections > 5 ? 5 : nil,
           let cell = CartItem.cellForRow(at: IndexPath(row: 0, section: paySection)) as? CartPayTableViewCell {
            cell.TotalAmountLabel.text = String(format: "₹%.2f", grandTotal)
        }
    }

    private func requestNotificationPermissions() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("✅ Notification permission granted")
            } else if let error = error {
                print("❌ Notification permission error: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - UNUserNotificationCenterDelegate Methods
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Show notification even when app is in foreground
        completionHandler([.banner, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle notification tap
        completionHandler()
    }

    private func scheduleOrderNotification(orderID: String, kitchenName: String) {
        // Check notification authorization status first
        notificationCenter.getNotificationSettings { [weak self] settings in
            guard settings.authorizationStatus == .authorized else {
                print("❌ Notifications not authorized")
                return
            }
            
            let content = UNMutableNotificationContent()
            
            // Get current time to customize message
            let hour = Calendar.current.component(.hour, from: Date())
            let title: String
            let body: String
            
            switch hour {
            case 6..<12: // Morning
                title = "Breakfast is on the way! 🌅"
                body = "Your delicious morning feast from \(kitchenName) is being prepared with love and care."
            case 12..<16: // Afternoon
                title = "Lunch is coming! 🍱"
                body = "Get ready for a delightful lunch from \(kitchenName). Your taste buds are in for a treat!"
            case 16..<19: // Evening
                title = "Evening delights incoming! 🌆"
                body = "Time for some evening indulgence! \(kitchenName) is preparing your special treats."
            case 19..<23: // Night
                title = "Dinner is being prepared! 🌙"
                body = "Your perfect dinner from \(kitchenName) will be ready soon. Get your table set!"
            default: // Late night
                title = "Your food is on the way! 🌟"
                body = "\(kitchenName) is preparing your special order with the finest ingredients."
            }
            
            content.title = title
            content.body = body
            content.sound = .default
            content.badge = 1
            
            // Show notification after 1 second
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            
            let request = UNNotificationRequest(
                identifier: "order-\(orderID)",
                content: content,
                trigger: trigger
            )
            
            self?.notificationCenter.add(request) { error in
                if let error = error {
                    print("❌ Notification Error: \(error.localizedDescription)")
                } else {
                    print("✅ Order notification scheduled successfully")
                }
            }
        }
    }

    private func scheduleSubscriptionNotification(planName: String, kitchenName: String) {
        // Check notification authorization status first
        notificationCenter.getNotificationSettings { [weak self] settings in
            guard settings.authorizationStatus == .authorized else {
                print("❌ Notifications not authorized")
                return
            }
            
            let content = UNMutableNotificationContent()
            
            // Array of engaging messages
            let messages = [
                (title: "Welcome to the Family! 🎉", body: "Your \(planName) journey with \(kitchenName) begins now. Get ready for a delightful culinary experience!"),
                (title: "Your Food Journey Begins! 🌟", body: "Exciting times ahead with your new \(planName) subscription from \(kitchenName)!"),
                (title: "You're All Set! 🍽️", body: "Your \(planName) subscription is active. Get ready for amazing meals from \(kitchenName)!"),
                (title: "Welcome Aboard! 🚀", body: "Your culinary adventure with \(kitchenName)'s \(planName) starts now!")
            ]
            
            // Randomly select a message
            let message = messages.randomElement()!
            
            content.title = message.title
            content.body = message.body
            content.sound = .default
            content.badge = 1
            
            // Show notification after 1 second
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            
            let request = UNNotificationRequest(
                identifier: "subscription-\(UUID().uuidString)",
                content: content,
                trigger: trigger
            )
            
            self?.notificationCenter.add(request) { error in
                if let error = error {
                    print("❌ Notification Error: \(error.localizedDescription)")
                } else {
                    print("✅ Subscription notification scheduled successfully")
                }
            }
        }
    }
}
