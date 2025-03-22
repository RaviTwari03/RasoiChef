//
//
//  Data Controller.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 17/01/25.
//

import Foundation

class KitchenDataController {
    static let shared = KitchenDataController()
    
    private init() {}
    
    // MARK: - Data Storage
    static var users: [User] = []
    static var kitchens: [Kitchen] = []
    static var menuItems: [MenuItem] = []
    static var subscriptionMenuItems: [MenuItem] = []
    static var chefSpecialtyDishes: [ChefSpecialtyDish] = []
    static var globalChefSpecial: [ChefSpecialtyDish] = []
    static var subscriptionPlan: [SubscriptionPlan] = []
    static var GloballunchMenuItems: [MenuItem] = []
    static var GlobalbreakfastMenuItems: [MenuItem] = []
    static var GlobalsnacksMenuItems: [MenuItem] = []
    static var GlobaldinnerMenuItems: [MenuItem] = []
    static var cartItems: [CartItem] = []
    static var orders: [Order] = []
    static var subscriptionPlans: [SubscriptionPlan] = []
    static var feedbacks: [Feedback] = []
    static var coupons: [Coupon] = []

    // MARK: - Data Loading
    
    static func loadInitialData() async {
        print("\n🔄 Starting to load initial data...")
        do {
            // Fetch kitchens
            print("\n📥 Fetching kitchens...")
            kitchens = try await SupabaseController.shared.fetchKitchens()
            print("✅ Successfully loaded \(kitchens.count) kitchens")
            
            // Print kitchen details
            print("\n📋 Kitchen Details:")
            kitchens.forEach { kitchen in
                print("- \(kitchen.name)")
                print("  Location: \(kitchen.location)")
                print("  Rating: \(kitchen.rating)")
                print("  Cuisines: \(kitchen.cuisines.map { $0.rawValue }.joined(separator: ", "))")
            }
            
            // Fetch menu items
            print("\n📥 Fetching menu items...")
            let allMenuItems = try await SupabaseController.shared.fetchMenuItems()
            print("✅ Successfully loaded \(allMenuItems.count) menu items")
            
            // Sort menu items into different categories
            menuItems = allMenuItems
            
            // Sort by meal type with detailed logging
            print("\n📊 Categorizing menu items...")
            
            GlobalbreakfastMenuItems = allMenuItems.filter { $0.availableMealTypes.contains(.breakfast) }
            print("\n🍳 Breakfast Items (\(GlobalbreakfastMenuItems.count)):")
            GlobalbreakfastMenuItems.forEach { print("- \($0.name) from \($0.kitchenName)") }
            
            GloballunchMenuItems = allMenuItems.filter { $0.availableMealTypes.contains(.lunch) }
            print("\n🍱 Lunch Items (\(GloballunchMenuItems.count)):")
            GloballunchMenuItems.forEach { print("- \($0.name) from \($0.kitchenName)") }
            
            GlobalsnacksMenuItems = allMenuItems.filter { $0.availableMealTypes.contains(.snacks) }
            print("\n🥨 Snacks Items (\(GlobalsnacksMenuItems.count)):")
            GlobalsnacksMenuItems.forEach { print("- \($0.name) from \($0.kitchenName)") }
            
            GlobaldinnerMenuItems = allMenuItems.filter { $0.availableMealTypes.contains(.dinner) }
            print("\n🍽️ Dinner Items (\(GlobaldinnerMenuItems.count)):")
            GlobaldinnerMenuItems.forEach { print("- \($0.name) from \($0.kitchenName)") }
            
            // Fetch subscription plans
            print("\n📥 Fetching subscription plans...")
            subscriptionPlans = try await SupabaseController.shared.fetchSubscriptionPlans()
            print("✅ Successfully loaded \(subscriptionPlans.count) subscription plans")
            
            print("\n✅ Initial data load complete!")
            print("\n📊 Final Statistics:")
            print("- Kitchens: \(kitchens.count)")
            print("- Total Menu Items: \(menuItems.count)")
            print("- Breakfast Items: \(GlobalbreakfastMenuItems.count)")
            print("- Lunch Items: \(GloballunchMenuItems.count)")
            print("- Snacks Items: \(GlobalsnacksMenuItems.count)")
            print("- Dinner Items: \(GlobaldinnerMenuItems.count)")
            print("- Subscription Plans: \(subscriptionPlans.count)")
            
        } catch {
            print("\n❌ Error loading initial data:")
            print("Error: \(error.localizedDescription)")
            if let nsError = error as NSError? {
                print("Domain: \(nsError.domain)")
                print("Code: \(nsError.code)")
                print("User Info: \(nsError.userInfo)")
            }
        }
    }

    // MARK: - User Management
   
    static func addUser(_ user: User) {
        users.append(user)
    }

    static func getUser(byID userID: String) -> User? {
        return users.first { $0.userID == userID }
    }

    static func updateUser(_ updatedUser: User) {
        if let index = users.firstIndex(where: { $0.userID == updatedUser.userID }) {
            users[index] = updatedUser
        }
    }

    static func deleteUser(byID userID: String) {
        users.removeAll { $0.userID == userID }
    }

    // MARK: - Cart Management
    
    static func addCartItem(_ cartItem: CartItem) {
        cartItems.append(cartItem)
    }

    // MARK: - Order Management
    
    static func addOrder(_ order: Order) {
        orders.append(order)
    }

    static func getOrders(forUser userID: String) -> [Order] {
        return orders.filter { $0.userID == userID }
    }

    static func updateOrderStatus(orderID: String, status: OrderStatus) {
        if let index = orders.firstIndex(where: { $0.orderID == orderID }) {
            orders[index].status = status
        }
    }

    static func deleteOrder(byID orderID: String) {
        orders.removeAll { $0.orderID == orderID }
    }

    // MARK: - Static Data
    
    static var sectionHeaderNames: [String] = [
        "Menu List",
        "Chef's Speciality Dishes",
        "Meal Subscription Plans"
    ]
    
    static var sectionHeaderLandingNames: [String] = [
        "Meal Categories",
        "Chef's Speciality",
        "Nearest Kitchens"
    ]

    static var mealBanner: [MealBanner] = [
        MealBanner(
        title: "Rise and Shine Breakfast",
        subtitle: "Order Before 7 am",
        deliveryTime: "Delivery expected by 9 am",
        timer: "00 min",
        icon: "BreakfastIcon",
        mealType: "Breakfast"
    ),
         MealBanner(
             title: "Taste the Noon Magic",
             subtitle: "Order Before 11 am",
             deliveryTime: "Delivery expected by 1 pm",
             timer: "00 min",
             icon: "LunchIcon",
             mealType: "Lunch"
         ),
         MealBanner(
             title: "Evening Snack Treat",
             subtitle: "Order Before 4 pm",
             deliveryTime: "Delivery expected by 6 pm",
             timer: "00 min",
             icon: "SnacksIcon",
             mealType: "Snacks"
         ),
         MealBanner(
             title: "Delightful Dinner",
             subtitle: "Order Before 8 pm",
             deliveryTime: "Delivery expected by 10 pm",
             timer: "00 min",
             icon: "DinnerIcon",
             mealType: "Dinner"
         )
     ]
    
    static var user: [User] = [
        User(
            userID: nil,
            name: nil,
            email: nil,
            phoneNumber: nil,
            address: "Galgotias University, Greater Noida"
        )
    ]
}

