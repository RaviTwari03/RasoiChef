//
//  SceneDelegate.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 13/01/25.
//

import UIKit
import Supabase
import SwiftUI
import CoreLocation

class SceneDelegate: UIResponder, UIWindowSceneDelegate, CLLocationManagerDelegate {
    
    var window: UIWindow?
    private var locationManager: CLLocationManager?
    private let supabase = SupabaseController.shared.client
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        print("\n🚀 App is starting...")
        print("📱 Configuring scene...")
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Initialize window
        window = UIWindow(windowScene: windowScene)
        
        // Check if user is logged in
        if let _ = UserDefaults.standard.string(forKey: "userEmail") {
            // User is logged in, show MainTabBar
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let tabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBar") as? UITabBarController {
                window?.rootViewController = tabBarController
                // Setup location manager only after successful login
                setupLocationManager()
            }
        } else {
            // User is not logged in, show LoginView
            let loginView = LoginView()
            let hostingController = UIHostingController(rootView: loginView)
            window?.rootViewController = hostingController
        }
        
        window?.makeKeyAndVisible()
        
        // Load data from Supabase with retry mechanism
        Task {
            print("\n🔄 Loading data from Supabase...")
            var retryCount = 0
            let maxRetries = 3
            
            while retryCount < maxRetries {
                do {
                    try await KitchenDataController.loadData()
                    
                    // Check if data was loaded successfully
                    if !KitchenDataController.kitchens.isEmpty || !KitchenDataController.menuItems.isEmpty {
                        // Print statistics about loaded data
                        print("\n📊 Data Loading Statistics:")
                        print("- Kitchens loaded: \(KitchenDataController.kitchens.count)")
                        print("- Menu Items loaded: \(KitchenDataController.menuItems.count)")
                        print("- Breakfast Items: \(KitchenDataController.GlobalbreakfastMenuItems.count)")
                        print("- Lunch Items: \(KitchenDataController.GloballunchMenuItems.count)")
                        print("- Snacks Items: \(KitchenDataController.GlobalsnacksMenuItems.count)")
                        print("- Dinner Items: \(KitchenDataController.GlobaldinnerMenuItems.count)")
                     //   print("- Subscription Plans: \(KitchenDataController.subscriptionPlans.count)")
                        print("- Chef Specialty Dishes: \(KitchenDataController.chefSpecialtyDishes.count)")
                        
                        // If successful, break the retry loop
                        break
                    }
                } catch {
                    print("\n❌ Error loading data (Attempt \(retryCount + 1)/\(maxRetries)): \(error.localizedDescription)")
                }
                
                retryCount += 1
                
                if retryCount < maxRetries {
                    print("Retrying in 2 seconds...")
                    try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
                } else {
                    print("Failed to load data after \(maxRetries) attempts")
                    // Handle the failure case - maybe show an error to the user
                    DispatchQueue.main.async {
                        // Show an alert or update UI to indicate error
                        let alert = UIAlertController(
                            title: "Data Loading Error",
                            message: "Failed to load data. Please check your internet connection and try again.",
                            preferredStyle: .alert
                        )
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.window?.rootViewController?.present(alert, animated: true)
                    }
                }
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    // Make setupLocationManager public so it can be called from LoginView
    func setupLocationManager() {
        guard locationManager == nil else { return }
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        
        // Request location permission
        locationManager?.requestWhenInUseAuthorization()
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager?.startUpdatingLocation()
        case .denied, .restricted:
            // Show alert to user about importance of location
            DispatchQueue.main.async {
                let alert = UIAlertController(
                    title: "Location Access Required",
                    message: "RasoiChef needs your location to find nearby kitchens and deliver food to your address. Please enable location access in Settings.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
                    if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsUrl)
                    }
                })
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                self.window?.rootViewController?.present(alert, animated: true)
            }
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // Store location locally
        UserDefaults.standard.set(location.coordinate.latitude, forKey: "userLatitude")
        UserDefaults.standard.set(location.coordinate.longitude, forKey: "userLongitude")
        
        // Update location in Supabase and calculate distances
        Task {
            do {
                // Get current user's email from UserDefaults
                if let userEmail = UserDefaults.standard.string(forKey: "userEmail") {
                    // 1. Update user's location in users table
                    try await supabase.database
                        .from("users")
                        .update([
                            "latitude": location.coordinate.latitude,
                            "longitude": location.coordinate.longitude
                        ])
                        .eq("email", value: userEmail)
                        .execute()
                    
                    // 2. Fetch all kitchens to calculate distances
                    let response = try await supabase.database
                        .from("kitchens")
                        .select("kitchen_id, latitude, longitude")
                        .execute()
                    
                    let json = try JSONSerialization.jsonObject(with: response.data, options: []) as? [[String: Any]]
                    
                    // 3. Calculate and update distances for each kitchen
                    if let kitchens = json {
                        for kitchen in kitchens {
                            if let kitchenId = kitchen["kitchen_id"] as? String,
                               let kitchenLat = kitchen["latitude"] as? Double,
                               let kitchenLong = kitchen["longitude"] as? Double {
                                
                                // Calculate distance using CLLocation
                                let userLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                                let kitchenLocation = CLLocation(latitude: kitchenLat, longitude: kitchenLong)
                                
                                // Get distance in kilometers
                                let distanceInMeters = userLocation.distance(from: kitchenLocation)
                                let distanceInKm = Double(round(100 * distanceInMeters / 1000) / 100) // Round to 2 decimal places
                                
                                // Update distance in kitchens table
                                try await supabase.database
                                    .from("kitchens")
                                    .update(["distance": distanceInKm])
                                    .eq("kitchen_id", value: kitchenId)
                                    .execute()
                            }
                        }
                    }
                }
            } catch {
                // Handle error silently
            }
        }
    }
}


