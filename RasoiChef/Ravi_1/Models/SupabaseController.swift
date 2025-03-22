import Foundation
import Supabase

class SupabaseController {
    static let shared = SupabaseController()
    
    let client: SupabaseClient
    
    private init() {
        print("\n🔄 Initializing SupabaseController...")
        print("🔗 Connecting to Supabase URL: https://lplftokvbtoqqietgujl.supabase.co")
        client = SupabaseClient(
            supabaseURL: URL(string: "https://lplftokvbtoqqietgujl.supabase.co")!,
            supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxwbGZ0b2t2YnRvcXFpZXRndWpsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk4NzA2NzQsImV4cCI6MjA1NTQ0NjY3NH0.2EOleVodMu4KFH2Zn6jMyXniMckbTdKlf45beahOlHM"
        )
        print("✅ SupabaseController initialized successfully")
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
        print("- Table: kitchen")
        
        do {
            let kitchenResponse = try await client.database
                .from("kitchen")
                .select("""
                    kitchen_id,
                    name,
                    location,
                    rating,
                    is_online,
                    distance,
                    kitchen_image,
                    is_pure_veg,
                    Cuisines
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
                    guard let kitchenID = kitchenJson["kitchen_id"] as? String,
                          let name = kitchenJson["name"] as? String,
                          let location = kitchenJson["location"] as? String,
                          let rating = (kitchenJson["rating"] as? NSNumber)?.floatValue ?? kitchenJson["rating"] as? Float,
                          let isOnline = kitchenJson["is_online"] as? Bool,
                          let distance = (kitchenJson["distance"] as? NSNumber)?.doubleValue ?? kitchenJson["distance"] as? Double,
                          let kitchenImage = kitchenJson["kitchen_image"] as? String,
                          let isPureVeg = kitchenJson["is_pure_veg"] as? Bool
                    else {
                        print("\n❌ Missing required fields for kitchen")
                        continue
                    }
                    
                    // Process cuisine
                    var cuisines: [Cuisine] = []
                    if let cuisineString = kitchenJson["Cuisines"] as? String,
                       let cuisine = Cuisine(rawValue: cuisineString.lowercased()) {
                        cuisines.append(cuisine)
                    }
                    
                    let kitchen = Kitchen(
                        kitchenID: kitchenID,
                        name: name,
                        location: location,
                        cuisines: cuisines,
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
        print("- Table: menuitem")
        
        do {
            let response = try await client.database
                .from("menuitem")
                .select("""
                    item_id,
                    kitchen_id,
                    kitchen!inner (
                        name
                    ),
                    name,
                    description,
                    price,
                    rating,
                    portion_size,
                    intake_limit,
                    image_url,
                    order_deadline,
                    receiving_deadline,
                    menuitemmealtype,
                    availability,
                    available_days,
                    meal_category
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
                          let kitchenData = menuItemJson["kitchen"] as? [String: Any],
                          let kitchenName = kitchenData["name"] as? String,
                          let name = menuItemJson["name"] as? String,
                          let description = menuItemJson["description"] as? String,
                          let price = (menuItemJson["price"] as? NSNumber)?.doubleValue ?? menuItemJson["price"] as? Double,
                          let rating = (menuItemJson["rating"] as? NSNumber)?.floatValue ?? menuItemJson["rating"] as? Float,
                          let portionSize = menuItemJson["portion_size"] as? String,
                          let intakeLimit = (menuItemJson["intake_limit"] as? NSNumber)?.intValue ?? menuItemJson["intake_limit"] as? Int,
                          let imageURL = menuItemJson["image_url"] as? String,
                          let orderDeadline = menuItemJson["order_deadline"] as? String
                    else {
                        print("\n❌ Missing required fields for menu item")
                        continue
                    }
                    
                    // Process meal types
                    var mealTypes: [MealType] = []
                    if let mealTypeString = menuItemJson["menuitemmealtype"] as? String,
                       let mealType = MealType(rawValue: mealTypeString.lowercased()) {
                        mealTypes.append(mealType)
                    }
                    
                    // Process available days
                    var availableDays: [WeekDay] = []
                    if let dayString = menuItemJson["available_days"] as? String,
                       let day = WeekDay(rawValue: dayString.lowercased()) {
                        availableDays.append(day)
                    }
                    
                    // Process meal categories
                    var mealCategories: [MealCategory] = []
                    if let categoryString = menuItemJson["meal_category"] as? String,
                       let category = MealCategory(rawValue: categoryString.lowercased()) {
                        mealCategories.append(category)
                    }
                    
                    // Process availability
                    var availability: [Availabiltiy] = []
                    if let availabilityString = menuItemJson["availability"] as? String,
                       let availabilityStatus = Availabiltiy(rawValue: availabilityString) {
                        availability.append(availabilityStatus)
                    }
                    
                    let menuItem = MenuItem(
                        itemID: itemID,
                        kitchenID: kitchenID,
                        kitchenName: kitchenName,
                        distance: (menuItemJson["distance"] as? NSNumber)?.doubleValue ?? 0.0,
                        availableDate: nil,
                        name: name,
                        description: description,
                        price: price,
                        rating: rating,
                        availableMealTypes: mealTypes,
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
        print("- Table: subscriptionplan")
        
        do {
            let response = try await client.database
                .from("subscriptionplan")
                .select("""
                    plan_id,
                    kitchen_id,
                    kitchen!inner (
                        name,
                        location
                    ),
                    plan_name,
                    start_date,
                    end_date,
                    total_price,
                    intake_limit,
                    plan_image
                """)
                .execute()
            
            print("\n📥 Raw Subscription Plans Response:")
            
            // Convert Data to JSON
            let json = try JSONSerialization.jsonObject(with: response.data, options: []) as? [[String: Any]]
            guard let plansData = json else {
                print("❌ Failed to decode JSON data")
                print("Raw data size: \(response.data.count) bytes")
                throw NSError(domain: "SupabaseError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode JSON data"])
            }
            
            print("✅ Successfully decoded JSON data")
            print("Found \(plansData.count) subscription plan records")
            
            return try plansData.compactMap { planJson in
                guard let planID = planJson["plan_id"] as? String,
                      let kitchenData = planJson["kitchen"] as? [String: Any],
                      let kitchenName = kitchenData["name"] as? String,
                      let location = kitchenData["location"] as? String,
                      let kitchenID = planJson["kitchen_id"] as? String,
                      let planName = planJson["plan_name"] as? String,
                      let startDate = planJson["start_date"] as? String,
                      let endDate = planJson["end_date"] as? String,
                      let totalPrice = (planJson["total_price"] as? NSNumber)?.doubleValue ?? planJson["total_price"] as? Double,
                      let planIntakeLimit = (planJson["intake_limit"] as? NSNumber)?.intValue ?? planJson["intake_limit"] as? Int,
                      let planImage = planJson["plan_image"] as? String
                else {
                    print("\n❌ Missing required fields for subscription plan")
                    print("Available fields and types:")
                    planJson.forEach { key, value in
                        print("- \(key): \(type(of: value))")
                    }
                    return nil
                }
                
                return SubscriptionPlan(
                    planID: planID,
                    kitchenName: kitchenName,
                    userID: nil,
                    kitchenID: kitchenID,
                    location: location,
                    startDate: startDate,
                    endDate: endDate,
                    totalPrice: totalPrice,
                    planName: planName,
                    PlanIntakeLimit: planIntakeLimit,
                    planImage: planImage,
                    weeklyMeals: nil
                )
            }
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
