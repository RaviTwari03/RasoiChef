//
//  AvailableCouponsView.swift
//  RasoiChef
//
//  Created by Shubham Jaiswal on 13/05/25.
//

import SwiftUI

struct AvailableCouponsView: View {
    var body: some View {
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
        .background(Color.white)
        .navigationTitle("Available Coupons")
    }
}

#Preview {
    AvailableCouponsView()
}
