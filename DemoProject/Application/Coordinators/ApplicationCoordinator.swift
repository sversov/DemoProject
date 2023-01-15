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
		let viewController = makeBeerListView()
		navigationController.viewControllers = [viewController]
		window.rootViewController = navigationController
		window.makeKeyAndVisible()
	}
	
	private func pushBeerDetails(beer: Beer) {
		let viewController = makeBeerDetailsView(beer: beer)
		navigationController.pushViewController(viewController,
												animated: true)
	}
}

extension ApplicationCoordinator {
	
	func makeBeerListView() -> UIViewController {
		let model = BeersListViewModel(apiClient: PunkAPIClient(baseURL: "https://api.punkapi.com/v2",
																session: .shared))
		let view = BeersListView(viewModel: model,
								 onBeerSelection: pushBeerDetails)
			.navigationBarTitleDisplayMode(.inline)
			.navigationTitle(model.title)
		
		return UIHostingController(rootView: view)
	}
	
	func makeBeerDetailsView(beer: Beer)  -> UIViewController {
		let model = BeerDetailsViewModel(beer: beer)
		let view = BeerDetailsView(viewModel: model)
			.navigationBarTitleDisplayMode(.inline)
			.navigationTitle(model.title)
		return UIHostingController(rootView: view)
	}
}
