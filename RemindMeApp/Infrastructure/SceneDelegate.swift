//
//  SceneDelegate.swift
//  RemindMeApp
//
//  Created by Tais Rocha Nogueira on 07/02/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        configNavigationBar()
        var controller: UIViewController
        if UserDefaults.standard.hasOnboarded {
            let remindersController = HomeFactory.createViewController()
            let navigationController = UINavigationController(rootViewController: remindersController)
            navigationController.view.backgroundColor = .purple
            controller = navigationController
        } else {
            controller = WelcomeViewController()
        }
       
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
    }
    
    func configNavigationBar() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().barTintColor = .purple
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().backgroundColor = .purple
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white] }
}

func sceneDidDisconnect(_ scene: UIScene) {
    
}

    func sceneDidBecomeActive(_ scene: UIScene) {
    
    }

    func sceneWillResignActive(_ scene: UIScene) {
       
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




