//
//  favouritesView.swift
//  RasoiChef
//
//  Created by Shubham Jaiswal on 26/04/25.
//

import SwiftUI

struct favouritesView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Text("No Favourites.")
                .font(.largeTitle)
                .padding()
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Stretch VStack to full screen
        .background(Color.white)
    }
}

#Preview {
    favouritesView()
}
