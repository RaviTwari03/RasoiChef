import SwiftUI
import MapKit

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
    @State private var showingFullScreenPaymentAlert = false
    @State private var selectedOrder: Order?
    @State private var showingTrackOrder = false
    @Namespace private var animation

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
                    ScrollView {
                        VStack(alignment: .leading, spacing: 36) {
                            if !viewModel.currentOrders.isEmpty {
                                SectionHeader(title: "Current Orders", color: .blue)
                                ForEach(viewModel.currentOrders) { order in
                                    OrderCard(order: order, isCurrent: true, menuItems: viewModel.menuItems, onInfo: { order in
                                        selectedOrder = order
                                        withAnimation { showingFullScreenPaymentAlert = true }
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
    @StateObject private var viewModel: OrderItemsListViewModel

    init(orderID: String, menuItems: [MenuItem]) {
        self.orderID = orderID
        self.menuItems = menuItems
        self._viewModel = StateObject(wrappedValue: OrderItemsListViewModel(orderID: orderID))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if viewModel.isLoading {
                Text("Loading...")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            } else if viewModel.itemDetails.isEmpty {
                Text("No items found")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            } else {
                ForEach(Array(viewModel.itemDetails.enumerated()), id: \.offset) { _, detail in
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
}

class OrderItemsListViewModel: ObservableObject {
    @Published var itemDetails: [(name: String, quantity: Int)] = []
    @Published var isLoading = true
    private let orderID: String

    init(orderID: String) {
        self.orderID = orderID
        fetchOrderItems()
    }

    private func fetchOrderItems() {
        Task {
            do {
                // First fetch the order items
                let response = try await SupabaseController.shared.client.database
                    .from("orders")
                    .select("order_items")
                    .eq("order_id", value: orderID)
                    .single()
                    .execute()

                print("Raw response: \(String(data: response.data, encoding: .utf8) ?? "No data")")

                guard let json = try? JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any],
                      let orderItemsData = json["order_items"] as? [[String: Any]] else {
                    print("Failed to parse order items data")
                    await MainActor.run {
                        self.isLoading = false
                    }
                    return
                }

                var details: [(String, Int)] = []
                
                // Process each order item
                for item in orderItemsData {
                    guard let menuItemID = item["menu_item_id"] as? String,
                          let quantity = item["quantity"] as? Int else {
                        print("Missing required fields in order item: \(item)")
                        continue
                    }

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
                            print("Found menu item: \(name) with quantity: \(quantity)")
                            details.append((name, quantity))
                            continue
                        }
                    } catch {
                        print("Error fetching menu item: \(error)")
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
                            print("Found specialty item: \(name) with quantity: \(quantity)")
                            details.append((name, quantity))
                            continue
                        }
                    } catch {
                        print("Error fetching specialty item: \(error)")
                    }

                    // If item name not found in either table, use a generic name
                    details.append(("Item #\(menuItemID)", quantity))
                }

                await MainActor.run {
                    self.itemDetails = details
                    self.isLoading = false
                }
            } catch {
                print("Error fetching order items: \(error)")
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
            Divider().padding(.vertical, 2)
            OrderItemsList(orderID: order.orderID, menuItems: menuItems)
                .padding(.top, 2)
            Divider().padding(.vertical, 2)
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
                    Button(action: { onTrack(order) }) {
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
        NavigationView {
            VStack(spacing: 0) {
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
