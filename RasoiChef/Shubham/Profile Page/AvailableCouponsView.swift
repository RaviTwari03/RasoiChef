//
//  AvailableCouponsView.swift
//  RasoiChef
//
//  Created by Shubham Jaiswal on 13/05/25.
//

import SwiftUI

struct AvailableCouponsView: View {
    @State private var coupons: [Coupon] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var showSignInAlert = false
    @State private var shouldNavigateToLogin = false
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView("Loading coupons...")
            } else if let error = errorMessage {
                VStack(spacing: 10) {
                    Image(systemName: "exclamationmark.triangle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.red)
                    
                    Text("Error Loading Coupons")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text(error)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    if error.contains("sign in") {
                        Button("Sign In") {
                            shouldNavigateToLogin = true
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    } else {
                        Button("Try Again") {
                            loadCoupons()
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
            } else if coupons.isEmpty {
                emptyStateView
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(coupons) { coupon in
                            CouponCardView(coupon: coupon)
                        }
                    }
                    .padding()
                }
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Available Coupons")
        .task {
            loadCoupons()
        }
        .fullScreenCover(isPresented: $shouldNavigateToLogin) {
            LoginView()
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 10) {
            Spacer()
            
            Image(systemName: "tag.slash")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray.opacity(0.6))
            
            Text("No Coupons Available")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            Text("Currently, there are no active coupons.\nPlease check back later.")
                .font(.subheadline)
                .foregroundColor(.gray.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func loadCoupons() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                // Check if user is logged in
                if UserDefaults.standard.string(forKey: "userEmail") == nil {
                    throw NSError(domain: "DataController", code: 401, userInfo: [NSLocalizedDescriptionKey: "Please sign in to view coupons"])
                }
                
                try await KitchenDataController.fetchAvailableCoupons()
                coupons = KitchenDataController.availableCoupons
            } catch {
                if let decodingError = error as? DecodingError {
                    switch decodingError {
                    case .keyNotFound(let key, _):
                        errorMessage = "Missing data: \(key.stringValue)"
                    case .typeMismatch(_, let context):
                        errorMessage = "Data format error: \(context.debugDescription)"
                    case .valueNotFound(_, let context):
                        errorMessage = "Missing value: \(context.debugDescription)"
                    case .dataCorrupted(let context):
                        errorMessage = "Data corrupted: \(context.debugDescription)"
                    @unknown default:
                        errorMessage = "Unknown error: \(error.localizedDescription)"
                    }
                } else {
                    errorMessage = error.localizedDescription
                }
            }
            isLoading = false
        }
    }
}

struct CouponCardView: View {
    let coupon: Coupon
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(coupon.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(coupon.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text("\(coupon.discountPercentage)%")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            }
            
            HStack {
                Image(systemName: "indianrupeesign.circle.fill")
                    .foregroundColor(.orange)
                Text("Min. Order: ₹\(Int(coupon.minimumOrderAmount))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if coupon.isOneTimeUse {
                    Text("One-time use")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(4)
                } else {
                    Text("After every 5 orders")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.purple.opacity(0.1))
                        .foregroundColor(.purple)
                        .cornerRadius(4)
                }
            }
            
            if !coupon.isEnabled {
                Text("Complete \(5 - coupon.orderCount) more orders to unlock")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 4)
            }
            
            if let expirationDate = coupon.expirationDate {
                Text("Expires: \(expirationDate.formatted(date: .abbreviated, time: .omitted))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 4)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .opacity(coupon.isEnabled ? 1.0 : 0.6)
    }
}

#Preview {
    NavigationView {
        AvailableCouponsView()
    }
}
