//
//
//  Data Controller.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 17/01/25.
//

import Foundation
import Supabase

class KitchenDataController {
    static let shared = KitchenDataController()
    
    private init() {}
    
    // MARK: - Data Storage
    static var users: [User] = []
    static var kitchens: [Kitchen] = []
    static var filteredKitchens: [Kitchen] = [] // For kitchen-specific view
    static var menuItems: [MenuItem] = []
    static var filteredMenuItems: [MenuItem] = [] // For kitchen-specific view
    static var subscriptionMenuItems: [MenuItem] = []
    static var chefSpecialtyDishes: [ChefSpecialtyDish] = []
    static var filteredChefSpecialtyDishes: [ChefSpecialtyDish] = [] // For kitchen-specific view
    static var globalChefSpecial: [ChefSpecialtyDish] = []
    static var subscriptionPlan: [SubscriptionPlan] = []
    static var filteredSubscriptionPlan: [SubscriptionPlan] = [] // For kitchen-specific view
    static var GloballunchMenuItems: [MenuItem] = []
    static var GlobalbreakfastMenuItems: [MenuItem] = []
    static var GlobalsnacksMenuItems: [MenuItem] = []
    static var GlobaldinnerMenuItems: [MenuItem] = []
    static var filteredLunchMenuItems: [MenuItem] = [] // For kitchen-specific view
    static var filteredBreakfastMenuItems: [MenuItem] = [] // For kitchen-specific view
    static var filteredSnacksMenuItems: [MenuItem] = [] // For kitchen-specific view
    static var filteredDinnerMenuItems: [MenuItem] = [] // For kitchen-specific view
    static var cartItems: [CartItem] = []
    static var orders: [Order] = []
    static var favoriteKitchens: Set<String> = [] // Store favorite kitchen IDs
    
    // MARK: - Favorites Management
    static func toggleFavorite(for kitchen: Kitchen) -> Bool {
        print("🔍 Starting toggleFavorite for kitchen: \(kitchen.name)")
        print("🔍 Searching for kitchen with ID: \(kitchen.kitchenID)")
        if let index = kitchens.firstIndex(where: { $0.kitchenID == kitchen.kitchenID }) {
            print("✅ Found kitchen at index: \(index)")
            let newState = !kitchens[index].isFavorite
            print("🔄 Toggling favorite state to: \(newState)")
            kitchens[index].isFavorite = newState
            
            print("🔍 Starting async task to update database")
            Task<Void, Never> { @MainActor in
                do {
                    print("🔍 Attempting to get current session...")
                    guard let session = try await SupabaseController.shared.getCurrentSession() else {
                        print("❌ No active session found")
                        print("No active session")
                        return
                    }
                    
                    let userID = session.user.id
                    print("✅ Got user ID: \(userID.uuidString)")
                    
                    if kitchens[index].isFavorite {
                        print("🔍 Kitchen is now favorite, adding to database...")
                        print("🔍 Adding kitchen to favorites - Kitchen ID: \(kitchen.kitchenID), User ID: \(userID.uuidString)")
                        favoriteKitchens.insert(kitchen.kitchenID)
                        // Add to database
                        print("🔄 Attempting to insert favorite - User ID: \(userID.uuidString), Kitchen ID: \(kitchen.kitchenID)")
                        let response = try await SupabaseController.shared.client.database
                            .from("kitchen_favorites")
                            .insert([
                                "user_id": userID.uuidString,
                                "kitchen_id": kitchen.kitchenID
                            ])
                            .execute()
                        print("✅ Successfully inserted favorite: \(response)")
                    } else {
                        print("🔍 Kitchen is no longer favorite, removing from database...")
                        favoriteKitchens.remove(kitchen.kitchenID)
                        // Remove from database
                        try await SupabaseController.shared.client.database
                            .from("kitchen_favorites")
                            .delete()
                            .eq("user_id", value: userID.uuidString)
                            .eq("kitchen_id", value: kitchen.kitchenID)
                            .execute()
                        print("✅ Successfully removed kitchen from favorites")
                    }
                    
                    // Save favorites to UserDefaults for quick local access
                    UserDefaults.standard.set(Array(favoriteKitchens), forKey: "FavoriteKitchens")
                    print("✅ Successfully saved favorites to UserDefaults")
                } catch {
                    print("❌ Error updating favorites:")
                    print("   Error type: \(type(of: error))")
                    print("   Description: \(error.localizedDescription)")
                    if let nsError = error as NSError? {
                        print("   Domain: \(nsError.domain)")
                        print("   Code: \(nsError.code)")
                        print("   User Info: \(nsError.userInfo)")
                    }
                }
            }
            return kitchens[index].isFavorite
        }
        return false
    }
    
    static func loadFavorites() {
        // First load from UserDefaults for quick access
        if let savedFavorites = UserDefaults.standard.array(forKey: "FavoriteKitchens") as? [String] {
            favoriteKitchens = Set(savedFavorites)
        }
        
        // Then sync with database
        Task<Void, Never> { @MainActor in
            do {
                guard let session = try await SupabaseController.shared.getCurrentSession() else {
                    print("No active session")
                    return
                }
                
                let userID = session.user.id
                
                let response = try await SupabaseController.shared.client.database
                    .from("user_favorites")
                    .select("kitchen_id")
                    .eq("user_id", value: userID)
                    .execute()
                
                if let json = try? JSONSerialization.jsonObject(with: response.data, options: []) as? [[String: Any]] {
                    let dbFavorites = Set(json.compactMap { $0["kitchen_id"] as? String })
                    favoriteKitchens = dbFavorites
                    
                    // Update UserDefaults
                    UserDefaults.standard.set(Array(favoriteKitchens), forKey: "FavoriteKitchens")
                    
                    // Update isFavorite status for all kitchens
                    for (index, kitchen) in kitchens.enumerated() {
                        kitchens[index].isFavorite = favoriteKitchens.contains(kitchen.kitchenID)
                    }
                }
            } catch {
                print("Error loading favorites from database: \(error)")
            }
        }
    }
    

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
        // Filter kitchens for this specific kitchen
        filteredKitchens = kitchens.filter { $0.kitchenID == kitchenID }
        
        // Filter menu items for this kitchen
        filteredMenuItems = getKitchenMenuItems(forKitchenID: kitchenID)
        
        // Define standard meal type order
        let mealTypeOrder: [MealType] = [.breakfast, .lunch, .snacks, .dinner]
        
        // Sort filtered menu items by meal type order
        filteredMenuItems.sort { item1, item2 in
            guard let type1 = item1.availableMealTypes,
                  let type2 = item2.availableMealTypes,
                  let index1 = mealTypeOrder.firstIndex(of: type1),
                  let index2 = mealTypeOrder.firstIndex(of: type2) else {
                return false
            }
            return index1 < index2
        }
        
        // Filter and update meal type specific arrays in order
        filteredBreakfastMenuItems = filteredMenuItems.filter { $0.availableMealTypes == .breakfast }
        filteredLunchMenuItems = filteredMenuItems.filter { $0.availableMealTypes == .lunch }
        filteredSnacksMenuItems = filteredMenuItems.filter { $0.availableMealTypes == .snacks }
        filteredDinnerMenuItems = filteredMenuItems.filter { $0.availableMealTypes == .dinner }
        
        // Filter chef specialty dishes for this kitchen
        filteredChefSpecialtyDishes = getKitchenChefSpecialtyDishes(forKitchenID: kitchenID)
        
        // Filter subscription plans for this kitchen
        filteredSubscriptionPlan = getKitchenSubscriptionPlans(forKitchenID: kitchenID)
    }
}

