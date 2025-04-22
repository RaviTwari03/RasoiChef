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
    
    static func loadData() async throws {
        print("\n🔄 Starting data loading process...")
        
        do {
            try await withThrowingTaskGroup(of: Void.self) { group in
                // Fetch kitchens
                group.addTask {
                    print("\n📥 Fetching kitchens...")
                    do {
                        let allKitchens = try await SupabaseController.shared.fetchKitchens()
                        print("✅ Successfully loaded \(allKitchens.count) kitchens")
                        kitchens = allKitchens
                    } catch {
                        print("❌ Error fetching kitchens: \(error.localizedDescription)")
                        throw error
                    }
                }
                
                // Fetch menu items
                group.addTask {
                    print("\n📥 Fetching menu items...")
                    do {
                        let allMenuItems = try await SupabaseController.shared.fetchMenuItems()
                        print("✅ Successfully loaded \(allMenuItems.count) menu items")
                        
                        // Sort menu items into different categories
                        menuItems = allMenuItems
                        
                        // Sort by meal type with detailed logging
                        print("\n📊 Categorizing menu items...")
                        
                        GlobalbreakfastMenuItems = allMenuItems.filter { $0.availableMealTypes == .breakfast }
                        GloballunchMenuItems = allMenuItems.filter { $0.availableMealTypes == .lunch }
                        GlobalsnacksMenuItems = allMenuItems.filter { $0.availableMealTypes == .snacks }
                        GlobaldinnerMenuItems = allMenuItems.filter { $0.availableMealTypes == .dinner }
                        
                        print("\n📊 Menu Items Summary:")
                        print("- Breakfast: \(GlobalbreakfastMenuItems.count)")
                        print("- Lunch: \(GloballunchMenuItems.count)")
                        print("- Snacks: \(GlobalsnacksMenuItems.count)")
                        print("- Dinner: \(GlobaldinnerMenuItems.count)")
                    } catch {
                        print("❌ Error fetching menu items: \(error.localizedDescription)")
                        throw error
                    }
                }
                
                // Fetch subscription plans
                group.addTask {
                    print("\n📥 Fetching subscription plans...")
                    do {
                        let allSubscriptionPlans = try await SupabaseController.shared.fetchSubscriptionPlans()
                        print("✅ Successfully loaded \(allSubscriptionPlans.count) subscription plans")
                        subscriptionPlan = allSubscriptionPlans
                    } catch {
                        print("❌ Error fetching subscription plans: \(error.localizedDescription)")
                        throw error
                    }
                }
                
                // Fetch chef specialty dishes
                group.addTask {
                    print("\n📥 Fetching chef specialty dishes...")
                    do {
                        let allChefSpecialtyDishes = try await SupabaseController.shared.fetchChefSpecialtyDishes()
                        print("✅ Successfully loaded \(allChefSpecialtyDishes.count) chef specialty dishes")
                        chefSpecialtyDishes = allChefSpecialtyDishes
                        globalChefSpecial = allChefSpecialtyDishes
                    } catch {
                        print("❌ Error fetching chef specialty dishes: \(error.localizedDescription)")
                        throw error
                    }
                }
                
                // Wait for all tasks to complete and handle any errors
                try await group.waitForAll()
            }
            
            // Print final statistics
            print("\n📊 Final Data Loading Statistics:")
            print("- Kitchens: \(kitchens.count)")
            print("- Menu Items: \(menuItems.count)")
            print("- Chef Specialty Dishes: \(chefSpecialtyDishes.count)")
            print("- Subscription Plans: \(subscriptionPlan.count)")
            
            if kitchens.isEmpty && menuItems.isEmpty && chefSpecialtyDishes.isEmpty && subscriptionPlan.isEmpty {
                throw NSError(domain: "DataLoadingError", 
                            code: -1, 
                            userInfo: [NSLocalizedDescriptionKey: "No data was loaded from any source"])
            }
            
            print("✅ All data loaded successfully")
            
        } catch {
            print("\n❌ Error loading data:")
            print("- Type: \(type(of: error))")
            print("- Description: \(error.localizedDescription)")
            if let nsError = error as NSError? {
                print("- Domain: \(nsError.domain)")
                print("- Code: \(nsError.code)")
                print("- User Info: \(nsError.userInfo)")
            }
            throw error
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

    // MARK: - Kitchen-Specific Data
    
    static func getKitchenMenuItems(forKitchenID kitchenID: String) -> [MenuItem] {
        return menuItems.filter { $0.kitchenID == kitchenID }
    }
    
    static func getKitchenChefSpecialtyDishes(forKitchenID kitchenID: String) -> [ChefSpecialtyDish] {
        return chefSpecialtyDishes.filter { $0.kitchenID == kitchenID }
    }
    
    static func getKitchenSubscriptionPlans(forKitchenID kitchenID: String) -> [SubscriptionPlan] {
        return subscriptionPlan.filter { $0.kitchenID == kitchenID }
    }
    
    static func loadKitchenSpecificData(forKitchenID kitchenID: String) {
        // Filter menu items for this kitchen
        menuItems = getKitchenMenuItems(forKitchenID: kitchenID)
        
        // Filter and update meal type specific arrays
        GlobalbreakfastMenuItems = menuItems.filter { $0.availableMealTypes == .breakfast }
        GloballunchMenuItems = menuItems.filter { $0.availableMealTypes == .lunch }
        GlobalsnacksMenuItems = menuItems.filter { $0.availableMealTypes == .snacks }
        GlobaldinnerMenuItems = menuItems.filter { $0.availableMealTypes == .dinner }
        
        // Filter chef specialty dishes for this kitchen
        chefSpecialtyDishes = getKitchenChefSpecialtyDishes(forKitchenID: kitchenID)
        
        // Filter subscription plans for this kitchen
        subscriptionPlan = getKitchenSubscriptionPlans(forKitchenID: kitchenID)
    }
}

