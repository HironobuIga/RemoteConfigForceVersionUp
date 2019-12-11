//
//  AppDelegate.swift
//  RemoteConfigForceUpdate
//
//  Created by 伊賀裕展 on 2019/12/08.
//  Copyright © 2019 Iganin. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // initialize firebase
        FirebaseApp.configure()
        return true
    }

    // MARK: UISceneSession Lifecycle

//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }

//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // foreground <-> background遷移時に状態の変更を反映できるよう
        // このタイミングでRemoteConfigの設定値取得を行います
        RemoteConfigService.shared.fetchAllData()
    }
}

