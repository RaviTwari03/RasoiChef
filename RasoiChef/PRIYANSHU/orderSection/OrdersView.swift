import SwiftUI
import MapKit

// Add StatusBadge view
struct StatusBadge: View {
    let status: String
    
    var body: some View {
        Text(status)
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(statusColor)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(statusColor.opacity(0.1))
            .cornerRadius(8)
    }
    
    private var statusColor: Color {
        switch status.lowercased() {
        case "active", "delivered":
            return .green
        case "pending", "confirmed", "preparing", "ready":
            return .blue
        case "out for delivery":
            return .orange
        case "cancelled":
            return .red
        case "paused":
            return .orange
        case "completed":
            return .gray
        default:
            return .gray
        }
    }
}

// Add Subscription and SubscriptionStatus models
struct Subscription: Identifiable {
    let id: String
    let orderID: String
    let userID: String
    let kitchenID: String
    let kitchenName: String
    let planName: String
    let startDate: Date
    let endDate: Date
    let status: SubscriptionStatus
    let deliveryDays: [Int] // 1-7 representing days of week
    let deliveryTime: String
    let totalAmount: Double
    let items: [OrderItem]
    let deliveryAddress: String
}

enum SubscriptionStatus: String {
    case active = "Active"
    case paused = "Paused"
    case cancelled = "Cancelled"
    case completed = "Completed"
}

// Extension to make Order conform to Identifiable and Equatable
extension Order: Identifiable, Equatable {
    var id: String { orderID }
    static func == (lhs: Order, rhs: Order) -> Bool {
        lhs.orderID == rhs.orderID &&
        lhs.userID == rhs.userID &&
        lhs.kitchenID == rhs.kitchenID &&
        lhs.status == rhs.status &&
        lhs.totalAmount == rhs.totalAmount &&
        lhs.deliveryAddress == rhs.deliveryAddress &&
        lhs.deliveryDate == rhs.deliveryDate &&
        lhs.deliveryType == rhs.deliveryType &&
        lhs.kitchenName == rhs.kitchenName &&
        lhs.items == rhs.items
    }
}

// Also make OrderItem Equatable if not already
extension OrderItem: Equatable {
    public static func == (lhs: OrderItem, rhs: OrderItem) -> Bool {
        lhs.menuItemID == rhs.menuItemID && lhs.quantity == rhs.quantity && lhs.price == rhs.price
    }
}

struct CurrentOrdersSection: View {
    let orders: [Order]
    let menuItems: [MenuItem]
    let onInfo: (Order) -> Void
    let onTrack: (Order) -> Void

    var body: some View {
        if !orders.isEmpty {
            VStack(alignment: .leading, spacing: 16) {
                Text("Current Orders")
                    .font(.title2).bold()
                    .padding(.horizontal)
                    .padding(.top, 8)
                ForEach(orders) { order in
                    VStack(spacing: 0) {
                        OrderCard(order: order, isCurrent: true, menuItems: menuItems, onInfo: onInfo, onTrack: onTrack)
                        Divider().padding(.horizontal, 8)
                    }
                }
            }
        }
    }
}

struct PastOrdersSection: View {
    let orders: [Order]
    let menuItems: [MenuItem]
    let onInfo: (Order) -> Void

    var body: some View {
        if !orders.isEmpty {
            VStack(alignment: .leading, spacing: 16) {
                Text("Past Orders")
                    .font(.title2).bold()
                    .padding(.horizontal)
                    .padding(.top, 8)
                ForEach(orders) { order in
                    VStack(spacing: 0) {
                        OrderCard(order: order, isCurrent: false, menuItems: menuItems, onInfo: onInfo, onTrack: { _ in })
                        Divider().padding(.horizontal, 8)
                    }
                }
            }
        }
    }
}

struct SubscriptionCard: View {
    let subscription: Subscription
    @StateObject private var viewModel = OrdersViewModel()
    @State private var showingActionSheet = false
    @State private var showingConfirmation = false
    @State private var actionToConfirm: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                VStack(alignment: .leading) {
                    Text(subscription.planName)
                        .font(.headline)
                    Text(subscription.kitchenName)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                StatusBadge(status: subscription.status.rawValue)
            }
            
            // Delivery Info
            VStack(alignment: .leading, spacing: 8) {
                Label(subscription.deliveryAddress, systemImage: "location.fill")
                    .font(.subheadline)
                
                // Delivery Schedule
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.gray)
                    Text("Delivery Schedule:")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                }
                
                // Days of week
                HStack(spacing: 4) {
                    ForEach(1...7, id: \.self) { day in
                        Text(dayToShortName(day))
                            .font(.caption)
                            .padding(4)
                            .background(subscription.deliveryDays.contains(day) ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
                            .foregroundColor(subscription.deliveryDays.contains(day) ? .blue : .gray)
                            .cornerRadius(4)
                    }
                }
                
                // Delivery Time
                Label(subscription.deliveryTime, systemImage: "clock")
                    .font(.subheadline)
            }
            
            // Subscription Period
            HStack {
                Label("Start: \(subscription.startDate.formatted(date: .abbreviated, time: .omitted))", systemImage: "calendar")
                Spacer()
                Label("End: \(subscription.endDate.formatted(date: .abbreviated, time: .omitted))", systemImage: "calendar")
            }
            .font(.caption)
            .foregroundColor(.gray)
            
            // Action Buttons
            HStack {
                Button(action: {
                    // View details action
                }) {
                    Text("View Details")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                if subscription.status == .active {
                    Button(action: {
                        showingActionSheet = true
                    }) {
                        Text("Manage")
                            .font(.subheadline)
                            .foregroundColor(.orange)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
        .actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(
                title: Text("Manage Subscription"),
                message: Text("Choose an action for your subscription"),
                buttons: [
                    .default(Text("Pause Subscription")) {
                        actionToConfirm = {
                            Task {
                                await viewModel.pauseSubscription(subscription)
                            }
                        }
                        showingConfirmation = true
                    },
                    .destructive(Text("Cancel Subscription")) {
                        actionToConfirm = {
                            Task {
                                await viewModel.cancelSubscription(subscription)
                            }
                        }
                        showingConfirmation = true
                    },
                    .cancel()
                ]
            )
        }
        .alert(isPresented: $showingConfirmation) {
            Alert(
                title: Text("Confirm Action"),
                message: Text("Are you sure you want to proceed with this action?"),
                primaryButton: .destructive(Text("Confirm")) {
                    actionToConfirm?()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private func dayToShortName(_ day: Int) -> String {
        let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        return days[day - 1]
    }
}

struct OrdersView: View {
    @StateObject private var viewModel = OrdersViewModel()
    @State private var showingFullScreenPaymentAlert = false
    @State private var selectedOrder: Order?
    @State private var showingTrackOrder = false
    @Namespace private var animation
    @State private var selectedSegment = 0

    var body: some View {
        ZStack {
            if showingFullScreenPaymentAlert, let order = selectedOrder {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .zIndex(10)
                VStack(spacing: 0) {
                    ZStack(alignment: .topTrailing) {
                        VStack(spacing: 16) {
                            Text("Payment Details")
                                .font(.title2).bold()
                                .padding(.top, 8)
                            paymentDetailRow(label: "Subtotal", value: String(format: "₹%.2f", order.totalAmount))
                            paymentDetailRow(label: "GST (18%)", value: String(format: "₹%.2f", order.totalAmount * 0.18))
                            paymentDetailRow(label: "Discount", value: String(format: "-₹%.2f", 20.00), valueColor: .green)
                            Divider().padding(.vertical, 4)
                            paymentDetailRow(label: "Grand Total", value: String(format: "₹%.2f", order.totalAmount + (order.totalAmount * 0.18) - 20.00), valueColor: .blue)
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 20)
                        Button(action: { withAnimation { showingFullScreenPaymentAlert = false } }) {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .frame(width: 28, height: 28)
                                .foregroundColor(.gray)
                                .background(Color.white.opacity(0.001))
                        }
                        .padding(12)
                    }
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 20)
                }
                .frame(maxWidth: 340)
                .zIndex(11)
            }
            NavigationView {
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [Color(.systemGroupedBackground), Color(.systemGray6)]), startPoint: .top, endPoint: .bottom)
                        .ignoresSafeArea()
                    VStack(spacing: 0) {
                        // Add My Orders heading
                        Text("My Orders")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .padding(.top, 16)
                            .padding(.bottom, 8)
                        
                        Picker("View", selection: $selectedSegment) {
                            Text("Orders").tag(0)
                            Text("Subscriptions").tag(1)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)
                        .padding(.top, 8)
                        .padding(.bottom, 4)
                        
                        ScrollView {
                            VStack(alignment: .leading, spacing: 36) {
                                if selectedSegment == 0 {
                                    if !viewModel.currentOrders.isEmpty {
                                        SectionHeader(title: "Current Orders", color: .blue)
                                        ForEach(viewModel.currentOrders) { order in
                                            OrderCard(order: order, isCurrent: true, menuItems: viewModel.menuItems, onInfo: { order in
                                                selectedOrder = order
                                                withAnimation { showingFullScreenPaymentAlert = true }
                                            }, onTrack: { order in
                                                selectedOrder = order
                                            })
                                            .matchedGeometryEffect(id: order.orderID, in: animation)
                                            .transition(.move(edge: .bottom).combined(with: .opacity))
                                            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: viewModel.currentOrders)
                                        }
                                    }
                                    if !viewModel.pastOrders.isEmpty {
                                        SectionHeader(title: "Past Orders", color: .green)
                                        ForEach(viewModel.pastOrders) { order in
                                            OrderCard(order: order, isCurrent: false, menuItems: viewModel.menuItems, onInfo: { order in
                                                selectedOrder = order
                                                withAnimation { showingFullScreenPaymentAlert = true }
                                            }, onTrack: { _ in })
                                            .matchedGeometryEffect(id: order.orderID, in: animation)
                                            .transition(.move(edge: .bottom).combined(with: .opacity))
                                            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: viewModel.pastOrders)
                                        }
                                    }
                                    if viewModel.currentOrders.isEmpty && viewModel.pastOrders.isEmpty && !viewModel.isLoading {
                                        VStack(spacing: 16) {
                                            Image(systemName: "cart.badge.plus")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 80, height: 80)
                                                .foregroundColor(.blue.opacity(0.7))
                                            Text("No orders yet!")
                                                .font(.title2).bold()
                                                .foregroundColor(.primary)
                                            Text("Start exploring delicious meals and place your first order.")
                                                .font(.body)
                                                .foregroundColor(.secondary)
                                                .multilineTextAlignment(.center)
                                            Button(action: {
                                                // Add navigation to explore menu if needed
                                            }) {
                                                Text("Explore Menu")
                                                    .font(.headline)
                                                    .foregroundColor(.white)
                                                    .padding(.horizontal, 32)
                                                    .padding(.vertical, 12)
                                                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                                                    .cornerRadius(20)
                                            }
                                            .padding(.top, 8)
                                        }
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .padding(.top, 40)
                                    }
                                } else {
                                    // Subscription view
                                    if !viewModel.activeSubscriptions.isEmpty {
                                        SectionHeader(title: "Active Subscriptions", color: .blue)
                                        ForEach(viewModel.activeSubscriptions) { subscription in
                                            SubscriptionCard(subscription: subscription)
                                        }
                                    }
                                    
                                    if !viewModel.otherSubscriptions.isEmpty {
                                        SectionHeader(title: "Other Subscriptions", color: .green)
                                        ForEach(viewModel.otherSubscriptions) { subscription in
                                            SubscriptionCard(subscription: subscription)
                                        }
                                    }
                                    
                                    if viewModel.subscriptions.isEmpty && !viewModel.isLoading {
                                        VStack(spacing: 16) {
                                            Image(systemName: "calendar.badge.clock")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 80, height: 80)
                                                .foregroundColor(.blue.opacity(0.7))
                                            Text("No Active Subscriptions")
                                                .font(.title2).bold()
                                                .foregroundColor(.primary)
                                            Text("Subscribe to your favorite meals and get them delivered regularly.")
                                                .font(.body)
                                                .foregroundColor(.secondary)
                                                .multilineTextAlignment(.center)
                                            Button(action: {
                                                // Add navigation to subscription plans if needed
                                            }) {
                                                Text("View Plans")
                                                    .font(.headline)
                                                    .foregroundColor(.white)
                                                    .padding(.horizontal, 32)
                                                    .padding(.vertical, 12)
                                                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                                                    .cornerRadius(20)
                                            }
                                            .padding(.top, 8)
                                        }
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .padding(.top, 40)
                                    }
                                }
                            }
                            .padding(.vertical, 24)
                        }
                    }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationBarHidden(true)
            .onAppear {
                viewModel.loadData()
            }
            .sheet(isPresented: $showingTrackOrder) {
                if let order = selectedOrder {
                    TrackOrderView(order: order)
                }
            }
        }
    }

    // Helper for bold payment detail rows
    @ViewBuilder
    private func paymentDetailRow(label: String, value: String, valueColor: Color = .primary) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.primary)
            Spacer()
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(valueColor)
        }
    }
}

struct SectionHeader: View {
    let title: String
    let color: Color
    var body: some View {
        HStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 4)
                .fill(color)
                .frame(width: 6, height: 24)
            Text(title)
                .font(.title3).bold()
                .foregroundColor(color)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.bottom, 2)
    }
}

struct OrderItemsList: View {
    let orderID: String
    let menuItems: [MenuItem]
    let showPrices: Bool
    let showDividers: Bool
    @StateObject private var viewModel: OrderItemsListViewModel

    init(orderID: String, menuItems: [MenuItem], showPrices: Bool = false, showDividers: Bool = true) {
        self.orderID = orderID
        self.menuItems = menuItems
        self.showPrices = showPrices
        self.showDividers = showDividers
        self._viewModel = StateObject(wrappedValue: OrderItemsListViewModel(orderID: orderID))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if viewModel.isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                    Spacer()
                }
                .padding(.vertical, 8)
            } else if viewModel.itemDetails.isEmpty {
                Text("No items found")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            } else {
                ForEach(Array(viewModel.itemDetails.enumerated()), id: \.offset) { index, detail in
                    VStack(spacing: 8) {
                        if showPrices {
                            // Detailed view with prices
                            HStack(alignment: .center) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(detail.name)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.primary)
                                    Text("Quantity: \(detail.quantity)")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Text("₹\(String(format: "%.2f", detail.price))")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.primary)
                            }
                        } else {
                            // Simple view without prices
                            HStack {
                                Text(detail.name)
                                    .font(.system(size: 16))
                                    .foregroundColor(.primary)
                                Spacer()
                                Text("x\(detail.quantity)")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.gray)
                            }
                        }
                        if showDividers && index < viewModel.itemDetails.count - 1 {
                            Divider()
                        }
                    }
                }
            }
        }
    }
}

class OrderItemsListViewModel: ObservableObject {
    @Published var itemDetails: [(name: String, quantity: Int, price: Double)] = []
    @Published var isLoading = true
    private let orderID: String

    init(orderID: String) {
        self.orderID = orderID
        fetchOrderItems()
    }

    private func fetchOrderItems() {
        Task {
            do {
                print("🔄 Starting to fetch order items for orderID: \(orderID)")
                // First fetch the order items
                let response = try await SupabaseController.shared.client.database
                    .from("orders")
                    .select("order_items")
                    .eq("order_id", value: orderID)
                    .single()
                    .execute()

                print("📦 Raw response data: \(String(data: response.data, encoding: .utf8) ?? "No data")")

                guard let json = try? JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any] else {
                    print("❌ Failed to parse JSON response")
                    await MainActor.run {
                        self.isLoading = false
                    }
                    return
                }

                guard let orderItemsData = json["order_items"] as? [[String: Any]] else {
                    print("❌ Failed to parse order_items array. JSON structure: \(json)")
                    await MainActor.run {
                        self.isLoading = false
                    }
                    return
                }

                print("📝 Found \(orderItemsData.count) order items to process")
                
                var details: [(String, Int, Double)] = []
                
                // Process each order item
                for (index, item) in orderItemsData.enumerated() {
                    print("🔄 Processing item \(index + 1) of \(orderItemsData.count): \(item)")
                    
                    guard let menuItemID = item["menu_item_id"] as? String,
                          let quantity = item["quantity"] as? Int,
                          let price = item["price"] as? Double else {
                        print("⚠️ Missing required fields in order item: \(item)")
                        continue
                    }

                    print("🍽️ Looking up menu item with ID: \(menuItemID)")

                    // Try to fetch the item name from menu_items
                    do {
                        let menuItemResponse = try await SupabaseController.shared.client.database
                            .from("menu_items")
                            .select("name")
                            .eq("item_id", value: menuItemID)
                            .single()
                            .execute()

                        if let menuJson = try? JSONSerialization.jsonObject(with: menuItemResponse.data, options: []) as? [String: Any],
                           let name = menuJson["name"] as? String {
                            print("✅ Found menu item: \(name) with quantity: \(quantity) and price: ₹\(price)")
                            details.append((name, quantity, price))
                            continue
                        }
                    } catch {
                        print("❌ Error fetching menu item: \(error.localizedDescription)")
                    }

                    // If not found in menu_items, try chef_specialty_dishes
                    do {
                        let specialtyResponse = try await SupabaseController.shared.client.database
                            .from("chef_specialty_dishes")
                            .select("name")
                            .eq("dish_id", value: menuItemID)
                            .single()
                            .execute()

                        if let specialtyJson = try? JSONSerialization.jsonObject(with: specialtyResponse.data, options: []) as? [String: Any],
                           let name = specialtyJson["name"] as? String {
                            print("✅ Found specialty item: \(name) with quantity: \(quantity) and price: ₹\(price)")
                            details.append((name, quantity, price))
                            continue
                        }
                    } catch {
                        print("❌ Error fetching specialty item: \(error.localizedDescription)")
                    }

                    print("⚠️ Item not found in either table, using generic name")
                    details.append(("Item #\(menuItemID)", quantity, price))
                }

                print("✅ Finished processing items. Found \(details.count) items")

                await MainActor.run {
                    self.itemDetails = details
                    self.isLoading = false
                    print("📱 Updated UI with \(self.itemDetails.count) items")
                }
            } catch {
                print("❌ Error fetching order items: \(error.localizedDescription)")
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
    }
}

struct OrderItemRow: View {
    let item: OrderItem
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Item image (placeholder)
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 48, height: 48)
                .cornerRadius(8)
                .overlay(
                    Image(systemName: "photo")
                        .foregroundColor(.gray)
                )
            VStack(alignment: .leading, spacing: 2) {
                Text(item.menuItemID) // Replace with actual name if available
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text("Quantity: \(item.quantity)")
                    .font(.caption)
                    .foregroundColor(.gray)
                // Uncomment if you have a note property
                // if let note = item.note, !note.isEmpty {
                //     Text("Note: \(note)")
                //         .font(.caption2)
                //         .foregroundColor(.gray)
                // }
            }
            Spacer()
            Text("₹\(String(format: "%.2f", item.price))")
                .font(.subheadline)
        }
    }
}

struct OrderDetailView: View {
    let order: Order
    let menuItems: [MenuItem]
    @Environment(\.presentationMode) var presentationMode
    @State private var showingPaymentDetails = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom Navigation Bar
            HStack {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                Spacer()
                Text("Order Details")
                    .font(.headline)
                Spacer()
                Button(action: { /* Share action */ }) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
            }
            .padding(.horizontal)
            .padding(.top, 12)
            .padding(.bottom, 8)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Order Status
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.system(size: 32))
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Order Confirmed")
                                .font(.headline)
                            Text("Order #\(order.orderNumber)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text("Today, 12:30 PM - 1:00 PM")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Order Items Section with prices
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Order Items")
                            .font(.headline)
                            .padding(.bottom, 4)
                        
                        OrderItemsList(orderID: order.orderID, menuItems: menuItems, showPrices: true, showDividers: false)
                            .padding(.vertical, 8)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).stroke(Color.blue.opacity(0.2)))
                    .padding(.horizontal)
                    
                    // Kitchen Info
                    HStack(spacing: 12) {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 40, height: 40)
                            .overlay(Image(systemName: "person.fill").foregroundColor(.gray))
                        VStack(alignment: .leading, spacing: 2) {
                            Text(order.kitchenName)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill").foregroundColor(.yellow).font(.caption)
                                Text("4.8")
                                    .font(.caption)
                                Image(systemName: "checkmark.seal.fill").foregroundColor(.blue).font(.caption)
                            }
                        }
                        Spacer()
                        Button(action: { /* Message action */ }) {
                            Text("Message")
                                .font(.subheadline)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 6)
                                .background(RoundedRectangle(cornerRadius: 16).stroke(Color.blue))
                        }
                    }
                    .padding(.horizontal)
                    
                    // Delivery Details
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Delivery Details")
                            .font(.headline)
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "mappin.and.ellipse").foregroundColor(.gray)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(order.deliveryAddress)
                                    .font(.subheadline)
                                Text("New York, NY 10001")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.08))
                            .frame(height: 36)
                            .overlay(
                                Text("Delivery Instructions: Please leave at the door")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            )
                    }
                    .padding(.horizontal)
                    
                    // Payment Summary
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Payment Summary")
                            .font(.headline)
                        HStack {
                            Text("Subtotal")
                            Spacer()
                            Text("₹\(String(format: "%.2f", order.totalAmount))")
                        }
                        HStack {
                            Text("Delivery Fee")
                            Spacer()
                            Text("₹4.99")
                        }
                        HStack {
                            Text("Service Fee")
                            Spacer()
                            Text("₹2.99")
                        }
                        HStack {
                            Text("Taxes")
                            Spacer()
                            Text("₹\(String(format: "%.2f", order.totalAmount * 0.18))")
                        }
                        Divider()
                        HStack {
                            Text("Total").fontWeight(.bold)
                            Spacer()
                            Text("₹\(String(format: "%.2f", order.totalAmount + 4.99 + 2.99 + (order.totalAmount * 0.18)))").fontWeight(.bold)
                        }
                        HStack(spacing: 8) {
                            Image(systemName: "creditcard")
                                .foregroundColor(.gray)
                            Text("•••• 4582")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Action Buttons
                    VStack(spacing: 8) {
                        NavigationLink(destination: TrackOrderView(order: order)) {
                            Text("Track Order")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(12)
                        }
                        Button(action: { /* Cancel order */ }) {
                            Text("Cancel Order")
                                .font(.headline)
                                .foregroundColor(.blue)
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                    }
                    .padding(.horizontal)
                    
                    // Order Meta Info
                    HStack {
                        Text("Ordered at 11:45 AM")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Spacer()
                        Text("Order ID: \(order.orderID)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                    Button(action: { /* Get help */ }) {
                        HStack(spacing: 4) {
                            Image(systemName: "questionmark.circle")
                                .foregroundColor(.blue)
                            Text("Get Help")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 24)
                }
                .padding(.top, 8)
            }
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationBarHidden(true)
    }
}

// Update OrderCard to use simple view
struct OrderCard: View {
    let order: Order
    let isCurrent: Bool
    let menuItems: [MenuItem]
    let onInfo: (Order) -> Void
    let onTrack: (Order) -> Void
    
    var body: some View {
        NavigationLink(destination: 
            OrderDetailView(order: order, menuItems: menuItems)
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
        ) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("#"+order.orderNumber)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.primary)
                        HStack(spacing: 6) {
                            Image(systemName: "fork.knife")
                                .foregroundColor(.gray)
                            Text(order.kitchenName)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.primary)
                        }
                        if !order.deliveryAddress.isEmpty {
                            HStack(spacing: 6) {
                                Image(systemName: "mappin.and.ellipse")
                                    .foregroundColor(.gray)
                                Text(order.deliveryAddress)
                                    .font(.system(size: 15))
                                    .foregroundColor(.gray)
                                    .frame(width:160, alignment: .leading)
                                    .lineLimit(2)
                            }
                        }
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 6) {
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .foregroundColor(.gray)
                            Text(order.deliveryDate, style: .date)
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                        }
                    }
                }

                Divider()
                    .padding(.vertical, 2)

                OrderItemsList(orderID: order.orderID, menuItems: menuItems, showPrices: false, showDividers: false)
                    .padding(.vertical, 2)

                Divider()
                    .padding(.vertical, 2)

                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Button(action: { onInfo(order) }) {
                            Text("Payment Details")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color.blue)
                        }
                        .buttonStyle(PlainButtonStyle())
                        Button(action: { onInfo(order) }) {
                            Image(systemName: "info.circle")
                                .font(.system(size: 20, weight: .regular))
                                .foregroundColor(Color.blue)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    Spacer()
                    if isCurrent {
                        NavigationLink(destination: 
                            TrackOrderView(order: order)
                                .navigationBarHidden(true)
                                .navigationBarBackButtonHidden(true)
                        ) {
                            Text("Track Order")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 18)
                                .padding(.vertical, 8)
                                .background(Color.blue.opacity(0.7))
                                .cornerRadius(12)
                        }
                        .buttonStyle(PlainButtonStyle())
                    } else {
                        Text("Delivered")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 8)
                            .background(Color.green)
                            .cornerRadius(12)
                    }
                }
                .padding(.top, 4)
            }
            .padding(.all, 20)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.white)
                    .shadow(color: Color(.black).opacity(0.06), radius: 8, x: 0, y: 2)
            )
            .padding(.horizontal, 16)
            .padding(.vertical, 0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct TrackOrderView: View {
    let order: Order
    @StateObject private var viewModel = TrackOrderViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 28.6139, longitude: 77.2090),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        VStack(spacing: 0) {
            // Custom Header with Back Button
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                Spacer()
                Text("Track Order")
                    .font(.title2)
                    .bold()
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)
            
            // Map or delivery icon
            Map(coordinateRegion: $region)
                .frame(height: 180)
                .cornerRadius(20)
                .padding(.horizontal)
                .padding(.top, 12)

            // Order number and address
            VStack(spacing: 4) {
                Text("Order No: \(order.orderNumber)")
                    .font(.headline)
                    .foregroundColor(.secondary)
                HStack(alignment: .top, spacing: 6) {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(.gray)
                    Text(order.deliveryAddress)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
            }
            .padding(.top, 8)
            .padding(.bottom, 4)

            // Status and ETA
            VStack(spacing: 8) {
                Text(viewModel.currentStatus)
                    .font(.title2).bold()
                    .padding(.top, 8)
                Text("Estimated delivery: \(viewModel.eta)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.bottom, 8)

            // Progress bar
            ProgressView(value: viewModel.progress)
                .progressViewStyle(LinearProgressViewStyle(tint: .green))
                .padding(.horizontal, 32)
                .padding(.bottom, 12)

            // Timeline
            ScrollView {
                VStack(spacing: 18) {
                    ForEach(viewModel.statusData.indices, id: \.self) { idx in
                        let (status, description, time, isCompleted) = viewModel.statusData[idx]
                        HStack(alignment: .top, spacing: 16) {
                            VStack {
                                Image(systemName: viewModel.icon(for: status))
                                    .foregroundColor(isCompleted ? .green : .gray)
                                    .font(.system(size: 22, weight: .bold))
                                if idx < viewModel.statusData.count - 1 {
                                    Rectangle()
                                        .fill(isCompleted ? Color.green : Color.gray.opacity(0.3))
                                        .frame(width: 3, height: 36)
                                }
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text(status)
                                    .font(.headline)
                                    .foregroundColor(isCompleted ? .green : .primary)
                                if !description.isEmpty {
                                    Text(description)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                if !time.isEmpty {
                                    Text(time)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
            }
            Spacer()
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.initializeTracking(for: order)
        }
    }
}

// Extend your TrackOrderViewModel for icons and ETA
extension TrackOrderViewModel {
    var currentStatus: String {
        statusData.last(where: { $0.3 })?.0 ?? "Order Placed"
    }
    var eta: String {
        // Dummy ETA logic, replace with real calculation if available
        if let delivered = statusData.last, delivered.3 { return "Delivered" }
        return "20-30 min"
    }
    func icon(for status: String) -> String {
        switch status {
        case "Order Placed": return "cart.fill"
        case "Order Confirmed": return "checkmark.seal.fill"
        case "Order Prepared": return "takeoutbag.and.cup.and.straw.fill"
        case "Out for Delivery": return "bicycle"
        case "Delivered": return "house.fill"
        default: return "circle.fill"
        }
    }
}

enum OrderType {
    case current
    case past
}

class OrdersViewModel: ObservableObject {
    @Published var orders: [Order] = []
    @Published var subscriptions: [Subscription] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var menuItems: [MenuItem] = []
    
    var currentOrders: [Order] {
        orders.filter { order in
            switch order.status {
            case .placed, .confirmed, .prepared, .outForDelivery:
                return true
            default:
                return false
            }
        }
    }
    
    var pastOrders: [Order] {
        orders.filter { order in
            switch order.status {
            case .delivered:
                return true
            default:
                return false
            }
        }
    }
    
    var activeSubscriptions: [Subscription] {
        subscriptions.filter { $0.status == .active }
    }
    
    var otherSubscriptions: [Subscription] {
        subscriptions.filter { $0.status != .active }
    }
    
    init() {
        setupNotificationObserver()
        loadData()
    }
    
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleOrderUpdate), name: NSNotification.Name("OrderUpdated"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSubscriptionUpdate), name: NSNotification.Name("SubscriptionUpdated"), object: nil)
    }
    
    @objc private func handleOrderUpdate(_ notification: Notification) {
        if let order = notification.object as? Order {
            if let index = orders.firstIndex(where: { $0.orderID == order.orderID }) {
                orders[index] = order
            } else {
                orders.append(order)
            }
        }
    }
    
    @objc private func handleSubscriptionUpdate(_ notification: Notification) {
        if let subscription = notification.object as? Subscription {
            if let index = subscriptions.firstIndex(where: { $0.id == subscription.id }) {
                subscriptions[index] = subscription
            } else {
                subscriptions.append(subscription)
            }
        }
    }
    
    func loadData() {
        print("🔄 Starting to load data...")
        isLoading = true
        error = nil
        
        // Create a dispatch group to handle multiple async operations
        let group = DispatchGroup()
        
        // Fetch orders
        group.enter()
        Task {
            do {
                print("📥 Fetching orders...")
                guard let session = try await SupabaseController.shared.getCurrentSession() else {
                    print("❌ No authenticated user found")
                    await MainActor.run {
                        self.isLoading = false
                        self.orders = []
                        self.subscriptions = []
                    }
                    return
                }
                let userID = session.user.id.uuidString
                print("👤 Fetching orders for user: \(userID)")
                
                let fetchedOrders = try await SupabaseController.shared.fetchOrders(for: userID)
                print("✅ Successfully fetched \(fetchedOrders.count) orders")
                
                await MainActor.run {
                    self.orders = fetchedOrders
                    print("📊 Current orders count: \(self.currentOrders.count)")
                    print("📊 Past orders count: \(self.pastOrders.count)")
                }
            } catch {
                print("❌ Error fetching orders: \(error.localizedDescription)")
                await MainActor.run {
                    self.error = error
                }
            }
            group.leave()
        }
        
        // Fetch subscriptions
        group.enter()
        Task {
            do {
                print("📥 Fetching subscriptions...")
                guard let session = try await SupabaseController.shared.getCurrentSession() else {
                    print("❌ No authenticated user found for subscriptions")
                    return
                }
                let userID = session.user.id.uuidString
                print("👤 Fetching subscriptions for user: \(userID)")
                
                let fetchedSubscriptions = try await SupabaseController.shared.fetchSubscriptions(for: userID)
                print("✅ Successfully fetched \(fetchedSubscriptions.count) subscriptions")
                
                await MainActor.run {
                    self.subscriptions = fetchedSubscriptions
                    print("📊 Active subscriptions count: \(self.activeSubscriptions.count)")
                    print("📊 Other subscriptions count: \(self.otherSubscriptions.count)")
                }
            } catch {
                print("❌ Error fetching subscriptions: \(error.localizedDescription)")
                await MainActor.run {
                    self.error = error
                }
            }
            group.leave()
        }
        
        // Fetch menu items
        group.enter()
        Task {
            do {
                print("📥 Fetching menu items...")
                let items = try await SupabaseController.shared.fetchMenuItems()
                print("✅ Successfully fetched \(items.count) menu items")
                
                await MainActor.run {
                    self.menuItems = items
                }
            } catch {
                print("❌ Error fetching menu items: \(error.localizedDescription)")
                await MainActor.run {
                    self.error = error
                }
            }
            group.leave()
        }
        
        // When all operations are complete
        group.notify(queue: .main) {
            print("✅ All data loading completed")
            print("📊 Final orders count: \(self.orders.count)")
            print("📊 Final current orders count: \(self.currentOrders.count)")
            print("📊 Final past orders count: \(self.pastOrders.count)")
            print("📊 Final active subscriptions count: \(self.activeSubscriptions.count)")
            print("📊 Final other subscriptions count: \(self.otherSubscriptions.count)")
            self.isLoading = false
        }
    }
    
    func loadMenuItems(for order: Order) async {
        // Implementation for loading menu items
    }
    
    // Add function to handle subscription actions
    func pauseSubscription(_ subscription: Subscription) async {
        do {
            try await SupabaseController.shared.updateSubscriptionStatus(subscription.id, status: SubscriptionStatus.paused)
            // Refresh subscriptions after update
            await loadData()
        } catch {
            print("❌ Error pausing subscription: \(error.localizedDescription)")
        }
    }
    
    func cancelSubscription(_ subscription: Subscription) async {
        do {
            try await SupabaseController.shared.updateSubscriptionStatus(subscription.id, status: SubscriptionStatus.cancelled)
            // Refresh subscriptions after update
            await loadData()
        } catch {
            print("❌ Error cancelling subscription: \(error.localizedDescription)")
        }
    }
}

class TrackOrderViewModel: ObservableObject {
    @Published var statusData: [(String, String, String, Bool)] = [
        ("Order Placed", "You have successfully placed your order.", "", true),
        ("Order Confirmed", "", "", false),
        ("Order Prepared", "", "", false),
        ("Out for Delivery", "", "", false),
        ("Delivered", "", "", false)
    ]
    @Published var progress: Double = 0.0

    private var timer: Timer?
    private var startTime: Date?

    func initializeTracking(for order: Order) {
        // Always reset statusData to initial state for a new order
        statusData = [
            ("Order Placed", "You have successfully placed your order.", "", true),
            ("Order Confirmed", "", "", false),
            ("Order Prepared", "", "", false),
            ("Out for Delivery", "", "", false),
            ("Delivered", "", "", false)
        ]
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"

        if let storedStartTime = UserDefaults.standard.object(forKey: "orderStartTime_\(order.orderID)") as? Date {
            startTime = storedStartTime
        } else {
            startTime = Date()
            UserDefaults.standard.set(startTime, forKey: "orderStartTime_\(order.orderID)")
        }

        statusData[0].2 = formatter.string(from: startTime!)

        let orderKey = "orderTimes_\(order.orderID)"
        if let statusTimes = UserDefaults.standard.dictionary(forKey: orderKey) as? [String: String] {
            if let confirmedTime = statusTimes["confirmed"] {
                statusData[1].1 = "Your order has been confirmed by the chef."
                statusData[1].2 = confirmedTime
                statusData[1].3 = true
            }
            if let preparedTime = statusTimes["prepared"] {
                statusData[2].1 = "Your order has been freshly prepared and is ready."
                statusData[2].2 = preparedTime
                statusData[2].3 = true
            }
            if let deliveryTime = statusTimes["delivery"] {
                statusData[3].1 = "Your order is on the way to your location."
                statusData[3].2 = deliveryTime
                statusData[3].3 = true
            }
            if let deliveredTime = statusTimes["delivered"] {
                statusData[4].1 = "Your order has been delivered. Enjoy your meal!"
                statusData[4].2 = deliveredTime
                statusData[4].3 = true
            }
        }

        if !statusData[4].3 {
            startStatusUpdateTimer(for: order)
        }
    }

    private func startStatusUpdateTimer(for order: Order) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.updateOrderStatus(for: order)
        }
    }

    private func updateOrderStatus(for order: Order) {
        guard let startTime = startTime else { return }

        let currentTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        let timeElapsed = currentTime.timeIntervalSince(startTime)
        let currentTimeStr = formatter.string(from: currentTime)

        let defaults = UserDefaults.standard
        let orderKey = "orderTimes_\(order.orderID)"

        var statusTimes = defaults.dictionary(forKey: orderKey) as? [String: String] ?? [:]

        if let _ = statusTimes["delivered"] {
            timer?.invalidate()
            timer = nil
            return
        }

        if statusTimes["placed"] == nil {
            statusTimes["placed"] = formatter.string(from: startTime)
        }

        if timeElapsed >= 5 && !statusData[1].3 && statusTimes["confirmed"] == nil {
            statusData[1].1 = "Your order has been confirmed by the chef."
            statusData[1].2 = currentTimeStr
            statusData[1].3 = true
            statusTimes["confirmed"] = currentTimeStr
        }

        if timeElapsed >= 10 && !statusData[2].3 && statusTimes["prepared"] == nil {
            statusData[2].1 = "Your order has been freshly prepared and is ready."
            statusData[2].2 = currentTimeStr
            statusData[2].3 = true
            statusTimes["prepared"] = currentTimeStr
        }

        if timeElapsed >= 15 && !statusData[3].3 && statusTimes["delivery"] == nil {
            statusData[3].1 = "Your order is on the way to your location."
            statusData[3].2 = currentTimeStr
            statusData[3].3 = true
            statusTimes["delivery"] = currentTimeStr
        }

        if timeElapsed >= 20 && !statusData[4].3 {
            statusData[4].1 = "Your order has been delivered. Enjoy your meal!"
            statusData[4].2 = currentTimeStr
            statusData[4].3 = true
            statusTimes["delivered"] = currentTimeStr

            defaults.set(statusTimes, forKey: orderKey)
            timer?.invalidate()
            timer = nil
        }

        defaults.set(statusTimes, forKey: orderKey)
        updateProgress()
    }

    private func updateProgress() {
        let completedSteps = statusData.filter { $0.3 }.count
        progress = Double(completedSteps) / Double(statusData.count)
    }

    deinit {
        timer?.invalidate()
    }
}

#if canImport(UIKit)
import UIKit
struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
#endif

struct OrderPricePopupView: View {
    let price: String
    let gst: String
    let discount: String
    let grandTotal: String
    var onClose: (() -> Void)? = nil
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 16) {
                // Icon and title
                Image(systemName: "creditcard.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 44, height: 44)
                    .foregroundColor(.blue)
                    .padding(.top, 24)
                Text("Payment Details")
                    .font(.title2).bold()
                    .padding(.bottom, 8)
                VStack(spacing: 10) {
                    PriceRow(title: "Subtotal", value: "₹\(price)")
                    PriceRow(title: "GST (18%)", value: "₹\(gst)")
                    PriceRow(title: "Discount", value: "-₹\(discount)")
                        .foregroundColor(.green)
                }
                .padding(.horizontal, 16)
                Divider().padding(.vertical, 8)
                HStack {
                    Text("Grand Total")
                        .font(.title3).bold()
                    Spacer()
                    Text("₹\(grandTotal)")
                        .font(.title3).bold()
                        .foregroundColor(.blue)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                Button(action: {
                    if let onClose = onClose {
                        onClose()
                    } else {
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Close")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(20)
                }
                .padding(.bottom, 20)
            }
        }
        .frame(width: 320)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: Color(.black).opacity(0.15), radius: 18, x: 0, y: 8)
        )
        .padding(.horizontal, 24)
    }
}

struct PriceRow: View {
    let title: String
    let value: String
    var fontWeight: Font.Weight = .regular

    var body: some View {
        HStack {
            Text(title)
                .fontWeight(fontWeight)
            Spacer()
            Text(value)
                .fontWeight(fontWeight)
        }
    }
} 
