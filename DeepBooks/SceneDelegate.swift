//
//  SceneDelegate.swift
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/26.
//

import UIKit
import AppTrackingTransparency
import AdSupport
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coldStart: Bool = true

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        self.window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = self.window else { return }
        window.tag = 111111;
        window.windowScene = windowScene
        window.backgroundColor = UIColor.white
        
        if (DBCommonConfig.switchAudit()){
            window.rootViewController = DBSwitchAuditTabBarController.init()
        }else{
            window.rootViewController = DBTabBarRootController.init()
        }
      
        window.makeKeyAndVisible()
        
        let launchIV = UIImageView(frame: window.frame)
        launchIV.image = UIImage.init(named: "launchImage")
        launchIV.contentMode = .scaleAspectFill
        launchIV.clipsToBounds = true
        window.addSubview(launchIV)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            launchIV.removeFromSuperview()
        }
         
        //配置域名
        DBDomainManager.setAppConfig()
        
        for i in 1...3 {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(i*2)) {
                ATTrackingManager.requestTrackingAuthorization { status in
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

