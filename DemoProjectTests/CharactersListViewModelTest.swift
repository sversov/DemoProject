//
//  CharactersListViewModelTest.swift
//  DemoProjectTests
//
//  Created by Yevgeniy Prokoshev on 07/04/2024.
//

import XCTest
import Combine
@testable import DemoProject

final class CharactersListViewModelTest: XCTestCase {
	
	private var sut: CharactersListViewModel!
	private var cancellables: Set<AnyCancellable> = []
	private var mockAPIClient: APIClientStub!
	
	override func setUp() {
		super.setUp()
		mockAPIClient = APIClientStub()
		sut = CharactersListViewModel(apiClient: mockAPIClient)
	}
	
	func test_init_state_shouldSendIdleState() {
		let promise = expectation(description: #function)
		sut.$state
			.sink { state in
				XCTAssertEqual(state, .idle)
				promise.fulfill()
			}.store(in: &cancellables)
		
		wait(for: [promise], timeout: 0.5)
	}
	
	func test_init_shouldHaveExpectedTitle() {
		XCTAssertEqual(sut.title, "Characters")
	}
	
	func test_fetchCharacters_shouldSendIdleLoadingLoadedStates() {
		let promise = expectation(description: #function)
		promise.expectedFulfillmentCount = 3
		var callsCount = 0
		sut.$state
			.sink { state in
				switch (callsCount, state) {
					case (0, .idle): break
					case (1, .loading): break
					case (2, .loaded): break
					default: XCTFail(#function)
				}
				callsCount += 1
				promise.fulfill()
			}.store(in: &cancellables)
		
		sut.fetchCharacters()
		wait(for: [promise], timeout: 0.5)
	}
	
	func test_fetchCharacters_whenSuccessResponse_shouldSendLoadedState() {
		let promise = expectation(description: #function)
		let expectedResponse = CharactersPage.Mock.make()
		let sut = makeSUT(MockPublisher.makeSuccess(expectedResponse))
		sut.$state
			.dropFirst(2)
			.sink { state in
				guard case let .loaded(value) = state else {
					XCTFail(#function)
					return
				}
				XCTAssertEqual(value, expectedResponse.results)
				promise.fulfill()
			}.store(in: &cancellables)
		
		sut.fetchCharacters()
		wait(for: [promise], timeout: 0.5)
	}
	
	func test_fetchCharacters_whenFailureResponse_shouldSendErrorState() {
		let promise = expectation(description: #function)
		let expectedResponse = URLError(.networkConnectionLost)
		let sut = makeSUT(MockPublisher.makeFailure(expectedResponse))
		sut.$state
			.dropFirst(2)
			.sink { state in
				switch state {
					case .error(let error):
						XCTAssertEqual(error as? URLError, expectedResponse)
					default: XCTFail(#function)
				}
				promise.fulfill()
			}.store(in: &cancellables)
		
		sut.fetchCharacters()
		wait(for: [promise], timeout: 0.5)
	}
}

extension CharactersListViewModelTest {
	
	func makeSUT(
		_ publisher: AnyPublisher<CharactersPage, Error>
	) -> CharactersListViewModel {
		let stubApiClient = APIClientStub(publisher: publisher)
		return CharactersListViewModel(apiClient: stubApiClient)
	}
	
}

extension CharactersListViewModel.State: Equatable {
	public static func == (
		lhs: CharactersListViewModel.State,
		rhs: CharactersListViewModel.State
	) -> Bool {
		switch (lhs, rhs) {
			case (.idle, .idle): return true
			case (.loading, .loading): return true
			case (.error, .error): return true
			case (.loaded, .loaded): return true
			default: return false
		}
	}
}


extension CharactersPage.Character: Equatable {
	public static func == (
		lhs: CharactersPage.Character,
		rhs: CharactersPage.Character
	) -> Bool {
		return lhs.id == rhs.id
	}
}
