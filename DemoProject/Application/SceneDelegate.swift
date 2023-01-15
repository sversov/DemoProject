//
//  SceneDelegate.swift
//  DemoProject
//
//  Created by Yevgeniy Prokoshev on 13/01/2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	private var applicationCoordinator: Coordinator?
	
	func scene(_ scene: UIScene,
			   willConnectTo session: UISceneSession,
			   options connectionOptions: UIScene.ConnectionOptions) {
		
		guard let scene = (scene as? UIWindowScene) else { return }
		let window = UIWindow(windowScene: scene)
		applicationCoordinator = ApplicationCoordinator(window: window)
		applicationCoordinator?.start()
	}
	
}

