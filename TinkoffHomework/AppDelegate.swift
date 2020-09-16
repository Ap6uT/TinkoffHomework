//
//  AppDelegate.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 14.09.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        printLog("Application started: " + #function)
        return true
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        printLog("Application moved from active to inactive: " + #function)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        printLog("Application moved from inactive to active: " + #function)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        printLog("Application moved from inactive to background: " + #function)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        printLog("Application moved from background to foreground: " + #function)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        printLog("Application will be terminated: " + #function)
    }
    
}

