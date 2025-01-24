import UIKit
enum MealType: String {
    case breakfast
    case lunch
    case snacks
    case dinner
}
enum Availabiltiy : String {
    case Available
    case Unavailable
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

// User Profile
struct User {
    let userID: String?
    var name: String?
    var email: String?
    var phoneNumber: String?
    var address: String
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
}

// Menu Item
struct MenuItem {
    let itemID: String
    let kitchenID: String
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
}

// Cart Item
struct CartItem {
    var userAdress: String
    var quantity: Int
    var specialRequest: String?
    var menuItem: MenuItem
}

// Order
struct Order {
    let orderID: String
    let userID: String
    let kitchenID: String
    let items: [OrderItem]
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

// Subscription Plan
struct SubscriptionPlan {
    let planID: String
    let userID: String
    let kitchenID: String
    var startDate: Date?
    var endDate: Date?
    var meals: [SubscriptionMeal]
    var totalPrice: Double?
    var details: String
    var mealCountPerDay: Int?
    var planImage: String?
}

// Subscription Meal (Nested within SubscriptionPlan)
struct SubscriptionMeal {
    var day: String
    var mealType: MealType
    var menuItemID: String
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
struct DateItem {
    let date: Int
    let dayOfWeek: String
    let month : String
    let isSelected: Bool
    let isDisabled: Bool
}
struct MealBanner {
    let title: String
    let subtitle: String
    let deliveryTime: String
    let timer: String
    let icon: String
}
