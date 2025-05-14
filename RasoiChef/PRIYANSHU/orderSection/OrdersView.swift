import SwiftUI

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

struct OrdersView: View {
    @StateObject private var viewModel = OrdersViewModel()
    @State private var showingPricePopup = false
    @State private var selectedOrder: Order?
    @State private var showingTrackOrder = false
    @Namespace private var animation

    var body: some View {
            NavigationView {
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [Color(.systemGroupedBackground), Color(.systemGray6)]), startPoint: .top, endPoint: .bottom)
                        .ignoresSafeArea()
                    ScrollView {
                        VStack(alignment: .leading, spacing: 36) {
                            if !viewModel.currentOrders.isEmpty {
                                SectionHeader(title: "Current Orders", color: .blue)
                                ForEach(viewModel.currentOrders) { order in
                                    OrderCard(order: order, isCurrent: true, menuItems: viewModel.menuItems, onInfo: { order in
                                        selectedOrder = order
                                        withAnimation { showingPricePopup = true }
                                    }, onTrack: { order in
                                        selectedOrder = order
                                        showingTrackOrder = true
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
                                        withAnimation { showingPricePopup = true }
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
                        }
                        .padding(.vertical, 24)
                    }
                }
                .navigationBarTitleDisplayMode(.large)
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

class OrderItemsListViewModel: ObservableObject {
    @Published var itemDetails: [(name: String, quantity: Int)] = []
    private let items: [OrderItem]

    init(items: [OrderItem]) {
        self.items = items
        fetchItemNames()
    }

    private func fetchItemNames() {
        Task {
            var details: [(String, Int)] = []
            for item in items {
                if let name = await fetchMenuItemName(for: item.menuItemID) {
                    details.append((name, item.quantity))
                } else if let name = await fetchChefSpecialName(for: item.menuItemID) {
                    details.append((name, item.quantity))
                } else {
                    details.append(("Item #\(item.menuItemID)", item.quantity))
                }
            }
            await MainActor.run {
                self.itemDetails = details
            }
        }
    }

    private func fetchMenuItemName(for menuItemID: String) async -> String? {
        do {
            let response = try await SupabaseController.shared.client.database
                .from("menu_items")
                .select("name")
                .eq("item_id", value: menuItemID)
                .single()
                .execute()
            if let json = try? JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any],
               let name = json["name"] as? String {
                return name
            }
        } catch {}
        return nil
    }

    private func fetchChefSpecialName(for dishID: String) async -> String? {
        do {
            let response = try await SupabaseController.shared.client.database
                .from("chef_specialty_dishes")
                .select("name")
                .eq("dish_id", value: dishID)
                .single()
                .execute()
            if let json = try? JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any],
               let name = json["name"] as? String {
                return name
            }
        } catch {}
        return nil
    }
}

struct OrderItemsList: View {
    let orderID: String
    let menuItems: [MenuItem]
    @State private var itemDetails: [(name: String, quantity: Int)] = []
    @State private var isLoading = true

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if isLoading {
                Text("Loading...")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .onAppear {
                        fetchOrderItems()
                    }
            } else if itemDetails.isEmpty {
                Text("No items found")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            } else {
                ForEach(Array(itemDetails.enumerated()), id: \.offset) { _, detail in
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
            }
        }
    }

    private func fetchOrderItems() {
        Task {
            do {
                let response = try await SupabaseController.shared.client.database
                    .from("orders")
                    .select("order_items")
                    .eq("order_id", value: orderID)
                    .single()
                    .execute()
                guard let json = try? JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any] else {
                    await MainActor.run {
                        self.isLoading = false
                    }
                    return
                }
                var orderItems: [[String: Any]] = []
                if let orderItemsString = json["order_items"] as? String {
                    if let data = orderItemsString.data(using: .utf8),
                       let parsedItems = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                        orderItems = parsedItems
                    }
                } else if let itemsArray = json["order_items"] as? [[String: Any]] {
                    orderItems = itemsArray
                }
                var details: [(String, Int)] = []
                for item in orderItems {
                    guard let menuItemID = item["menu_item_id"] as? String,
                          let quantity = item["quantity"] as? Int else { continue }
                    let name = menuItems.first(where: { $0.itemID == menuItemID })?.name ?? "Item #\(menuItemID)"
                    details.append((name, quantity))
                }
                await MainActor.run {
                    self.itemDetails = details
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
    }
}

struct OrderCard: View {
    let order: Order
    let isCurrent: Bool
    let menuItems: [MenuItem]
    let onInfo: (Order) -> Void
    let onTrack: (Order) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Order header
            HStack {
                Text("Order #\(order.orderID)")
                    .font(.headline)
                Spacer()
                if isCurrent {
                    Button(action: { onTrack(order) }) {
                        Text("Track")
                            .foregroundColor(.blue)
                    }
                }
            }
            
            // Order details
            Text(order.kitchenName)
                .font(.subheadline)
            Text(order.deliveryAddress)
                .font(.caption)
                .foregroundColor(.gray)
            
            // Items list
            VStack(alignment: .leading) {
                Text("Items:")
                    .font(.subheadline)
                    .padding(.top, 4)
                ForEach(order.items, id: \.menuItemID) { item in
                    if let menuItem = menuItems.first(where: { $0.itemID == item.menuItemID }) {
                        Text("\(menuItem.name) x\(item.quantity)")
                            .font(.caption)
                    }
                }
            }
            
            // Order status and total
            HStack {
                Text(order.status.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(order.status == .delivered ? Color.green.opacity(0.2) : Color.blue.opacity(0.2))
                    .cornerRadius(4)
                Spacer()
                Text("₹\(order.totalAmount, specifier: "%.2f")")
                    .fontWeight(.semibold)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
        .padding(.horizontal)
    }
}

struct OrderPriceRow: View {
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
                    OrderPriceRow(title: "Subtotal", value: "₹\(price)")
                    OrderPriceRow(title: "GST (18%)", value: "₹\(gst)")
                    OrderPriceRow(title: "Discount", value: "-₹\(discount)")
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
                Button {
                    if let onClose = onClose {
                        onClose()
                    } else {
                        presentationMode.wrappedValue.dismiss()
                    }
                } label: {
                    Text("Close")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), 
                                         startPoint: .leading, 
                                         endPoint: .trailing)
                        )
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

struct TrackOrderView: View {
    let order: Order
    @StateObject private var viewModel = TrackOrderViewModel()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.statusData.indices, id: \.self) { index in
                    let (status, description, time, isCompleted) = viewModel.statusData[index]
                    OrderTrackingCell(
                        status: status,
                        description: description,
                        time: time,
                        isCompleted: isCompleted,
                        hideLastLine: index == viewModel.statusData.count - 1 && isCompleted
                    )
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Track Order")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
            .onAppear {
                viewModel.initializeTracking(for: order)
            }
        }
    }
}

struct OrderTrackingCell: View {
    let status: String
    let description: String
    let time: String
    let isCompleted: Bool
    let hideLastLine: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Status indicator
            VStack(spacing: 0) {
                Circle()
                    .fill(isCompleted ? Color.green : Color.gray)
                    .frame(width: 12, height: 12)
                if !hideLastLine {
                    Rectangle()
                        .fill(isCompleted ? Color.green : Color.gray)
                        .frame(width: 2)
                }
            }

            // Status details
            VStack(alignment: .leading, spacing: 4) {
                    Text(status)
                        .font(.headline)
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                Text(time)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8)
    }
}

enum OrderType {
    case current
    case past
}

class OrdersViewModel: ObservableObject {
    @Published var orders: [Order] = []
    @Published var isLoading = false
    @Published var selectedOrderType: OrderType = .current
    @Published var menuItems: [MenuItem] = []

    var currentOrders: [Order] {
        orders.filter { $0.status != .delivered }
    }
    var pastOrders: [Order] {
        orders.filter { $0.status == .delivered }
    }

    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleOrdersUpdate),
            name: .ordersDidUpdate,
            object: nil
        )
        loadMenuItems()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc private func handleOrdersUpdate(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let currentOrders = userInfo["currentOrders"] as? [Order],
           let pastOrders = userInfo["pastOrders"] as? [Order] {
            DispatchQueue.main.async {
                self.orders = currentOrders + pastOrders
            }
        }
    }
    func loadData() {
        isLoading = true
        Task {
            do {
                guard let session = try await SupabaseController.shared.getCurrentSession() else {
                    print("❌ No authenticated user found")
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.orders = []
                    }
                    return
                }
                let userID = session.user.id.uuidString
                print("🔄 Fetching orders for authenticated user: \(userID)")
                let fetchedOrders = try await SupabaseController.shared.fetchOrders(for: userID)
                DispatchQueue.main.async {
                    self.isLoading = false
                    OrderDataController.shared.setOrders(fetchedOrders)
                }
            } catch {
                print("❌ Error fetching orders: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.orders = []
                }
            }
        }
    }
    func loadMenuItems() {
        Task {
            do {
                let items = try await SupabaseController.shared.fetchMenuItems()
                await MainActor.run {
                    self.menuItems = items
                }
            } catch {
                print("❌ Error fetching menu items: \(error.localizedDescription)")
            }
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

    private var timer: Timer?
    private var startTime: Date?

    func initializeTracking(for order: Order) {
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
