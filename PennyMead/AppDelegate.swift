//
//  AppDelegate.swift
//  PennyMead
//
//  Created by siddappa tambakad on 04/01/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        Thread.sleep(forTimeInterval: 3)
//        splashScreen()
        return true
    }
    
//    func splashScreen() {
//        let storyBoard = UIStoryboard.init(name: "LaunchScreen", bundle: nil)
//        let rootVc = storyBoard.instantiateViewController(withIdentifier: "launchScreen")
//        self.window?.rootViewController = rootVc
//        self.window?.makeKeyAndVisible()
//        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(dissMissSplash), userInfo: nil, repeats: false)
//    }
//
//    @objc func dissMissSplash() {
//        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
//        let homeVc = storyBoard.instantiateViewController(withIdentifier: "HomeVc") as! HomeVc
//        self.window?.rootViewController = homeVc
//        self.window?.makeKeyAndVisible()
//    }

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

