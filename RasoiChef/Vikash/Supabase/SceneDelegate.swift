//
//  SceneDelegate.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 13/01/25.
//

import UIKit
import Supabase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        print("\n🚀 App is starting...")
        print("📱 Configuring scene...")
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Initialize window
        window = UIWindow(windowScene: windowScene)
        
        // Load data from Supabase with retry mechanism
        Task {
            print("\n🔄 Loading data from Supabase...")
            var retryCount = 0
            let maxRetries = 3
            
            while retryCount < maxRetries {
                do {
                    try await KitchenDataController.loadInitialData()
                    
                    // Print statistics about loaded data
                    print("\n📊 Data Loading Statistics:")
                    print("- Kitchens loaded: \(KitchenDataController.kitchens.count)")
                    print("- Menu Items loaded: \(KitchenDataController.menuItems.count)")
                    print("- Breakfast Items: \(KitchenDataController.GlobalbreakfastMenuItems.count)")
                    print("- Lunch Items: \(KitchenDataController.GloballunchMenuItems.count)")
                    print("- Snacks Items: \(KitchenDataController.GlobalsnacksMenuItems.count)")
                    print("- Dinner Items: \(KitchenDataController.GlobaldinnerMenuItems.count)")
                    print("- Subscription Plans: \(KitchenDataController.subscriptionPlans.count)")
                    
                    // If successful, break the retry loop
                    break
                } catch {
                    retryCount += 1
                    print("\n❌ Error loading data (Attempt \(retryCount)/\(maxRetries)):")
                    print(error.localizedDescription)
                    
                    if retryCount < maxRetries {
                        print("Retrying in 2 seconds...")
                        try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
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
        
        // Set up your initial view controller here
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let initialViewController = storyboard.instantiateInitialViewController() {
            window?.rootViewController = initialViewController
            window?.makeKeyAndVisible()
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
}


