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
                    var availableDay: WeekDay = .monday // Default to Monday
                    if let dayString = menuItemJson["available_days"] as? String {
                        print("\nProcessing available day for \(name):")
                        print("Raw day from DB: \(dayString)")
                        if let day = WeekDay(rawValue: dayString.lowercased()) {
                            print("✅ Successfully parsed day: \(day)")
                            availableDay = day
                        } else {
                            print("❌ Failed to parse day: \(dayString)")
                        }
                        print("Final available day: \(availableDay.rawValue)")
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
                        availableDays: availableDay,
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
                                    availableDays: weekDay,  // Use single weekDay instead of array
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
        print("- Joining with: kitchens")
        print("- Columns: All relevant columns including kitchen name")
        
        do {
            let response = try await client.database
                .from("chef_specialty_dishes")
                .select("*, kitchens(name)")
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
                    
                    // Get kitchen name from the joined kitchens table
                    let kitchenName = (dishJson["kitchens"] as? [String: Any])?["name"] as? String ?? "Unknown Kitchen"
                    
                    // Process meal category
                    var mealCategories: [MealCategory] = []
                    if let categoryArray = dishJson["meal_categories"] as? [String] {
                        print("Debug - Meal Categories from DB:", categoryArray)
                        for categoryString in categoryArray {
                            // Convert database value to enum case
                            let category: MealCategory
                            switch categoryString.lowercased() {
                            case "veg":
                                category = .veg
                            case "non-veg", "nonveg", "non_veg":
                                category = .nonVeg
                            default:
                                print("⚠️ Unknown meal category:", categoryString)
                                continue
                            }
                            mealCategories.append(category)
                        }
                    }
                    
                    let specialtyDish = ChefSpecialtyDish(
                        kitchenName: kitchenName,
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
                    print("- Kitchen: \(specialtyDish.kitchenName)")
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
        let order_items: [OrderItemJSON]
        let Order_No: Int64
    }

    private struct OrderItemJSON: Encodable {
        let menu_item_id: String
        let quantity: Int
        let price: Double
    }

    private struct DBOrderItem: Encodable {
        let order_id: String
        let item_id: String
        let quantity: Int
        let price: Double
    }

    // Function to generate a unique order number
    private func generateOrderNumber() -> Int64 {
        // Generate a random 8-digit number
        return Int64.random(in: 10000000...99999999)
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
            
            // Generate a unique order number
            let orderNo = generateOrderNumber()
            print("\n📤 Inserting order into database...")
            print("- Order ID: \(order.orderID)")
            print("- Order Number: \(orderNo)")
            print("- User ID: \(order.userID)")
            print("- Kitchen ID: \(order.kitchenID)")
            
            // Convert order items to array of OrderItemJSON
            let orderItemsJSON = order.items.map { item -> OrderItemJSON in
                return OrderItemJSON(
                    menu_item_id: item.menuItemID,
                    quantity: item.quantity,
                    price: item.price
                )
            }
            
            // Create the order object with order_items included
            let dbOrder = DBOrder(
                order_id: order.orderID,
                user_id: order.userID,
                kitchen_id: order.kitchenID,
                status: order.status.rawValue,
                total_amount: order.totalAmount,
                delivery_address: order.deliveryAddress,
                delivery_date: formattedDate,
                delivery_type: order.deliveryType,
                order_items: orderItemsJSON,
                Order_No: orderNo
            )
            
            // Insert order with items
            let response = try await client.database
                .from("orders")
                .insert(dbOrder)
                .execute()
            
            print("✅ Order insertion completed successfully")
            print("📦 Saved order items: \(orderItemsJSON)")
            print("🔢 Order number: \(orderNo)")
            
            // Verify the order was inserted with the correct order number
            let verifyResponse = try await client.database
                .from("orders")
                .select("Order_No")
                .eq("order_id", value: order.orderID)
                .execute()
            
            if let json = try JSONSerialization.jsonObject(with: verifyResponse.data, options: []) as? [[String: Any]],
               let firstOrder = json.first,
               let storedOrderNo = firstOrder["Order_No"] as? Int64 {
                print("✅ Verified order number in database: \(storedOrderNo)")
            } else {
                print("⚠️ Could not verify order number in database")
            }
            
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
            // First verify the user exists
            let userResponse = try await client.database
                .from("users")
                .select()
                .eq("user_id", value: userID)
                .execute()
            
            let userJson = try JSONSerialization.jsonObject(with: userResponse.data, options: []) as? [[String: Any]]
            guard let users = userJson, !users.isEmpty else {
                print("❌ User not found in database")
                throw NSError(domain: "OrderError", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not found"])
            }
            
            print("✅ User verified, fetching orders...")
            
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
                    "Order_No",
                    order_items (
                        menu_item_id,
                        quantity,
                        price,
                        menu_items (
                            name,
                            description,
                            price
                        )
                    ),
                    kitchens (
                        name
                    )
                """)
                .eq("user_id", value: userID)
                .order("delivery_date", ascending: false)
                .execute()
            
            print("📥 Raw Orders Response:")
            if let jsonString = String(data: response.data, encoding: .utf8) {
                print(jsonString)
            }
            
            let json = try JSONSerialization.jsonObject(with: response.data, options: []) as? [[String: Any]]
            guard let ordersData = json else {
                print("❌ Failed to decode JSON data")
                throw NSError(domain: "OrderError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode orders data"])
            }
            
            print("✅ Successfully decoded JSON data")
            print("Found \(ordersData.count) orders")
            
            var orders: [Order] = []
            
            for orderJson in ordersData {
                print("\nProcessing order: \(orderJson["order_id"] ?? "Unknown")")
                
                guard let orderID = orderJson["order_id"] as? String,
                      let kitchenID = orderJson["kitchen_id"] as? String,
                      let kitchenData = orderJson["kitchens"] as? [String: Any],
                      let kitchenName = kitchenData["name"] as? String,
                      let status = orderJson["status"] as? String,
                      let totalAmount = orderJson["total_amount"] as? Double,
                      let deliveryAddress = orderJson["delivery_address"] as? String,
                      let deliveryDateString = orderJson["delivery_date"] as? String,
                      let deliveryType = orderJson["delivery_type"] as? String,
                      let orderItemsData = orderJson["order_items"] as? [[String: Any]] else {
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
                
                // Process order items
                var orderItems: [OrderItem] = []
                for itemJson in orderItemsData {
                    guard let menuItemID = itemJson["menu_item_id"] as? String,
                          let quantity = itemJson["quantity"] as? Int,
                          let price = itemJson["price"] as? Double,
                          let menuItemData = itemJson["menu_items"] as? [String: Any],
                          let menuItemName = menuItemData["name"] as? String else {
                        print("❌ Missing required fields for order item:")
                        print(itemJson)
                        continue
                    }
                    
                    print("✅ Processing menu item: \(menuItemName)")
                    
                    let orderItem = OrderItem(
                        menuItemID: menuItemID,
                        quantity: quantity,
                        price: price
                    )
                    orderItems.append(orderItem)
                }
                
                // Get the order number from the database
                let orderNumber: String
                if let orderNo = orderJson["Order_No"] as? Int64 {
                    orderNumber = String(format: "%08d", orderNo)
                } else {
                    // Fallback to generating from order ID if Order_No is not available
                    orderNumber = String(format: "# %08d", abs(orderID.hashValue % 100000000))
                }
                
                // Create Order object
                let order = Order(
                    orderID: orderID,
                    orderNumber: orderNumber,
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
            
            print("\n✅ Successfully processed \(orders.count) orders")
            return orders
            
        } catch {
            print("\n❌ Error fetching orders:")
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

    // MARK: - Subscription Plan Order Insertion
    struct DBSubscriptionPlanOrder: Encodable {
        let subscription_id: String? // Optional since it's auto-generated
        let user_id: String
        let kitchen_id: String
        let plan_name: String
        let start_date: String
        let end_date: String
        let total_days: Int
        let meals_per_day: [String: Bool]
        let total_amount: Double
        let status: String = "active" // Default value as per schema
        let delivery_address: String
        let delivery_type: String
        let breakfast_included: Bool
        let lunch_included: Bool
        let snacks_included: Bool
        let dinner_included: Bool
        let daily_meal_limit: Int
        let created_at: String? // Optional since it's auto-generated
        let updated_at: String? // Optional since it's auto-generated
    }

    // New struct specifically for insertion
    struct SubscriptionPlanInsert: Encodable {
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

        enum CodingKeys: String, CodingKey {
            case user_id
            case kitchen_id
            case plan_name
            case start_date
            case end_date
            case total_days
            case meals_per_day
            case total_amount
            case delivery_address
            case delivery_type
            case breakfast_included
            case lunch_included
            case snacks_included
            case dinner_included
            case daily_meal_limit
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(user_id, forKey: .user_id)
            try container.encode(kitchen_id, forKey: .kitchen_id)
            try container.encode(plan_name, forKey: .plan_name)
            try container.encode(start_date, forKey: .start_date)
            try container.encode(end_date, forKey: .end_date)
            try container.encode(total_days, forKey: .total_days)
            try container.encode(meals_per_day, forKey: .meals_per_day)
            try container.encode(total_amount, forKey: .total_amount)
            try container.encode(delivery_address, forKey: .delivery_address)
            try container.encode(delivery_type, forKey: .delivery_type)
            try container.encode(breakfast_included, forKey: .breakfast_included)
            try container.encode(lunch_included, forKey: .lunch_included)
            try container.encode(snacks_included, forKey: .snacks_included)
            try container.encode(dinner_included, forKey: .dinner_included)
            try container.encode(daily_meal_limit, forKey: .daily_meal_limit)
        }
    }

    func insertSubscriptionPlanOrder(order: DBSubscriptionPlanOrder) async throws {
        print("\n🔄 Starting subscription plan order insertion process...")
        print("📊 Subscription Plan Order details:")
        print(order)
        
        // Validate UUIDs
        guard UUID(uuidString: order.user_id) != nil else {
            let msg = "❌ user_id is not a valid UUID: \(order.user_id)"
            print(msg)
            throw NSError(domain: "SubscriptionPlan", code: -2, userInfo: [NSLocalizedDescriptionKey: msg])
        }
        
        guard UUID(uuidString: order.kitchen_id) != nil else {
            let msg = "❌ kitchen_id is not a valid UUID: \(order.kitchen_id)"
            print(msg)
            throw NSError(domain: "SubscriptionPlan", code: -3, userInfo: [NSLocalizedDescriptionKey: msg])
        }
        
        do {
            // Create an insert object with only the fields we want to insert
            let insertOrder = SubscriptionPlanInsert(
                user_id: order.user_id,
                kitchen_id: order.kitchen_id,
                plan_name: order.plan_name,
                start_date: order.start_date,
                end_date: order.end_date,
                total_days: order.total_days,
                meals_per_day: order.meals_per_day,
                total_amount: order.total_amount,
                delivery_address: order.delivery_address,
                delivery_type: order.delivery_type,
                breakfast_included: order.breakfast_included,
                lunch_included: order.lunch_included,
                snacks_included: order.snacks_included,
                dinner_included: order.dinner_included,
                daily_meal_limit: order.daily_meal_limit
            )
            
            let response = try await client.database
                .from("subscription_plans_order")
                .insert(insertOrder)
                .execute()
            
            print("✅ Subscription plan order insertion completed successfully")
            print("Supabase response: \(String(data: response.data, encoding: .utf8) ?? "No data")")
        } catch {
            print("\n❌ Error inserting subscription plan order:")
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
