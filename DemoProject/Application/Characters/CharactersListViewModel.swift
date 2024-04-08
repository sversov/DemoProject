//
//  CharactersListViewModel.swift
//  DemoProject
//
//  Created by Yevgeniy Prokoshev on 07/04/2024.
//

import Foundation
import Combine

class CharactersListViewModel: ObservableObject {
	
	enum State {
		case idle
		case loading
		case error(Error)
		case loaded([CharactersPage.Character])
	}
	
	@Published private(set) var state: State = .idle
	let title: String = "Characters"
	
	private let apiClient: APIClient
	private var cancellables: Set<AnyCancellable> = []
	
	init(apiClient: APIClient) {
		self.apiClient = apiClient
	}
	
	func fetchCharacters() {
		state = .loading
		let charactersRequest = Request<CharactersPage>.get("/character")
		apiClient.send(request: charactersRequest)
			.receive(on: DispatchQueue.main)
			.sink { [weak self] completion in
				switch completion {
					case .failure(let error):
						self?.state = .error(error)
					case .finished: break
				}
			} receiveValue: { [weak self] item in
				self?.state = .loaded(item.results)
			}.store(in: &cancellables)
	}
}
