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
    let supabase = SupabaseClient(supabaseURL: URL(string: "https://lplftokvbtoqqietgujl.supabase.co")!,
                                  supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxwbGZ0b2t2YnRvcXFpZXRndWpsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk4NzA2NzQsImV4cCI6MjA1NTQ0NjY3NH0.2EOleVodMu4KFH2Zn6jMyXniMckbTdKlf45beahOlHM")
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) async {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        do {
            let session = try await supabase.auth.session
            if session != nil {
                let homeVC = UIStoryboard(name: "LandingPageViewController", bundle: nil).instantiateViewController(withIdentifier: "LandingPageViewController")
                window?.rootViewController = UINavigationController(rootViewController: homeVC)
            } else {
                let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
                window?.rootViewController = UINavigationController(rootViewController: loginVC)
            }
        } catch {
            print("Error fetching session: \(error.localizedDescription)")
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
            window?.rootViewController = UINavigationController(rootViewController: loginVC)
        }
        
        window?.makeKeyAndVisible()
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


