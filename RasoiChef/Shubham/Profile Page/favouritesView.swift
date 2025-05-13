//
//  favouritesView.swift
//  RasoiChef
//
//  Created by Shubham Jaiswal on 26/04/25.
//

import SwiftUI
import UIKit

struct favouritesView: View {
    @State private var favoriteKitchens: [Kitchen] = []
    @State private var isRefreshing = false
    
    var body: some View {
        Group {
            if favoriteKitchens.isEmpty {
                // Empty state message
                VStack(spacing: 10) {
                    Image(systemName: "heart.slash")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray.opacity(0.6))
                    
                    Text("No Favourites Yet")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    
                    Text("Your favourite kitchens will appear here.")
                        .font(.subheadline)
                        .foregroundColor(.gray.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(favoriteKitchens, id: \.kitchenID) { kitchen in
                        if kitchen.isOnline {
                            KitchenCell(kitchen: kitchen)
                                .onTapGesture {
                                    openKitchenDetail(kitchen: kitchen)
                                }
                        } else {
                            KitchenCell(kitchen: kitchen)
                                .opacity(0.5)
                        }
                    }
                }
                .refreshable {
                    await refreshFavorites()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .navigationTitle("Favourites")
        .onAppear {
            print("🔄 FavouritesView appeared")
            loadFavoriteKitchens()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("FavoritesUpdated"))) { _ in
            print("📢 Received FavoritesUpdated notification")
            loadFavoriteKitchens()
        }
    }
    
    private func openKitchenDetail(kitchen: Kitchen) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            return
        }
        
        // Find the tab bar controller
        guard let tabBarController = rootViewController as? UITabBarController,
              let selectedNavController = tabBarController.selectedViewController as? UINavigationController else {
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let kitchenVC = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
            kitchenVC.kitchenData = kitchen
            selectedNavController.pushViewController(kitchenVC, animated: true)
        }
    }
    
    private func loadFavoriteKitchens() {
        print("\n🔍 Loading favorite kitchens...")
        print("📊 Current kitchens count: \(KitchenDataController.kitchens.count)")
        
        // Get favorite kitchen IDs from KitchenDataController
        let favoriteIDs = KitchenDataController.favoriteKitchens
        print("✅ Found \(favoriteIDs.count) favorite IDs: \(favoriteIDs)")
        
        // Filter kitchens to get only favorites
        favoriteKitchens = KitchenDataController.kitchens.filter { kitchen in
            let isFavorite = favoriteIDs.contains(kitchen.kitchenID)
            print("🔍 Checking kitchen: \(kitchen.name) (ID: \(kitchen.kitchenID)) - Is favorite: \(isFavorite)")
            return isFavorite
        }
        print("✅ Loaded \(favoriteKitchens.count) favorite kitchens")
        print("📋 Favorite kitchens: \(favoriteKitchens.map { $0.name })")
    }
    
    private func refreshFavorites() async {
        print("\n🔄 Starting refresh...")
        isRefreshing = true
        defer { isRefreshing = false }
        
        // Reload favorites from database
        await MainActor.run {
            print("📥 Reloading favorites from database...")
            KitchenDataController.loadFavorites()
            loadFavoriteKitchens()
        }
    }
}

// MARK: - Kitchen Cell View
struct KitchenCell: View {
    let kitchen: Kitchen
    
    var body: some View {
        HStack(spacing: 12) {
            // Kitchen Image
            if let imageUrl = URL(string: kitchen.kitchenImage) {
                AsyncImage(url: imageUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Image(systemName: "photo")
                        .foregroundColor(.gray)
                }
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(kitchen.name)
                    .font(.headline)
                
                Text(String(format: "%.1f km", kitchen.distance))
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack {
                    Circle()
                        .fill(kitchen.isOnline ? Color.green : Color.gray)
                        .frame(width: 8, height: 8)
                    Text(kitchen.isOnline ? "Online" : "Offline")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .opacity(kitchen.isOnline ? 1 : 0.3)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    NavigationView {
        favouritesView()
    }
}
