//
//  AppDelegate.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 13/01/25.
//

import UIKit
import Supabase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let supabase = SupabaseClient(supabaseURL: URL(string: "https://outrozdhosucrncnpoze.supabase.co")!,
                                  supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im91dHJvemRob3N1Y3JuY25wb3plIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQyNjM1NDMsImV4cCI6MjA1OTgzOTU0M30.iUqo3FODlyjj8On1PtbUqmUVHNwyBiez4MGi4WZDJSM")

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        return true
    }



    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

