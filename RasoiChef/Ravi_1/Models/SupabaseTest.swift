import Foundation

class SupabaseTest {
    static func testSupabaseConnection() {
        Task {
            do {
                print("\n🔍 Starting to fetch kitchens...")
                let kitchens = try await SupabaseController.shared.fetchKitchens()
                print("✅ Successfully fetched \(kitchens.count) kitchens")
                for kitchen in kitchens {
                    print("""
                        
                        Kitchen Details:
                        - ID: \(kitchen.kitchenID)
                        - Name: \(kitchen.name)
                        - Location: \(kitchen.location)
                        - Rating: \(kitchen.rating)
                        - Online: \(kitchen.isOnline)
                        - Distance: \(kitchen.distance)
                        - Pure Veg: \(kitchen.isPureVeg)
                        - Cuisines: \(kitchen.cuisines.map { $0.rawValue }.joined(separator: ", "))
                        """)
                }
                
                print("\n🔍 Starting to fetch menu items...")
                let menuItems = try await SupabaseController.shared.fetchMenuItems()
                print("✅ Successfully fetched \(menuItems.count) menu items")
                for item in menuItems {
                    print("""
                        
                        Menu Item Details:
                        - ID: \(item.itemID)
                        - Name: \(item.name)
                        - Kitchen: \(item.kitchenName)
                        - Price: \(item.price)
                        - Rating: \(item.rating)
                        - Meal Types: \(item.availableMealTypes.map { $0.rawValue }.joined(separator: ", "))
                        - Categories: \(item.mealCategory.map { $0.rawValue }.joined(separator: ", "))
                        - Available Days: \(item.availableDays.map { $0.rawValue }.joined(separator: ", "))
                        """)
                }
            } catch {
                print("\n❌ Error Details:")
                print("- Type: \(type(of: error))")
                print("- Description: \(error.localizedDescription)")
                if let nsError = error as NSError? {
                    print("- Domain: \(nsError.domain)")
                    print("- Code: \(nsError.code)")
                    print("- User Info: \(nsError.userInfo)")
                }
            }
        }
    }
} 