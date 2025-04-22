import Foundation
import Supabase

class SupabaseController {
    static let shared = SupabaseController()
    
    let client: SupabaseClient
    
    private init() {
        print("\n🔄 Initializing SupabaseController...")
        print("🔗 Connecting to Supabase URL: https://outrozdhosucrncnpoze.supabase.co")
        client = SupabaseClient(
            supabaseURL: URL(string: "https://outrozdhosucrncnpoze.supabase.co")!,
            supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im91dHJvemRob3N1Y3JuY25wb3plIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQyNjM1NDMsImV4cCI6MjA1OTgzOTU0M30.iUqo3FODlyjj8On1PtbUqmUVHNwyBiez4MGi4WZDJSM"
        )
        print("✅ SupabaseController initialized successfully")
        
        // Test the connection
        Task {
            do {
                let response = try await client.database
                    .from("kitchen")
                    .select("count")
                    .execute()
                print("✅ Successfully connected to Supabase database")
            } catch {
                print("❌ Failed to connect to Supabase database: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Authentication Methods
    
    func getCurrentSession() async throws -> Session? {
        print("🔄 Getting current session...")
        do {
            let session = try await client.auth.session
            print(session != nil ? "✅ Session found" : "ℹ️ No active session")
            return session
        } catch {
            print("❌ Error getting session: \(error.localizedDescription)")
            throw error
        }
    }
    
    // MARK: - Data Fetching Methods
    
    func fetchKitchens() async throws -> [Kitchen] {
        print("\n🔄 Starting kitchen fetch process...")
        print("📊 Query details:")
        print("- Table: kitchens")
        
        do {
            let kitchenResponse = try await client.database
                .from("kitchens")
                .select("""
                    kitchen_id,
                    name,
                    location,
                    rating,
                    is_online,
                    distance,
                    kitchen_image,
                    is_pure_veg,
                    "Cuisine"
                """)
                .execute()
            
            print("\n📥 Raw Kitchen Response:")
            print("Response type: \(type(of: kitchenResponse.data))")
            
            // Convert Data to JSON
            let json = try JSONSerialization.jsonObject(with: kitchenResponse.data, options: []) as? [[String: Any]]
            guard let kitchenData = json else {
                print("❌ Failed to decode JSON data")
                print("Raw data size: \(kitchenResponse.data.count) bytes")
                throw NSError(domain: "SupabaseError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode JSON data"])
            }
            
            print("✅ Successfully decoded JSON data")
            print("Found \(kitchenData.count) kitchen records")
            
            var kitchens: [Kitchen] = []
            
            for kitchenJson in kitchenData {
                print("\n🔄 Processing kitchen: \(kitchenJson["name"] ?? "Unknown")")
                
                do {
                    // Required fields
                    guard let kitchenID = kitchenJson["kitchen_id"] as? String,
                          let name = kitchenJson["name"] as? String,
                          let location = kitchenJson["location"] as? String
                    else {
                        print("\n❌ Missing required fields for kitchen")
                        print("Available fields and types:")
                        kitchenJson.forEach { key, value in
                            print("- \(key): \(type(of: value))")
                        }
                        continue
                    }
                    
                    // Optional fields with default values
                    let rating = (kitchenJson["rating"] as? NSNumber)?.floatValue ?? kitchenJson["rating"] as? Float ?? 0.0
                    let isOnline = kitchenJson["is_online"] as? Bool ?? false
                    let distance = (kitchenJson["distance"] as? NSNumber)?.doubleValue ?? kitchenJson["distance"] as? Double ?? 0.0
                    let kitchenImage = kitchenJson["kitchen_image"] as? String ?? ""
                    let isPureVeg = kitchenJson["is_pure_veg"] as? Bool ?? false
                    
                    // Process cuisine - take the first cuisine if available
                    var cuisine: Cuisine? = nil
                    if let cuisineString = kitchenJson["Cuisine"] as? String {
                        cuisine = Cuisine(rawValue: cuisineString)  // Enum cases should match exactly
                    }
                    
                    let kitchen = Kitchen(
                        kitchenID: kitchenID,
                        name: name,
                        location: location,
                        cuisine: cuisine,
                        rating: rating,
                        isOnline: isOnline,
                        distance: distance,
                        kitchenImage: kitchenImage,
                        isPureVeg: isPureVeg
                    )
                    
                    print("✅ Successfully processed kitchen: \(name)")
                    kitchens.append(kitchen)
                } catch {
                    print("❌ Error processing kitchen: \(error.localizedDescription)")
                    continue
                }
            }
            
            print("\n✅ Successfully processed all kitchens")
            return kitchens
            
        } catch {
            print("\n❌ Error fetching kitchens:")
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
    
    func fetchMenuItems() async throws -> [MenuItem] {
        print("\n🔄 Starting menu items fetch process...")
        print("📊 Query details:")
        print("- Table: menu_items")
        
        do {
            let response = try await client.database
                .from("menu_items")
                .select("""
                    item_id,
                    kitchen_id,
                    kitchen_name,
                    distance,
                    available_date,
                    name,
                    description,
                    price,
                    rating,
                    available_meal_types,
                    portion_size,
                    intake_limit,
                    image_url,
                    order_deadline,
                    receiving_deadline,
                    availability,
                    available_days,
                    meal_categories
                """)
                .execute()
            
            print("\n📥 Raw Menu Items Response:")
            
            // Convert Data to JSON
            let json = try JSONSerialization.jsonObject(with: response.data, options: []) as? [[String: Any]]
            guard let menuData = json else {
                print("❌ Failed to decode JSON data")
                print("Raw data size: \(response.data.count) bytes")
                throw NSError(domain: "SupabaseError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode JSON data"])
            }
            
            print("✅ Successfully decoded JSON data")
            print("Found \(menuData.count) menu item records")
            
            var menuItems: [MenuItem] = []
            
            for menuItemJson in menuData {
                do {
                    guard let itemID = menuItemJson["item_id"] as? String,
                          let kitchenID = menuItemJson["kitchen_id"] as? String,
                          let kitchenName = menuItemJson["kitchen_name"] as? String,
                          let name = menuItemJson["name"] as? String,
                          let price = (menuItemJson["price"] as? NSNumber)?.doubleValue ?? menuItemJson["price"] as? Double
                    else {
                        print("\n❌ Missing required fields for menu item")
                        print("Available fields and types:")
                        menuItemJson.forEach { key, value in
                            print("- \(key): \(type(of: value))")
                        }
                        continue
                    }
                    
                    // Handle optional fields with default values
                    let description = (menuItemJson["description"] as? String) ?? ""
                    let rating = (menuItemJson["rating"] as? NSNumber)?.floatValue ?? (menuItemJson["rating"] as? Float) ?? 0.0
                    let portionSize = (menuItemJson["portion_size"] as? String) ?? ""
                    let intakeLimit = (menuItemJson["intake_limit"] as? NSNumber)?.intValue ?? (menuItemJson["intake_limit"] as? Int) ?? 10
                    let imageURL = (menuItemJson["image_url"] as? String) ?? ""
                    let orderDeadline = (menuItemJson["order_deadline"] as? String) ?? ""
                    let availableDate = (menuItemJson["available_date"] as? String) ?? ""
                    let distance = (menuItemJson["distance"] as? NSNumber)?.doubleValue ?? (menuItemJson["distance"] as? Double) ?? 0.0
                    
                    // Process meal types
                    var mealType: MealType? = nil
                    if let mealTypeString = menuItemJson["available_meal_types"] as? String {
                        mealType = MealType(rawValue: mealTypeString)
                    }
                    
                    // Process available days
                    var availableDays: [WeekDay] = []
                    if let dayArray = menuItemJson["available_days"] as? [String] {
                        for dayString in dayArray {
                            if let day = WeekDay(rawValue: dayString.lowercased()) {
                                availableDays.append(day)
                            }
                        }
                    }
                    
                    // Process meal categories
                    var mealCategories: [MealCategory] = []
                    if let categoryArray = menuItemJson["meal_categories"] as? [String] {
                        for categoryString in categoryArray {
                            if let category = MealCategory(rawValue: categoryString.lowercased()) {
                                mealCategories.append(category)
                            }
                        }
                    }
                    
                    // Process availability
                    var availability: [Availabiltiy] = []
                    if let availabilityArray = menuItemJson["availability"] as? [String] {
                        for availabilityString in availabilityArray {
                            if let availabilityStatus = Availabiltiy(rawValue: availabilityString) {
                                availability.append(availabilityStatus)
                            }
                        }
                    }
                    
                    // Parse the date string to Date object
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let parsedDate = availableDate.isEmpty ? nil : dateFormatter.date(from: availableDate)
                    
                    // Create MenuItem from menu_items data
                    let menuItem = MenuItem(
                        itemID: itemID,
                        kitchenID: kitchenID,
                        kitchenName: kitchenName,
                        distance: distance,
                        availableDate: parsedDate,
                        name: name,
                        description: description,
                        price: price,
                        rating: rating,
                        availableMealTypes: mealType,
                        portionSize: portionSize,
                        intakeLimit: intakeLimit,
                        imageURL: imageURL,
                        orderDeadline: orderDeadline,
                        recievingDeadline: menuItemJson["receiving_deadline"] as? String,
                        availability: availability.isEmpty ? [.Available] : availability,
                        availableDays: availableDays,
                        mealCategory: mealCategories
                    )
                    
                    menuItems.append(menuItem)
                    
                } catch {
                    print("❌ Error processing menu item: \(error.localizedDescription)")
                    continue
                }
            }
            
            return menuItems
            
        } catch {
            print("\n❌ Error fetching menu items:")
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
    
    func fetchSubscriptionPlans() async throws -> [SubscriptionPlan] {
        print("\n🔄 Starting subscription plans fetch process...")
        print("📊 Query details:")
        print("- Table: subscription_plans")
        
        do {
            // First fetch the subscription plans
            let plansResponse = try await client.database
                .from("subscription_plans")
                .select("""
                    plan_id,
                    kitchen_id,
                    location,
                    start_date,
                    end_date,
                    total_price,
                    plan_name,
                    intake_limit,
                    plan_image
                """)
                .execute()
            
            print("\n📥 Raw Subscription Plans Response:")
            
            // Convert Plans Data to JSON
            let json = try JSONSerialization.jsonObject(with: plansResponse.data, options: []) as? [[String: Any]]
            guard let plansData = json else {
                print("❌ Failed to decode subscription plans JSON data")
                throw NSError(domain: "SupabaseError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode JSON data"])
            }
            
            print("✅ Successfully decoded subscription plans JSON data")
            print("Found \(plansData.count) subscription plan records")
            
            var subscriptionPlans: [SubscriptionPlan] = []
            
            // Process each plan
            for planJson in plansData {
                do {
                    let planID = planJson["plan_id"] as? String ?? UUID().uuidString
                    
                    // Fetch meals for this plan
                    print("\n🔄 Fetching meals for plan: \(planID)")
                    let mealsResponse = try await client.database
                        .from("subscription_meals")
                        .select("""
                            day,
                            meal_time,
                            menu_item_id,
                            menu_items (
                                item_id,
                                name,
                                description,
                                price,
                                image_url,
                                available_meal_types
                            )
                        """)
                        .eq("plan_id", value: planID)
                        .execute()
                    
                    // Convert Meals Data to JSON
                    let mealsJson = try JSONSerialization.jsonObject(with: mealsResponse.data, options: []) as? [[String: Any]]
                    
                    // Create weeklyMeals dictionary
                    var weeklyMeals: [WeekDay: [MealType: MenuItem?]] = [:]
                    
                    if let mealsData = mealsJson {
                        for mealJson in mealsData {
                            if let dayString = mealJson["day"] as? String,
                               let mealTimeString = mealJson["meal_time"] as? String,
                               let menuItemData = mealJson["menu_items"] as? [String: Any] {
                                
                                // Convert day string to WeekDay
                                guard let weekDay = WeekDay(rawValue: dayString.lowercased()) else {
                                    print("❌ Invalid weekday: \(dayString)")
                                    continue
                                }
                                
                                // Convert meal_time to MealType
                                guard let mealType = MealType(rawValue: mealTimeString.capitalized) else {
                                    print("❌ Invalid meal type: \(mealTimeString)")
                                    continue
                                }
                                
                                // Create MenuItem from menu_items data
                                let menuItem = MenuItem(
                                    itemID: menuItemData["item_id"] as? String ?? "",
                                    kitchenID: "",  // These fields aren't needed for subscription display
                                    kitchenName: "",
                                    distance: 0,
                                    availableDate: nil,
                                    name: menuItemData["name"] as? String ?? "",
                                    description: menuItemData["description"] as? String ?? "",
                                    price: menuItemData["price"] as? Double ?? 0.0,
                                    rating: 0,
                                    availableMealTypes: mealType,
                                    portionSize: "",
                                    intakeLimit: 0,
                                    imageURL: menuItemData["image_url"] as? String ?? "",
                                    orderDeadline: "",
                                    recievingDeadline: nil,
                                    availability: [.Available],
                                    availableDays: [weekDay],
                                    mealCategory: []
                                )
                                
                                // Initialize the day's meals if needed
                                if weeklyMeals[weekDay] == nil {
                                    weeklyMeals[weekDay] = [:]
                                }
                                
                                // Add the meal to the weekly schedule
                                weeklyMeals[weekDay]?[mealType] = menuItem
                            }
                        }
                    }
                    
                    // Create the subscription plan with the meals
                    let plan = SubscriptionPlan(
                        planID: planID,
                        kitchenName: "",
                        userID: nil,
                        kitchenID: planJson["kitchen_id"] as? String ?? "",
                        location: planJson["location"] as? String ?? "",
                        startDate: planJson["start_date"] as? String ?? "",
                        endDate: planJson["end_date"] as? String ?? "",
                        totalPrice: (planJson["total_price"] as? NSNumber)?.doubleValue ?? 
                                  (planJson["total_price"] as? Double) ?? 0.0,
                        planName: planJson["plan_name"] as? String ?? "",
                        PlanIntakeLimit: (planJson["intake_limit"] as? NSNumber)?.intValue ?? 
                                       (planJson["intake_limit"] as? Int) ?? 0,
                        planImage: planJson["plan_image"] as? String ?? "",
                        weeklyMeals: weeklyMeals
                    )
                    
                    subscriptionPlans.append(plan)
                    print("✅ Successfully processed plan: \(plan.planName ?? "")")
                    
                } catch {
                    print("❌ Error processing subscription plan: \(error.localizedDescription)")
                    continue
                }
            }
            
            print("\n✅ Successfully processed all subscription plans")
            print("Total plans loaded: \(subscriptionPlans.count)")
            
            return subscriptionPlans
            
        } catch {
            print("\n❌ Error fetching subscription plans:")
            print("- Error type: \(type(of: error))")
            print("- Description: \(error.localizedDescription)")
            if let nsError = error as NSError? {
                print("- Domain: \(nsError.domain)")
                print("- Code: \(nsError.code)")
                print("- User Info: \(nsError.userInfo)")
            }
            throw error
        }
    }
    
    func fetchChefSpecialtyDishes() async throws -> [ChefSpecialtyDish] {
        print("\n🔄 Starting chef specialty dishes fetch process...")
        print("📊 Query details:")
        print("- Table: chef_specialty_dishes")
        print("- Columns: dish_id, kitchen_id, name, description, price, rating, image_url, distance, intake_limit, meal_category")
        
        do {
            let response = try await client.database
                .from("chef_specialty_dishes")
                .select("""
                    dish_id,
                    kitchen_id,
                    name,
                    description,
                    price,
                    rating,
                    image_url,
                    meal_categories,
                    distance,
                    intake_limit
                """)
                .execute()
            
            print("\n📥 Raw Chef Specialty Dishes Response:")
            print("Response data size: \(response.data.count) bytes")
            
            // Debug: Print raw JSON
            if let jsonString = String(data: response.data, encoding: .utf8) {
                print("Raw JSON response:")
                print(jsonString)
            }
            
            // Convert Data to JSON
            let json = try JSONSerialization.jsonObject(with: response.data, options: []) as? [[String: Any]]
            guard let dishesData = json else {
                print("❌ Failed to decode JSON data")
                print("Raw data size: \(response.data.count) bytes")
                throw NSError(domain: "SupabaseError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode JSON data"])
            }
            
            print("✅ Successfully decoded JSON data")
            print("Found \(dishesData.count) chef specialty dish records")
            
            var specialtyDishes: [ChefSpecialtyDish] = []
            
            for dishJson in dishesData {
                do {
                    print("\nProcessing dish: \(dishJson["name"] ?? "Unknown")")
                    
                    guard let dishID = dishJson["dish_id"] as? String,
                          let kitchenID = dishJson["kitchen_id"] as? String,
                          let name = dishJson["name"] as? String,
                          let price = (dishJson["price"] as? NSNumber)?.doubleValue ?? dishJson["price"] as? Double
                    else {
                        print("\n❌ Missing required fields for chef specialty dish")
                        print("Available fields in JSON:")
                        dishJson.forEach { key, value in
                            print("- \(key): \(value)")
                        }
                        continue
                    }
                    
                    // Handle optional fields with default values
                    let description = (dishJson["description"] as? String) ?? ""
                    let rating = (dishJson["rating"] as? NSNumber)?.floatValue ?? (dishJson["rating"] as? Float) ?? 0.0
                    let imageURL = (dishJson["image_url"] as? String) ?? ""
                    let distance = (dishJson["distance"] as? NSNumber)?.doubleValue ?? (dishJson["distance"] as? Double) ?? 0.0
                    let intakeLimit = (dishJson["intake_limit"] as? NSNumber)?.intValue ?? (dishJson["intake_limit"] as? Int) ?? 10
                    
                    // Process meal category
                    var mealCategories: [MealCategory] = []
                    if let categoryArray = dishJson["meal_categories"] as? [String] {
                        for categoryString in categoryArray {
                            if let category = MealCategory(rawValue: categoryString.lowercased()) {
                                mealCategories.append(category)
                            }
                        }
                    }
                    
                    let specialtyDish = ChefSpecialtyDish(
                        kitchenName: "",
                        dishID: dishID,
                        kitchenID: kitchenID,
                        name: name,
                        description: description,
                        price: price,
                        rating: rating,
                        imageURL: imageURL,
                        mealCategory: mealCategories,
                        distance: distance,
                        intakeLimit: intakeLimit
                    )
                    
                    print("✅ Successfully created ChefSpecialtyDish object:")
                    print("- Name: \(specialtyDish.name)")
                    print("- Kitchen: \(specialtyDish.kitchenID)")
                    print("- Price: ₹\(specialtyDish.price)")
                    print("- Rating: \(specialtyDish.rating)")
                    
                    specialtyDishes.append(specialtyDish)
                    
                } catch {
                    print("❌ Error processing chef specialty dish: \(error.localizedDescription)")
                    continue
                }
            }
            
            print("\n✅ Successfully processed all chef specialty dishes")
            print("Total dishes loaded: \(specialtyDishes.count)")
            
            return specialtyDishes
            
        } catch {
            print("\n❌ Error fetching chef specialty dishes:")
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

    // MARK: - Database Models
    private struct DBOrder: Encodable {
        let order_id: String
        let user_id: String
        let kitchen_id: String
        let status: String
        let total_amount: Double
        let delivery_address: String
        let delivery_date: String
        let delivery_type: String
    }

    private struct DBOrderItem: Encodable {
        let order_id: String
        let item_id: String
        let quantity: Int
        let price: Double
    }

    func insertOrder(order: Order) async throws {
        print("\n🔄 Starting order insertion process...")
        print("📊 Order details:")
        print("- Order ID: \(order.orderID)")
        print("- User ID: \(order.userID)")
        print("- Kitchen ID: \(order.kitchenID)")
        print("- Total Amount: ₹\(order.totalAmount)")
        
        do {
            // Format date for PostgreSQL
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let formattedDate = dateFormatter.string(from: order.deliveryDate)
            
            // Ensure kitchen_id is a valid UUID
            guard UUID(uuidString: order.kitchenID) != nil else {
                throw NSError(domain: "OrderError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid kitchen ID format"])
            }
            
            print("\n📤 Inserting order into database...")
            print("- Order ID: \(order.orderID)")
            print("- User ID: \(order.userID)")
            print("- Kitchen ID: \(order.kitchenID)")
            
            let dbOrder = DBOrder(
                order_id: order.orderID,
                user_id: order.userID,
                kitchen_id: order.kitchenID,
                status: order.status.rawValue,
                total_amount: order.totalAmount,
                delivery_address: order.deliveryAddress,
                delivery_date: formattedDate,
                delivery_type: order.deliveryType
            )
            
            // Insert order
            try await client.database
                .from("orders")
                .insert(dbOrder)
                .execute()
            
            print("✅ Order insertion completed successfully")
            
            // Update intake limits for each item
            print("\n🔄 Updating intake limits...")
            for item in order.items {
                // First try to find and update in menu_items table
                let menuItemResponse = try await client.database
                    .from("menu_items")
                    .select("intake_limit")
                    .eq("item_id", value: item.menuItemID)
                    .execute()
                
                if let json = try JSONSerialization.jsonObject(with: menuItemResponse.data, options: []) as? [[String: Any]],
                   let firstItem = json.first,
                   let currentLimit = firstItem["intake_limit"] as? Int {
                    // Update intake limit
                    let newLimit = max(0, currentLimit - item.quantity)
                    try await client.database
                        .from("menu_items")
                        .update(["intake_limit": newLimit])
                        .eq("item_id", value: item.menuItemID)
                        .execute()
                    print("✅ Updated menu item intake limit: \(item.menuItemID) -> \(newLimit)")
                } else {
                    // If not found in menu_items, try chef_specialty_dishes
                    let specialResponse = try await client.database
                        .from("chef_specialty_dishes")
                        .select("intake_limit")
                        .eq("dish_id", value: item.menuItemID)
                        .execute()
                    
                    if let json = try JSONSerialization.jsonObject(with: specialResponse.data, options: []) as? [[String: Any]],
                       let firstItem = json.first,
                       let currentLimit = firstItem["intake_limit"] as? Int {
                        // Update intake limit
                        let newLimit = max(0, currentLimit - item.quantity)
                        try await client.database
                            .from("chef_specialty_dishes")
                            .update(["intake_limit": newLimit])
                            .eq("dish_id", value: item.menuItemID)
                            .execute()
                        print("✅ Updated chef special intake limit: \(item.menuItemID) -> \(newLimit)")
                    }
                }
            }
            
            print("✅ All intake limits updated successfully")
            
        } catch {
            print("\n❌ Error inserting order:")
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

    func updateOrderStatus(orderID: String, status: OrderStatus) async throws {
        print("\n🔄 Updating order status...")
        print("📊 Update details:")
        print("- Order ID: \(orderID)")
        print("- New Status: \(status.rawValue)")
        
        do {
            try await client.database
                .from("orders")
                .update(["status": status.rawValue])
                .eq("order_id", value: orderID)
                .execute()
            
            print("✅ Successfully updated order status")
            
        } catch {
            print("\n❌ Error updating order status:")
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
    
    func createUserRecord(userID: String, name: String, email: String) async throws {
        print("\n🔄 Creating user record...")
        print("📊 User details:")
        print("- User ID: \(userID)")
        print("- Name: \(name)")
        print("- Email: \(email)")
        
        struct DBUser: Encodable {
            let user_id: String
            let name: String
            let email: String
        }
        
        do {
            let dbUser = DBUser(
                user_id: userID,
                name: name,
                email: email
            )
            
            try await client.database
                .from("users")
                .insert(dbUser)
                .execute()
            
            print("✅ Successfully created user record")
        } catch {
            print("\n❌ Error creating user record:")
            print("- Type: \(type(of: error))")
            print("- Description: \(error.localizedDescription)")
            throw error
        }
    }

    func fetchOrders(for userID: String) async throws -> [Order] {
        print("\n🔄 Fetching orders for user: \(userID)")
        
        do {
            let response = try await client.database
                .from("orders")
                .select("""
                    order_id,
                    user_id,
                    kitchen_id,
                    status,
                    total_amount,
                    delivery_address,
                    delivery_date,
                    delivery_type,
                    kitchens (
                        name
                    )
                """)
                .eq("user_id", value: userID)
                .order("delivery_date", ascending: false)
                .execute()
            
            print("📥 Raw Orders Response:")
            print(String(data: response.data, encoding: .utf8) ?? "No data")
            
            let json = try JSONSerialization.jsonObject(with: response.data, options: []) as? [[String: Any]]
            guard let ordersData = json else {
                print("❌ Failed to decode JSON data")
                throw NSError(domain: "OrderError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode orders data"])
            }
            
            print("✅ Successfully decoded JSON data")
            print("Found \(ordersData.count) orders")
            
            var orders: [Order] = []
            
            for orderJson in ordersData {
                guard let orderID = orderJson["order_id"] as? String,
                      let kitchenID = orderJson["kitchen_id"] as? String,
                      let kitchenData = orderJson["kitchens"] as? [String: Any],
                      let kitchenName = kitchenData["name"] as? String,
                      let status = orderJson["status"] as? String,
                      let totalAmount = orderJson["total_amount"] as? Double,
                      let deliveryAddress = orderJson["delivery_address"] as? String,
                      let deliveryDateString = orderJson["delivery_date"] as? String,
                      let deliveryType = orderJson["delivery_type"] as? String else {
                    print("❌ Missing required fields for order:")
                    print(orderJson)
                    continue
                }
                
                // Convert date string to Date
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                guard let deliveryDate = dateFormatter.date(from: deliveryDateString) else {
                    print("❌ Invalid date format: \(deliveryDateString)")
                    continue
                }
                
                // Fetch order items
                let itemsResponse = try await client.database
                    .from("order_items")
                    .select("""
                        menu_item_id,
                        quantity,
                        price
                    """)
                    .eq("order_id", value: orderID)
                    .execute()
                
                print("📥 Raw Order Items Response for order \(orderID):")
                print(String(data: itemsResponse.data, encoding: .utf8) ?? "No data")
                
                let itemsJson = try JSONSerialization.jsonObject(with: itemsResponse.data, options: []) as? [[String: Any]]
                var orderItems: [OrderItem] = []
                
                if let itemsData = itemsJson {
                    for itemJson in itemsData {
                        guard let menuItemID = itemJson["menu_item_id"] as? String,
                              let quantity = itemJson["quantity"] as? Int,
                              let price = itemJson["price"] as? Double else {
                            print("❌ Missing required fields for order item:")
                            print(itemJson)
                            continue
                        }
                        
                        let orderItem = OrderItem(
                            menuItemID: menuItemID,
                            quantity: quantity,
                            price: price
                        )
                        orderItems.append(orderItem)
                    }
                }
                
                let order = Order(
                    orderID: orderID,
                    userID: userID,
                    kitchenName: kitchenName,
                    kitchenID: kitchenID,
                    items: orderItems,
                    item: nil,
                    status: OrderStatus(rawValue: status) ?? .placed,
                    totalAmount: totalAmount,
                    deliveryAddress: deliveryAddress,
                    deliveryDate: deliveryDate,
                    deliveryType: deliveryType
                )
                
                orders.append(order)
            }
            
            print("✅ Successfully processed \(orders.count) orders")
            return orders
            
        } catch {
            print("\n❌ Error fetching orders:")
            print("- Type: \(type(of: error))")
            print("- Description: \(error.localizedDescription)")
            throw error
        }
    }
}

// Helper extension for async mapping
extension Array {
    func asyncMap<T>(_ transform: (Element) async throws -> T) async throws -> [T] {
        var results = [T]()
        for element in self {
            try await results.append(transform(element))
        }
        return results
    }
} 
