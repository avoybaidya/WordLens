//  AppDelegate.swift
//  Created by Avoy on 7/27/23.

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // Simplify the didFinishLaunchingWithOptions function by removing the unnecessary comment
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        true
    }

    // Provide a more descriptive name for the scene configuration if needed, or leave it as default
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    // The didDiscardSceneSessions function can be omitted if you're not using it to release any resources
}
