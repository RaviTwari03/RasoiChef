//import Foundation
//
//struct OrderModel: Identifiable {
//    let orderID: String
//    let userID: String // Foreign Key to User
//    let kitchenID: String // Foreign Key to Kitchen
//    let items: [OrderItemModel]
//    var status: OrderStatus
//    var totalAmount: Double
//    var deliveryAddress: String
//    var deliveryDate: Date
//    var deliveryType: String // "Delivery" or "Self Pickup"
//    var kitchenName: String
//    
//    // Add Identifiable conformance
//    var id: String { orderID }
//}
//
//struct OrderItemModel {
//    let menuItemID: String // Foreign Key to MenuItem
//    var quantity: Int
//    var price: Double
//}
//
//enum OrderStatus: String {
//    case placed = "Placed"
//    case confirmed = "Confirmed"
//    case prepared = "Prepared"
//    case outForDelivery = "Out for Delivery"
//    case delivered = "Delivered"
//} 
