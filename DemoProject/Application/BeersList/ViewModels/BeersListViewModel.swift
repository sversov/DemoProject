//
//  BeersListViewModel.swift
//  DemoProject
//
//  Created by Yevgeniy Prokoshev on 13/01/2023.
//

import Foundation
import Combine

class BeersListViewModel: ObservableObject {
	
	enum State {
		case idle
		case loading
		case error(Error)
		case loaded([Beer])
	}
	
	// MARK: - Properties -
	// MARK: Internal
	
	let title: String = "Brew Dog Beers"
	@Published private(set) var state: State = .idle

	// MARK: Private
	private let apiClient: APIClient
	private var cancellables: Set<AnyCancellable> = []
	
	init(apiClient: APIClient) {
		self.apiClient = apiClient
	}
	
	// MARK: - Methods -
	// MARK: Internal

	func fetchBeers() {
		state = .loading
		let listRequest = Request<[Beer]>.get("/beers")
		
		apiClient.send(request: listRequest)
			.receive(on: DispatchQueue.main)
			.sink { [weak self] completion in
				switch completion {
					case .failure(let error):
						self?.state = .error(error)
					case .finished: break
				}
			} receiveValue: { [weak self] items in
				self?.state = .loaded(items)
			}.store(in: &cancellables)
	}
	
}
