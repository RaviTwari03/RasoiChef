//
//  CartViewController.swift
//  kitchen
//
//  Created by Ravi Tiwari on 19/01/25.
//

import UIKit
import MapKit
import CoreLocation

protocol SubscriptionPlanDelegate: AnyObject {
    func didAddSubscriptionPlan(_ plan: SubscriptionPlan)
}

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddItemDelegate, CartPayCellDelegate, CartItemTableViewCellDelegate, SubscribeYourPlanButtonDelegate, SubscriptionCartItemTableViewCellDelegate, CartDeliveryDelegate, CLLocationManagerDelegate, MKMapViewDelegate, MapViewControllerDelegate, UserCartAddressDelegate {
    
    // Add location manager and address properties
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private var selectedAddress: String? = nil
    private var geocoder = CLGeocoder()
    
    weak var delegate: SubscriptionPlanDelegate?
    @IBOutlet var CartItem: UITableView!

    var cartItems: [CartItem] = []
       var totalPrice: Int = 0

       static var cartItems: [CartItem] = []
       static var subscriptionPlan1 : [SubscriptionPlan] = []
      
       // Add property to track delivery option
       private var isDeliverySelected: Bool = false
      
       func didTapPlaceOrder() {
           // Check if the selected address is set
           guard let address = selectedAddress else {
               // Show an alert if the address is not set
               let alert = UIAlertController(title: "Address Required", message: "Please select a delivery address before placing your order.", preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "OK", style: .default))
               present(alert, animated: true)
               return
           }

           // Create new order history entry
           let orderHistory = OrderHistory(
               orderID: UUID().uuidString,
               items: CartViewController.cartItems,
               orderDate: Date()
           )
           
           // Add to order history
           OrderHistoryController.addOrder(orderHistory)
           
           // Process and store orders & subscriptions
           if let order = createOrderFromCart(cartItems: CartViewController.cartItems, subscriptionPlan: CartViewController.subscriptionPlan1) {
               // Set the order start time in UserDefaults
               let startTime = Date()
               UserDefaults.standard.set(startTime, forKey: "orderStartTime_\(order.orderID)")
               
               // Initialize the order times dictionary
               let orderTimes = ["placed": formatTime(startTime)]
               UserDefaults.standard.set(orderTimes, forKey: "orderTimes_\(order.orderID)")
               
               // Add order to OrderDataController
               OrderDataController.shared.addOrder(order: order)
               
               // Post notification with order ID to start tracking
               NotificationCenter.default.post(
                   name: NSNotification.Name("OrderPlaced"),
                   object: nil,
                   userInfo: ["orderID": order.orderID]
               )
           }
           
           // Show success message
           let banner = CustomBannerView()
           banner.show(in: self.view, message: "Order Placed Successfully!")
           
           // Clear all items
           CartViewController.cartItems.removeAll()
           CartViewController.subscriptionPlan1.removeAll()
           
           // Update UI
           CartItem.reloadData()
           updateTabBarBadge()
           
           // Notify to update intake limits
           NotificationCenter.default.post(name: NSNotification.Name("CartUpdated"), object: nil)
           
           // Notify all relevant views to update their UI
           NotificationCenter.default.post(name: NSNotification.Name("ResetStepper"), object: nil)
           
           // Update My Orders badge
           updateMyOrdersBadge()
           
           // Dismiss the view controller after a short delay
           DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
               self.navigationController?.popViewController(animated: true)
           }
       }
   
   private func formatTime(_ date: Date) -> String {
       let formatter = DateFormatter()
       formatter.dateFormat = "hh:mm a"
       return formatter.string(from: date)
   }
   
   // Function to update the badge count on My Orders tab
   func updateMyOrdersBadge() {
       if let tabItems = self.tabBarController?.tabBar.items {
           let myOrdersTabItem = tabItems[1] // Assuming My Orders is at index 1
           let activeOrdersCount = OrderDataController.shared.getActiveOrdersCount()
           myOrdersTabItem.badgeValue = activeOrdersCount > 0 ? "\(activeOrdersCount)" : nil
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
       }
    
    
    func createOrderFromCart(cartItems: [CartItem], subscriptionPlan: [SubscriptionPlan]) -> Order? {
        var orderItems: [OrderItem] = []

        // Process regular cart items
        for cartItem in cartItems {
            var menuItemID = "Unknown Item"
            var price: Double = 0.0
            var kitchenName = "Unknown Kitchen"
            var kitchenID = ""

            switch (cartItem.menuItem, cartItem.chefSpecial) {
            case let (menuItem?, nil):
                menuItemID = menuItem.name
                price = menuItem.price
                kitchenName = menuItem.kitchenName
                kitchenID = menuItem.kitchenID
            case let (nil, chefSpecial?):
                menuItemID = chefSpecial.name
                price = chefSpecial.price
                kitchenName = chefSpecial.kitchenName
                kitchenID = chefSpecial.kitchenID
            case let (menuItem?, chefSpecial?):
                menuItemID = "\(menuItem.name) / \(chefSpecial.name)"
                price = menuItem.price + chefSpecial.price
                kitchenName = menuItem.kitchenName
                kitchenID = menuItem.kitchenID
            default:
                break
            }

            orderItems.append(OrderItem(
                menuItemID: menuItemID,
                quantity: cartItem.quantity,
                price: price * Double(cartItem.quantity)
            ))
        }

        // Process subscription plans separately
        for subscription in subscriptionPlan {
            let subscriptionOrder = SubscriptionPlan(
                //subscriptionID: UUID().uuidString,
                planID: subscription.planID,
                kitchenName: subscription.kitchenName,
                userID: UUID().uuidString, // Replace with actual user ID
                location: subscription.location ?? "Unknown Location",
                startDate: subscription.startDate,
                endDate: subscription.endDate,
                totalPrice: subscription.totalPrice,
              
               
                planName: subscription.planName ?? "Unknown Plan",
                PlanIntakeLimit: 4
                
                
            )

            // Add subscription to OrderDataController
            OrderDataController.shared.addSubscription(SubscriptionPlan: subscriptionOrder)
        }

        // If no cart items, return nil (only subscriptions were added)
        if orderItems.isEmpty {
            return nil
        }

        // Calculate total amount for the order
        let totalAmount = orderItems.reduce(0.0) { $0 + $1.price }

        // Get kitchen details from first cart item
        let firstCartItem = cartItems.first
        var kitchenName = firstCartItem?.menuItem?.kitchenName ?? "Unknown Kitchen"
        var kitchenID = firstCartItem?.menuItem?.kitchenID ?? ""
        switch (firstCartItem?.menuItem, firstCartItem?.chefSpecial) {
               case let (menuItem?, nil):
                   kitchenName = menuItem.kitchenName
                   kitchenID = menuItem.kitchenID
               case let (nil, chefSpecial?):
                   kitchenName = chefSpecial.kitchenName
                   kitchenID = chefSpecial.kitchenID
               case let (menuItem?, chefSpecial?):
                   kitchenName = menuItem.kitchenName
                   kitchenID = menuItem.kitchenID
               default:
                   break
               }

        // Create and return order with selected delivery type
        let order = Order(
            orderID: String(UUID().uuidString.prefix(6)),
            userID: "user123",
            kitchenName: kitchenName,
            kitchenID: kitchenName,
            items: orderItems,
            status: .placed,
            totalAmount: totalAmount,
            deliveryAddress: firstCartItem?.userAdress ?? "Unknown Address",
            deliveryDate: Date(),
            deliveryType: isDeliverySelected ? "Delivery" : "Self-Pickup"
        )

        return order
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

        // Remove the subscription plan
        CartViewController.subscriptionPlan1.remove(at: indexPath.row)

        // Check if subscriptions are empty
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
}
