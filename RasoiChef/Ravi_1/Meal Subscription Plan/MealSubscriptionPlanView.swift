import SwiftUI

struct MealSubscriptionPlanView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var selectedMeals: [[Bool]] = Array(repeating: [true, true, true, true], count: 7)
    @State private var showPriceDetails = false
    @Environment(\.presentationMode) var presentationMode
    
    private let mealTypes = ["Breakfast", "Lunch", "Snacks", "Dinner"]
    private let mealPrices = [30, 40, 50, 60]
    private let mealIcons = ["BreakfastIcon", "LunchIcon", "SnacksIcon", "DinnerIcon"]
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter
    }()
    
    private var minimumDate: Date {
        Calendar.current.startOfDay(for: Date())
    }
    
    private var maximumDate: Date {
        Calendar.current.date(byAdding: .day, value: 30, to: minimumDate) ?? Date()
    }
    
    var totalPrice: Int {
        var total = 0
        let days = getDaysInRange()
        
        for dayIndex in 0..<days.count {
            for (mealIndex, isSelected) in selectedMeals[dayIndex].enumerated() {
                if isSelected {
                    total += mealPrices[mealIndex]
                }
            }
        }
        return total
    }
    
    private func addToCart() {
        let subscriptionPlan = SubscriptionPlan(
            planID: UUID().uuidString,
            kitchenName: "RasoiChef Kitchen",
            userID: UUID().uuidString,
            location: "Default Location",
            startDate: dateFormatter.string(from: startDate),
            endDate: dateFormatter.string(from: endDate),
            totalPrice: Double(totalPrice),
            planName: "Custom Meal Plan",
            PlanIntakeLimit: 4
        )
        
        CartViewController.subscriptionPlan1.append(subscriptionPlan)
        
        // Post notification to update cart badge
        NotificationCenter.default.post(name: NSNotification.Name("CartUpdated"), object: nil)
        
        // Show banner
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first,
               let rootViewController = window.rootViewController {
                let banner = BannerView()
                banner.show(message: "Subscription plan added to cart", in: rootViewController)
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Weekly Plans Section
                    Text("Weekly Plans")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    // Date Selection
                    HStack(spacing: 45) {
                        VStack(alignment: .leading) {
                            Text("Start Date")
                                .font(.caption)
                                .foregroundColor(.gray)
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(.gray)
                                DatePicker("", selection: $startDate, in: minimumDate...maximumDate, displayedComponents: .date)
                                    .labelsHidden()
                            }
                            .padding(5)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("End Date")
                                .font(.caption)
                                .foregroundColor(.gray)
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(.gray)
                                DatePicker("", selection: $endDate, in: startDate...Calendar.current.date(byAdding: .day, value: 6, to: startDate)!, displayedComponents: .date)
                                    .labelsHidden()
                            }
                            .padding(5)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Selected Range
                    VStack(alignment: .leading, spacing: 18) {
                        Text("Selected Range")
                            .font(.headline)
                            .fontWeight(.medium)
                        
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.gray)
                            Text(getDateRangeText())
                                .font(.subheadline)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Customise Table Section
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Customise Table")
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                            Button(action: { showPriceDetails = true }) {
                                HStack {
                                    Text("Price Details")
                                        .foregroundColor(.primary)
                                    Image(systemName: "info.circle")
                                        .foregroundColor(.orange)
                                }
                            }
                        }
                        
                        Text("Click on each cell to modify your plan")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                    
                    // Meal Table
                    VStack(spacing: 0) {
                        // Header
                        HStack(spacing: 0) {
                            Text("Meals/Day")
                                .frame(width: 100, alignment: .leading)
                            ForEach(mealTypes, id: \.self) { meal in
                                Text(meal)
                                    .frame(maxWidth: .infinity)
                                    .font(.system(size: 15))
                                    .minimumScaleFactor(0.8)
                            }
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        
                        Divider()
                        
                        // Days
                        ForEach(getDaysInRange().indices, id: \.self) { index in
                            VStack(spacing: 0) {
                                HStack {
                                    Text(getDayName(for: getDaysInRange()[index]))
                                        .frame(width: 100, alignment: .leading)
                                    ForEach(0..<4, id: \.self) { mealIndex in
                                        Button(action: {
                                            selectedMeals[index][mealIndex].toggle()
                                        }) {
                                            Image(mealIcons[mealIndex])
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 30, height: 30)
                                                .opacity(selectedMeals[index][mealIndex] ? 1 : 0.2)
                                        }
                                        .frame(maxWidth: .infinity)
                                    }
                                }
                                .padding(.vertical, 10)
                                .padding(.horizontal)
                                
                                Divider()
                            }
                        }
                    }
                    .background(Color(.systemBackground))
                }
            }
            
            // Bottom Bar
            VStack(spacing: 0) {
                Divider()
                HStack {
                    Text("Pay ₹\(totalPrice)")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Spacer()
                    Button(action: {
                        addToCart()
                    }) {
                        Text("Subscribe Plan")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 12)
                            .background(Color("AccentColor"))
                            .cornerRadius(11)
                    }
                }
                .padding()
            }
            .background(Color(.systemBackground))
        }
        .sheet(isPresented: $showPriceDetails) {
            PriceDetailsView()
        }
    }
    
    private func getDaysInRange() -> [Date] {
        guard startDate <= endDate else { return [] }
        let calendar = Calendar.current
        let numberOfDays = calendar.dateComponents([.day], from: startDate, to: endDate).day ?? 0
        return (0...numberOfDays).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: dayOffset, to: startDate)
        }
    }
    
    private func getDayName(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
    
    private func getDateRangeText() -> String {
        return "\(dateFormatter.string(from: startDate)) - \(dateFormatter.string(from: endDate)) (Total Days: \(getDaysInRange().count))"
    }
    
    init() {
        _startDate = State(initialValue: Date())
        _endDate = State(initialValue: Date())
    }
}

struct CustomTabBar: View {
    var body: some View {
        HStack {
            TabBarButton(image: "calendar", text: "Home", isSelected: true)
            TabBarButton(image: "list.bullet.rectangle", text: "My Orders", isSelected: false)
            TabBarButton(image: "cart", text: "Cart", isSelected: false)
        }
        .padding(.top, 8)
        .padding(.bottom, 20)
        .background(Color(.systemBackground))
    }
}

struct TabBarButton: View {
    let image: String
    let text: String
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: image)
            Text(text)
                .font(.caption)
        }
        .foregroundColor(isSelected ? .orange : .gray)
        .frame(maxWidth: .infinity)
    }
}

struct MealPriceRow: View {
    let icon: String
    let meal: String
    let value: String

    var body: some View {
        HStack {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
            Text(meal)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("₹\(value)")
                .fontWeight(.semibold)
        }
    }
}

struct PriceDetailsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Meal Prices")
                .font(.title2)
                .fontWeight(.bold)
            VStack(spacing: 15) {
                MealPriceRow(icon: "BreakfastIcon", meal: "Breakfast", value: "30")
                MealPriceRow(icon: "LunchIcon", meal: "Lunch", value: "40")
                MealPriceRow(icon: "SnacksIcon", meal: "Snacks", value: "50")
                MealPriceRow(icon: "DinnerIcon", meal: "Dinner", value: "60")
            }
            .padding()
            Spacer()
        }
        .padding(.top)
        .presentationDetents([.medium])
    }
}

#if DEBUG
struct MealSubscriptionPlanView_Previews: PreviewProvider {
    static var previews: some View {
        MealSubscriptionPlanView()
    }
}
#endif
