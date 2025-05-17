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
    static var availableCoupons: [Coupon] = []
    static var userCouponUsage: [UserCouponUsage] = []
    
    // MARK: - Supabase Client
    private static let client = SupabaseController.shared.client
    
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
                    let session = try await client.auth.session
                    print("✅ Got session for user: \(session.user.id.uuidString)")
                    
                    let userID = session.user.id
                    print("✅ Got user ID: \(userID.uuidString)")
                    
                    if kitchens[index].isFavorite {
                        print("🔍 Kitchen is now favorite, adding to database...")
                        print("🔍 Adding kitchen to favorites - Kitchen ID: \(kitchen.kitchenID), User ID: \(userID.uuidString)")
                        favoriteKitchens.insert(kitchen.kitchenID)
                        // Add to database
                        print("🔄 Attempting to insert favorite - User ID: \(userID.uuidString), Kitchen ID: \(kitchen.kitchenID)")
                        let response = try await client
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
                        try await client
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
                    
                    // Post notification that favorites have been updated
                    NotificationCenter.default.post(name: NSNotification.Name("FavoritesUpdated"), object: nil)
                    
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
        print("\n🔄 Loading favorites...")
        
        // First load from UserDefaults for quick access
        if let savedFavorites = UserDefaults.standard.array(forKey: "FavoriteKitchens") as? [String] {
            print("📱 Loaded \(savedFavorites.count) favorites from UserDefaults")
            favoriteKitchens = Set(savedFavorites)
        } else {
            print("📱 No favorites found in UserDefaults")
        }
        
        // Then sync with database
        Task<Void, Never> { @MainActor in
            do {
                print("🔍 Attempting to get current session...")
                guard let session = try await SupabaseController.shared.getCurrentSession() else {
                    print("❌ No active session found")
                    return
                }
                
                let userID = session.user.id
                print("✅ Got user ID: \(userID.uuidString)")
                
                print("📥 Fetching favorites from database...")
                let response = try await SupabaseController.shared.client
                    .from("kitchen_favorites")
                    .select("kitchen_id")
                    .eq("user_id", value: userID.uuidString)
                    .execute()
                
                print("📦 Raw response data: \(String(data: response.data, encoding: .utf8) ?? "none")")
                
                if let json = try? JSONSerialization.jsonObject(with: response.data, options: []) as? [[String: Any]] {
                    let dbFavorites = Set(json.compactMap { $0["kitchen_id"] as? String })
                    print("✅ Found \(dbFavorites.count) favorites in database")
                    print("📋 Database favorites: \(dbFavorites)")
                    
                    favoriteKitchens = dbFavorites
                    
                    // Update UserDefaults
                    UserDefaults.standard.set(Array(favoriteKitchens), forKey: "FavoriteKitchens")
                    print("✅ Updated UserDefaults with \(favoriteKitchens.count) favorites")
                    
                    // Update isFavorite status for all kitchens
                    for (index, kitchen) in kitchens.enumerated() {
                        let isFavorite = favoriteKitchens.contains(kitchen.kitchenID)
                        kitchens[index].isFavorite = isFavorite
                        print("🔍 Updated kitchen \(kitchen.name) favorite status to: \(isFavorite)")
                    }
                    
                    // Post notification that favorites have been updated
                    print("📢 Posting FavoritesUpdated notification")
                    NotificationCenter.default.post(name: NSNotification.Name("FavoritesUpdated"), object: nil)
                } else {
                    print("❌ Failed to parse favorites from database response")
                }
            } catch {
                print("❌ Error loading favorites from database:")
                print("   Error type: \(type(of: error))")
                print("   Description: \(error.localizedDescription)")
                if let nsError = error as NSError? {
                    print("   Domain: \(nsError.domain)")
                    print("   Code: \(nsError.code)")
                    print("   User Info: \(nsError.userInfo)")
                }
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

    // MARK: - Coupon Management

    static func fetchAvailableCoupons() async throws {
        print("\n🔄 Fetching available coupons...")
        
        do {
            // First try to get the session
            let session = try await client.auth.session
            print("✅ Got session for user: \(session.user.id.uuidString)")
            
            // Get user ID from session
            let userId = session.user.id.uuidString
            
            // Verify user exists in users table
            let userResponse = try await client.database
                .from("users")
                .select("user_id")
                .eq("user_id", value: userId)
                .execute()
            
            let users = try JSONDecoder().decode([[String: String]].self, from: userResponse.data)
            
            guard !users.isEmpty else {
                print("❌ User not found in database")
                throw NSError(domain: "DataController", code: 404, userInfo: [NSLocalizedDescriptionKey: "User account not found. Please log out and sign in again."])
            }
            
            print("✅ User verified in database")
            
            // Create a custom decoder with date decoding strategy
            let decoder = JSONDecoder()
            
            // Create a custom date decoding strategy that can handle null values
            let dateFormatter = ISO8601DateFormatter()
            dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            
            decoder.dateDecodingStrategy = .custom { decoder in
                let container = try decoder.singleValueContainer()
                if container.decodeNil() {
                    return Date()
                }
                let dateString = try container.decode(String.self)
                guard let date = dateFormatter.date(from: dateString) else {
                    throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
                }
                return date
            }
            
            // Fetch all coupons
            let response = try await client
                .from("coupons")
                .select()
                .execute()
            
            print("✅ Fetched coupons from database")
            print("📦 Raw coupon data: \(String(data: response.data, encoding: .utf8) ?? "none")")
            
            // Try to parse the raw JSON first to see its structure
            if let json = try? JSONSerialization.jsonObject(with: response.data, options: []) as? [[String: Any]] {
                print("📋 JSON structure:")
                for (index, coupon) in json.enumerated() {
                    print("\nCoupon \(index + 1):")
                    for (key, value) in coupon {
                        print("  \(key): \(value)")
                    }
                }
            }
            
            let coupons = try decoder.decode([Coupon].self, from: response.data)
            print("✅ Decoded \(coupons.count) coupons")
            
            // Fetch user's coupon usage
            let usageResponse = try await client
                .from("user_coupon_usage")
                .select()
                .eq("user_id", value: userId)
                .execute()
            
            print("✅ Fetched user coupon usage")
            print("📦 Raw usage data: \(String(data: usageResponse.data, encoding: .utf8) ?? "none")")
            
            // Try to parse the raw JSON first to see its structure
            if let json = try? JSONSerialization.jsonObject(with: usageResponse.data, options: []) as? [[String: Any]] {
                print("📋 Usage JSON structure:")
                for (index, usage) in json.enumerated() {
                    print("\nUsage \(index + 1):")
                    for (key, value) in usage {
                        print("  \(key): \(value)")
                    }
                }
            }
            
            let userUsage = try decoder.decode([UserCouponUsage].self, from: usageResponse.data)
            print("✅ Decoded \(userUsage.count) user coupon usages")
            
            // Update coupon status based on usage
            var updatedCoupons = coupons
            for (index, coupon) in coupons.enumerated() {
                // Check if coupon has been used by this user
                let isUsed = userUsage.contains { $0.couponId == coupon.id }
                updatedCoupons[index].isUsed = isUsed
                
                // Get order count for this user
                let orderCount = try await getOrderCount(for: userId)
                updatedCoupons[index].orderCount = orderCount
                
                // Enable coupon based on its type and conditions
                if coupon.isOneTimeUse {
                                    // For one-time use coupons, enable if not used
                                    updatedCoupons[index].isEnabled = !isUsed
                                } else {
                                    // For loyalty coupon (multiple use), enable after every 5 orders
                                    // Reset the enabled status after each use
                                    let usageCount = userUsage.filter { $0.couponId == coupon.id }.count
                                    let remainingOrders = orderCount - (usageCount * 5)
                                    updatedCoupons[index].isEnabled = remainingOrders >= 5
                                }
            }
            
            // Update the available coupons
            availableCoupons = updatedCoupons
            userCouponUsage = userUsage
            
            print("✅ Successfully updated coupon data")
            print("- Available coupons: \(availableCoupons.count)")
            print("- User coupon usage: \(userCouponUsage.count)")
            
        } catch {
            print("❌ Error fetching coupons: \(error.localizedDescription)")
            
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case .keyNotFound(let key, let context):
                    print("❌ Missing key: \(key.stringValue)")
                    print("Context: \(context.debugDescription)")
                    throw NSError(domain: "DataController", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid coupon data format: Missing field '\(key.stringValue)'"])
                case .typeMismatch(let type, let context):
                    print("❌ Type mismatch: Expected \(type)")
                    print("Context: \(context.debugDescription)")
                    throw NSError(domain: "DataController", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid coupon data format: Type mismatch for field '\(context.codingPath.last?.stringValue ?? "unknown")'"])
                case .valueNotFound(let type, let context):
                    print("❌ Value not found: Expected \(type)")
                    print("Context: \(context.debugDescription)")
                    throw NSError(domain: "DataController", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid coupon data format: Missing value for field '\(context.codingPath.last?.stringValue ?? "unknown")'"])
                case .dataCorrupted(let context):
                    print("❌ Data corrupted")
                    print("Context: \(context.debugDescription)")
                    throw NSError(domain: "DataController", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid coupon data format: Data is corrupted"])
                @unknown default:
                    print("❌ Unknown decoding error: \(decodingError)")
                    throw NSError(domain: "DataController", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid coupon data format"])
                }
            } else if let authError = error as? AuthError {
                switch authError {
                case .sessionNotFound:
                    throw NSError(domain: "DataController", code: 401, userInfo: [NSLocalizedDescriptionKey: "Your session has expired. Please sign in again."])
                default:
                    throw NSError(domain: "DataController", code: 401, userInfo: [NSLocalizedDescriptionKey: "Authentication error. Please sign in again."])
                }
            } else {
                throw error
            }
        }
    }

    static func applyCoupon(code: String, orderAmount: Double) async throws -> Coupon {
        print("\n🔄 Applying coupon: \(code)")
        
        let session = try await client.auth.session
        let userId = session.user.id.uuidString
        
        // Find the coupon
        guard let coupon = availableCoupons.first(where: { $0.code == code }) else {
            throw NSError(domain: "DataController", code: 404, userInfo: [NSLocalizedDescriptionKey: "Coupon not found"])
        }
        
        // Validate coupon
        guard coupon.isEnabled else {
            throw NSError(domain: "DataController", code: 400, userInfo: [NSLocalizedDescriptionKey: "Coupon is not enabled"])
        }
        
        guard orderAmount >= coupon.minimumOrderAmount else {
            throw NSError(domain: "DataController", code: 400, userInfo: [NSLocalizedDescriptionKey: "Order amount is less than minimum required"])
        }
        
        if coupon.isOneTimeUse {
            guard !coupon.isUsed else {
                throw NSError(domain: "DataController", code: 400, userInfo: [NSLocalizedDescriptionKey: "Coupon has already been used"])
            }
        }
        
        return coupon
    }

    static func recordCouponUsage(couponId: String, orderId: String) async throws {
        print("\n🔄 Recording coupon usage for coupon: \(couponId)")
        
        let session = try await client.auth.session
        let userId = session.user.id.uuidString
        
        // Format date to ISO 8601 string
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let currentDate = dateFormatter.string(from: Date())
        
        // Record usage in database
        try await client
            .from("user_coupon_usage")
            .insert([
                "user_id": userId,
                "coupon_id": couponId,
                "order_id": orderId,
                "used_at": currentDate
            ])
            .execute()
        
        // Update local state
        if let index = availableCoupons.firstIndex(where: { $0.id == couponId }) {
            availableCoupons[index].isUsed = true
        }
        
        print("✅ Successfully recorded coupon usage")
    }

    private static func getOrderCount(for userId: String) async throws -> Int {
        let response = try await client
            .from("orders")
            .select("order_id")
            .eq("user_id", value: userId)
            .eq("status", value: OrderStatus.delivered.rawValue)
            .execute()
        
        let orders = try JSONDecoder().decode([[String: String]].self, from: response.data)
        return orders.count
    }
}

