//
//  SceneDelegate.swift
//  MoviesList
//
//  Created by Fábio Lenzi on 18/08/20.
//  Copyright © 2020 Fábio Lenzi. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = MoviesListView()
        window?.makeKeyAndVisible()
    }
}
