import SwiftUI

struct MealSubscriptionPlanView: View {
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var selectedMeals: Set<String> = []
    @State private var showingPriceDetails = false
    
    private let mealTypes = ["Breakfast", "Lunch", "Snacks", "Dinner"]
    private let mealPrices = ["Breakfast": 30.0, "Lunch": 40.0, "Snacks": 50.0, "Dinner": 60.0]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Weekly Plans Section
            Text("Weekly Plans")
                .font(.system(size: 32, weight: .bold))
                .padding(.horizontal)
            
            // Date Selection Section
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 20) {
                    DateSelectionView(title: "Start Date", date: $startDate)
                    DateSelectionView(title: "End Date", date: $endDate)
                }
                
                // Selected Range
                VStack(alignment: .leading) {
                    Text("Selected Range")
                        .font(.system(size: 20, weight: .regular))
                    HStack {
                        Image(systemName: "calendar")
                        Text(formatDateRange())
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
            }
            .padding(.horizontal)
            
            // Customize Table Section
            VStack(alignment: .leading) {
                HStack {
                    Text("Customize Table")
                        .font(.system(size: 24, weight: .bold))
                    Spacer()
                    Button(action: { showingPriceDetails = true }) {
                        HStack {
                            Text("Price Details")
                            Image(systemName: "info.circle")
                        }
                    }
                }
                Text("Click on each cell to modify your plan")
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
            
            // Meal Table
            ScrollView {
                VStack(spacing: 0) {
                    // Header Row
                    HStack(spacing: 0) {
                        Text("Meals/Days")
                            .frame(width: 120)
                            .padding(.vertical, 12)
                            .background(Color.white)
                        ForEach(mealTypes, id: \.self) { meal in
                            Text(meal)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.white)
                        }
                    }
                    .border(Color.gray.opacity(0.2))
                    
                    // Day Rows
                    ForEach(getDaysInRange(), id: \.self) { date in
                        DayRow(date: date, selectedMeals: $selectedMeals, mealTypes: mealTypes)
                            .border(Color.gray.opacity(0.2))
                    }
                }
            }
            
            Spacer()
            
            // Bottom Bar
            HStack {
                VStack(alignment: .leading) {
                    Text("Pay")
                        .font(.system(size: 24, weight: .bold))
                    Text("₹\(Int(calculateTotalPrice()))")
                        .font(.system(size: 24, weight: .bold))
                }
                Spacer()
                Button(action: {
                    // Add subscription plan to cart
                }) {
                    Text("Subscribe Plan")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200)
                        .background(Color.orange)
                        .cornerRadius(10)
                }
            }
            .padding()
            .background(Color.white)
            .shadow(radius: 5)
        }
        .sheet(isPresented: $showingPriceDetails) {
            PriceDetailsView()
        }
    }
    
    private func formatDateRange() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return "\(formatter.string(from: startDate)) - \(formatter.string(from: endDate))"
    }
    
    private func getDaysInRange() -> [Date] {
        guard startDate <= endDate else { return [] }
        let calendar = Calendar.current
        let numberOfDays = calendar.dateComponents([.day], from: startDate, to: endDate).day ?? 0
        return (0...numberOfDays).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: dayOffset, to: startDate)
        }
    }
    
    private func calculateTotalPrice() -> Double {
        selectedMeals.reduce(0.0) { total, meal in
            let mealType = meal.components(separatedBy: "-").last ?? ""
            return total + (mealPrices[mealType] ?? 0.0)
        }
    }
}

struct DateSelectionView: View {
    let title: String
    @Binding var date: Date
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: 20, weight: .regular))
            HStack {
                Image(systemName: "calendar")
                Text(formattedDate)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .onTapGesture {
                // Show date picker
            }
        }
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter.string(from: date)
    }
}

struct DayRow: View {
    let date: Date
    @Binding var selectedMeals: Set<String>
    let mealTypes: [String]
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()
    
    var body: some View {
        HStack(spacing: 0) {
            Text(dateFormatter.string(from: date))
                .frame(width: 120)
                .padding(.vertical, 12)
                .background(Color.white)
            
            ForEach(mealTypes, id: \.self) { meal in
                let mealId = "\(dateFormatter.string(from: date))-\(meal)"
                MealToggleButton(
                    isSelected: selectedMeals.contains(mealId),
                    meal: meal
                ) {
                    if selectedMeals.contains(mealId) {
                        selectedMeals.remove(mealId)
                    } else {
                        selectedMeals.insert(mealId)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

struct MealToggleButton: View {
    let isSelected: Bool
    let meal: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(getMealIcon())
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .opacity(isSelected ? 1.0 : 0.1)
        }
        .frame(height: 44)
    }
    
    private func getMealIcon() -> String {
        switch meal {
        case "Breakfast": return "BreakfastIcon"
        case "Lunch": return "LunchIcon"
        case "Snacks": return "SnacksIcon"
        case "Dinner": return "DinnerIcon"
        default: return "BreakfastIcon"
        }
    }
}

struct PriceDetailsView: View {
    private let meals = [
        ("Breakfast", "sun.max", "₹30"),
        ("Lunch", "fork.knife", "₹40"),
        ("Snacks", "cup.and.saucer", "₹50"),
        ("Dinner", "moon", "₹60")
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                ForEach(meals, id: \.0) { meal, icon, price in
                    HStack {
                        Image(systemName: icon)
                            .frame(width: 30)
                        Text(meal)
                        Spacer()
                        Text(price)
                    }
                }
                .padding()
            }
            .navigationTitle("Meal Prices")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#if DEBUG
struct MealSubscriptionPlanView_Previews: PreviewProvider {
    static var previews: some View {
        MealSubscriptionPlanView()
    }
}
#endif