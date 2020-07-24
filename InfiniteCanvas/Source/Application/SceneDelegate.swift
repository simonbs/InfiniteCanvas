//
//  SceneDelegate.swift
//  InfiniteCanvas
//
//  Created by Simon Støvring on 20/07/2020.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = CanvasViewController()
        window?.makeKeyAndVisible()
    }
}

