//
//  SceneDelegate.swift
//  Numbers
//
//  Created by Tatiana Sosina on 06.07.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  var coordinator: Coordinator?
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let scene = scene as? UIWindowScene else { return }
    let window = UIWindow(windowScene: scene)
    let coordinator = RootCoordinator(window: window)
    coordinator.start()
    self.coordinator = coordinator
    self.window = window
  }
}
