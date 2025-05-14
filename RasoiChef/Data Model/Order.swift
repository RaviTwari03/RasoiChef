////
////  Order.swift
////  RasoiChef
////
////  Created by Batch - 1 on 15/01/25.
////
//
//import Foundation
//
//
////struct HomeCook{
////    var name:String
////    
////}
////
////struct Meal
////{
////    var name:String
////}
////
////struct Order{
////    var orderID:UUID
////    var orderNumber:String
////    var homecook:HomeCook
////    var items:[Meal]
////    var date:Date
////}
//
//
//
////// MARK: - Complete Data Model
////
////// Main Restaurant Screen Model
//struct MainScreenModel {
//    let location: String
//    let restaurantInfo: RestaurantInfo
////    let menuSections: [MenuSection]
//    let chefsSpecialDishes: [ChefsSpecial]
//    let nearestKitchens: [Kitchen]
////    let subscriptionPlans: [SubscriptionPlan]
//}
//
//// MARK: - Restaurant Information Model
//struct RestaurantInfo {
//    let name: String
//    let distance: String
//    let cuisine: CuisineType
//    let rating: Double
//    let imageNames: [String]
//}
//
//// MARK: - Menu Section Model
//struct MenuSection {
//    let sectionName: SectionName
//    let sectionIcon: SectionIcon
//    let orderDeadline: String
//    let deliveryTime: String
//    let meals: [Meal]
//}
//
//// Enum for Section Names
//enum SectionName: String {
//    case breakfast = "Breakfast 🌅"
//    case lunch = "Lunch ☀️"
//    case dinner = "Dinner 🌕"
//    case snacks = "Snacks "
//
//}
//
//// Enum for Section Icons
//enum SectionIcon: String {
//    case breakfastIcon = "sunrise"
//    case lunchIcon = "sun"
//    case dinnerIcon = "moon"
//    case snacksIcon = "snack"
//
//}
//
//
//// MARK: - Meal Model
//struct Meal {
//    let name: String
//    let price: Double
//    let rating: Double
//    let image: String
//    let availability: MealAvailability
//    let foodType: FoodType
//    let description : String
//    let intakeLimit: Int
//
//}
//
//// MARK: - Chef's Special Dishes Model
//struct ChefsSpecial {
//    let name: String
//    let price: Double
//    let rating: Double
//    let image: String
//    let intakeLimit: Int
//    let availabilityDays: [Day]
//    let availabilityTimes: [SectionName]
//}
//
//// MARK: - Nearest Kitchen Model
////struct Kitchen {
////    let name: String
////    let image: String
////    let cuisineType: CuisineType
////    let distanceInKm: Double
////    let rating: Double
////    let availabilityStatus: AvailabilityStatus
////    let foodType: FoodType
//////    let timings: [MealTiming]
////}
//
////// MARK: - Subscription Plan Model
////struct SubscriptionPlan {
////    let name: String
////    let intakeLimit: Int
////    let availableDays: [Day]
////    let availableTimes: [TimeSlot]
////    let image: String
////}
//
//// MARK: - Header Names for Sections
//struct SectionHeaderNames {
//    let menu: String
//    let special: String
//    let subscription: String
//}
//
//// MARK: - Enums
//
//// Cuisine Types
//enum CuisineType: String {
//    case indian = "Indian"
//    case nortIndian = "North Indian"
//    case southIndian = "South Indian"
//    case bengali = "Bengali"
//    case eastIndian = "East Indian"
//    case westIndian = "West Indian"
//}
////enum NorthIndian{
////    case punjabi = "Punjabi"
////    case rajasthan = "Rajasthani"
////}
//
//// Food Type
//enum FoodType: String {
//    case vegetarian = "Vegetarian"
//    case nonVegetarian = "Non-Vegetarian"
//}
//
//// Meal Availability Status
//enum MealAvailability: String {
//    case available = "Available"
//    case notAvailable = "Not Available"
//}
//
//// Availability Days
//enum Day: String {
//    case monday = "Monday"
//    case tuesday = "Tuesday"
//    case wednesday = "Wednesday"
//    case thursday = "Thursday"
//    case friday = "Friday"
//    case saturday = "Saturday"
//    case sunday = "Sunday"
//}
//
//// Availability Times
//enum TimeSlot: String {
//    case morning = "Morning"
//    case afternoon = "Afternoon"
//    case evening = "Evening"
//    case night = "Night"
//}
//
//// Meal Timings for Kitchens
//enum MealTiming: String {
//    case morning = "Morning"
//    case afternoon = "Afternoon"
//    case evening = "Evening"
//    case night = "Night"
//}
//
//// Kitchen Availability Status
//enum AvailabilityStatus: String {
//    case online = "Online"
//    case offline = "Offline"
//}
//
//
//struct cart {
//    var addressType : AddressType
//    var deliveryAddress : Address
//    var item : [Meal]
//    var deliveryOption : DeliveryOption
//    var subTotal : Subtotal
//}
//
//enum AddressType : String {
//    case home
//    case work
//    case others
//}
//struct Address {
//    var name : String
//    var fullAddress : String
//    var pinCode : Int
//
//}
//
//enum DeliveryOption : String {
//    case selfPickup
//    case delivery
//}
//
//struct Subtotal {
//    var itemTotal : Double
//    var deliveryCharges : Double
//    var gst : Double
//    var discount : Double
//    var grandTotal : Double {
//        return itemTotal + deliveryCharges + gst - discount
//    }
//}
//
//
//// MARK: - Enums
//enum MealType: String {
//    case breakfast
//    case lunch
//    case snacks
//    case dinner
//}
//
//enum OrderStatus: String {
//    case placed = "Placed"
//    case confirmed = "Confirmed"
//    case prepared = "Prepared"
//    case outForDelivery = "Out for Delivery"
//    case delivered = "Delivered"
//}
//
//enum Cuisine: String {
//    case northIndian
//    case southIndian
//    case chinese
//    case italian
//    case mexican
//    case continental
//}
//
//// MARK: - Structs
//
//// User Profile
//struct User {
//    let userID: String
//    var name: String
//    var email: String
//    var phoneNumber: String
//    var address: String?
//    var profileImageURL: String?
//}
//
//// Kitchen Details
//struct Kitchen {
//    let kitchenID: String
//    var name: String
//    var location: String
//    var cuisines: [Cuisine]
//    var image : String?
//    var rating: Float?
//    var isOnline: Bool
//    var distance: String // Distance from the user
//}
//
//// Menu Item
//struct MenuItem {
//    let itemID: String
//    let kitchenID: String // Foreign Key to Kitchen
//    var name: String
//    var description: String
//    var price: Double
//    var rating: Float?
//    var availableMealTypes: [MealType]
//    var portionSize: String // e.g., "500 gm"
//    var intakeLimit: Int?
//    var imageURL: String?
//}
//
//// Cart Item
//struct CartItem {
//    let cartItemID: String
//    let userID: String // Foreign Key to User
//    let menuItemID: String // Foreign Key to MenuItem
//    var quantity: Int
//    var specialRequest: String?
//}
//
//Order
//struct Order: Identifiable {
//    let orderID: String
//    let userID: String // Foreign Key to User
//    let kitchenID: String // Foreign Key to Kitchen
//    let items: [OrderItem]
//    var status: OrderStatus
//    var totalAmount: Double
//    var deliveryAddress: String
//    var deliveryDate: Date
//    var deliveryType: String // "Delivery" or "Self Pickup"
//    var kitchenName: String
//    
//    // Identifiable conformance
//    var id: String { orderID }
//}
//
//// Order Item (Nested within Order)
//struct OrderItem {
//    let menuItemID: String // Foreign Key to MenuItem
//    var quantity: Int
//    var price: Double
//}

//// Subscription Plan
//struct SubscriptionPlan {
//    let planID: String
//    let userID: String // Foreign Key to User
//    let kitchenID: String // Foreign Key to Kitchen
//    var startDate: Date
//    var endDate: Date
//    var meals: [SubscriptionMeal]
//    var totalPrice: Double
//}
//
//// Subscription Meal (Nested within SubscriptionPlan)
//struct SubscriptionMeal {
//    var day: String // e.g., "Monday"
//    var mealType: MealType
//    var menuItemID: String // Foreign Key to MenuItem
//}
//
//// Feedback
//struct Feedback {
//    let feedbackID: String
//    let userID: String // Foreign Key to User
//    let kitchenID: String // Foreign Key to Kitchen
//    var rating: Float
//    var comments: String?
//}
//
//// Coupons
//struct Coupon {
//    let couponID: String
//    var code: String
//    var discountPercentage: Float
//    var expirationDate: Date
//}
//
//
//
//
//
//
//
//
