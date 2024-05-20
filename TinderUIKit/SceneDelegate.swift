//
//  SceneDelegate.swift
//  TinderUIKit
//
//  Created by HardiB.Salih on 5/19/24.
//

import UIKit
import FirebaseAuth


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        notificationObserver()
        reloadRootViewController()

    }
    
    private func notificationObserver() {
        NotificationCenter.default.removeObserver(self, name: UserDefaults.didChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(userDefaultsDidChange), name: UserDefaults.didChangeNotification, object: nil)
    }
    
    private func reloadRootViewController() {
        let rootViewController: UIViewController
        
        if FirebaseAuth.Auth.auth().currentUser != nil {
            //            let vc = TabBarController()
            //            rootViewController = vc
            
            //             if need to add a single view insted of TabBarController.
            let vc = HomeController()
            let navVC = UINavigationController(rootViewController: vc)
            let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            vc.navigationItem.backBarButtonItem = backButtonItem
            navVC.navigationBar.tintColor = .link
            rootViewController = navVC
        } else {
            let vc = LoginViewController()
            let navVC = UINavigationController(rootViewController: vc)
            let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            vc.navigationItem.backBarButtonItem = backButtonItem
            navVC.navigationBar.tintColor = .link
            rootViewController = navVC
        }
        
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }
    
    //MARK: -OBJC
    @objc private func userDefaultsDidChange() {
        reloadRootViewController()
    }
    

    
    
    
    
    func sceneDidDisconnect(_ scene: UIScene) { }
    func sceneDidBecomeActive(_ scene: UIScene) { }
    func sceneWillResignActive(_ scene: UIScene) { }
    func sceneWillEnterForeground(_ scene: UIScene) { }
    func sceneDidEnterBackground(_ scene: UIScene) { }
}

