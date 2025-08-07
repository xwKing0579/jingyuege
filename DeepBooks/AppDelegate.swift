//
//  AppDelegate.swift
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/26.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    @objc var launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil;
    @objc var isVSConnection = false
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.launchOptions = launchOptions;

        let vpnStr = "isVPNConnected"
        let usbStr = "isUSBConnected"
        if UserDefaults.standard.bool(forKey: vpnStr) == false &&
            UIDevice.isVPNConnected() == true {
            isVSConnection = true
        }else{
            UserDefaults.standard.set(true, forKey: vpnStr)
        }
        
        if UserDefaults.standard.bool(forKey: usbStr) == false &&
            UIDevice.isUSBConnected() == true {
            isVSConnection = true
        }else{
            UserDefaults.standard.set(true, forKey: usbStr)
        }
        
        //支持webp
        DBDomainManager.supportWebpImage()
        
        //兼容
        UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        
        
        DBDefaultSwift.enableKeyboard()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        DBAppSetting.updateLaunchTime()
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

