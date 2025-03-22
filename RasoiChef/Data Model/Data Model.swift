import UIKit

enum MealTiming: String {
    case breakfast = "breakfastIcon"
    case lunch = "lunchIcon"
    case snacks = "snacksIcon"
    case dinner = "dinnerIcon"
}


enum MealCategory: String {
    case veg = "vegIcon"
    case nonVeg = "nonVegIcon"
}


enum MealType: String {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case snacks = "Snacks"
    case dinner = "Dinner"
}
enum Availabiltiy : String {
    case Available
    case Unavailable
}
enum WeekDay: String, CaseIterable {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
}

enum OrderStatus: String {
    case placed
    case confirmed
    case prepared
    case outForDelivery
    case delivered
}

enum Cuisine: String {
    case NorthIndian
    case SouthIndian
    case Chinese
    case Italian
    case Mexican
    case Continental
}

// MARK: - Structs

// Address Struct
struct Address {
    var street: String
    var city: String
    var state: String
    var country: String
    var postalCode: String
}

// User Profile
struct User {
    let userID: String?
    var name: String?
    var email: String?
    var phoneNumber: String?
    var address: String  //Address?
    var profileImageURL: String?
}

// Kitchen Details
struct Kitchen {
    let kitchenID: String
    var name: String
    var location: String
    var cuisines: [Cuisine]
    var rating: Float
    var isOnline: Bool
    var distance: Double
    var kitchenImage: String
    var isPureVeg: Bool
}

// Menu Item
struct MenuItem {
    let itemID: String
    let kitchenID: String
    let kitchenName :String
    var distance: Double
    var availableDate: Date?
    var name: String
    var description: String
    var price: Double
    var rating: Float
    var availableMealTypes: [MealType]
    var portionSize: String
    var intakeLimit: Int
    var imageURL: String
    var orderDeadline : String
    var recievingDeadline : String?
    var availability: [Availabiltiy]
    var availableDays: [WeekDay]
    var mealCategory : [MealCategory]
}
struct GlobalMenuItem{
    let itemID: String
    let kitchenID: String
    let kitchenName : String
    var distance: Double
    var name: String
    var description: String
    var price: Double
    var rating: Float
    var availableMealTypes: [MealType]
    var portionSize: String
    var intakeLimit: Int
    var imageURL: String
    var orderDeadline : String
    var availability: [Availabiltiy]
    var mealCategory : [MealCategory]
}

// Chef Specialty Dishes
struct ChefSpecialtyDish {
    let kitchenName : String
    let dishID: String
    let kitchenID: String
    var name: String
    var description: String
    var price: Double
    var rating: Float
    var imageURL: String
    var mealCategory : [MealCategory]
    var distance: Double
    var intakeLimit : Int
}

// Cart Item
struct CartItem {
    var userAdress: String
    var quantity: Int
    var specialRequest: String?
    var menuItem: MenuItem?
    var chefSpecial : ChefSpecialtyDish?
    var subscriptionDetails : SubscriptionPlan?
}

// Order
struct Order {
    let orderID: String
    let userID: String
    let kitchenName: String
    let kitchenID: String
    let items: [OrderItem]
    var item: SubscriptionPlan?
    var status: OrderStatus
    var totalAmount: Double
    var deliveryAddress: String
    var deliveryDate: Date
    var deliveryType: String
}

// Order Item (Nested within Order)
struct OrderItem {
    let menuItemID: String
    var quantity: Int
    var price: Double
}


struct SubscriptionPlan {
    var planID: String?
    var kitchenName : String?
    var userID: String?
    var kitchenID: String?
    var location: String?
    var startDate: String?
    var endDate: String?
    var totalPrice: Double?
    var planName: String?
    var PlanIntakeLimit: Int
    var planImage: String?
    var weeklyMeals: [WeekDay: [MealType: MenuItem?]]? // Uses subscriptionMenuItems

    // Computed property to generate meals dynamically with description
    var meals: [SubscriptionMeal]? {
        return weeklyMeals?.flatMap { day, meals in
            meals.compactMap { mealType, menuItem in
                // Only add valid Subscription MenuItems to the meal list
                guard let menuItem = menuItem else { return nil }
                return SubscriptionMeal(
                    day: day.rawValue,
                    mealType: mealType,
                    menuItemID: menuItem.itemID ?? "0",
                    description: menuItem.description ,
                    planDishImage : menuItem.imageURL// ✅ Include description
                    
                )
            }
        }
    }
}



// Subscription Meal (Nested within SubscriptionPlan)
struct SubscriptionMeal {
    var day: String
    var mealType: MealType
    var menuItemID: String
    var description: String
    var planDishImage : String// ✅ Added description field
}

// Feedback
struct Feedback {
    let feedbackID: String
    let userID: String
    let kitchenID: String
    var rating: Float
    var comments: String?
}

// Coupons
struct Coupon {
    let couponID: String
    var code: String
    var discountPercentage: Float
    var expirationDate: Date
}
struct MealBanner {
    let title: String
    let subtitle: String
    let deliveryTime: String
    let timer: String
    let icon: String
    let mealType: String
}

struct SubscriptionMenuItem {
    let itemName: String
    let itemDescription: String
    let imageURL: String
    let kitchenID: String
    let availableMealTypes : [MealType]
    let availableDays : [WeekDay]
}

