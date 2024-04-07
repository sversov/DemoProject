//
//  ApplicationCoordinator.swift
//  DemoProject
//
//  Created by Yevgeniy Prokoshev on 13/01/2023.
//

import Foundation
import UIKit
import SwiftUI


class ApplicationCoordinator: Coordinator {
	
	private let window: UIWindow
	private let navigationController: UINavigationController
	
	init(window: UIWindow,
		 navigationController: UINavigationController = UINavigationController()) {
		self.window = window
		self.navigationController = navigationController
	}
	
	func start() {
		let viewController = makeCharactersListView()
		navigationController.viewControllers = [viewController]
		window.rootViewController = navigationController
		window.makeKeyAndVisible()
	}
	
	private func pushCharacterDetails(for character: RMCharactersPageModel.RMCharacter) {
		let view = makeCharacterDetailsView(for: character)
		navigationController.pushViewController(view,
												animated: true)
	}
	
}

extension ApplicationCoordinator {
	
	func makeCharactersListView() -> UIViewController {
		let model = CharactersListViewModel(
			apiClient: DemoProjectAPIClient(
				baseURL: "https://rickandmortyapi.com/api",
				session: .shared))
		let view = CharactersListView(
			viewModel: model,
			onSelection: { [weak self] character in
				self?.pushCharacterDetails(for: character)
			})
			.navigationTitle(model.title)
			.navigationBarTitleDisplayMode(.large)
		
		return UIHostingController(rootView: view)
	}
	
	func makeCharacterDetailsView(
		for character: RMCharactersPageModel.RMCharacter
	) -> UIViewController {
		let model = CharacterDetailsViewModel(character: character)
		let view = CharacterDetailsView(model: model)
			.navigationTitle(model.name)
		return UIHostingController(rootView: view)
	}
}
