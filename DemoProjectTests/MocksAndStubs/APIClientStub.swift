//
//  APIClientStub.swift
//  DemoProjectTests
//
//  Created by Yevgeniy Prokoshev on 04/07/2024.
//
import Combine
@testable import DemoProject

struct APIClientStub: APIClient {
	
	private let mockResponse = CharactersPage.Mock.make()
	
	typealias PagePublisher = AnyPublisher<CharactersPage, Error>
	var publisher: PagePublisher = MockPublisher.makeSuccess()
	
	func send<Response>(
		request: Request<Response>
	) -> AnyPublisher<Response, Error>
	where Response: Decodable {
		return publisher
			.map({ $0 as! Response })
			.eraseToAnyPublisher()
	}
}
	
enum MockPublisher {
	
	static func makeSuccess(
		_ page: CharactersPage = CharactersPage.Mock.make()
	) -> AnyPublisher<CharactersPage, Error> {
		return Result.success(page)
			.publisher
			.eraseToAnyPublisher()
	}
	
	static func makeFailure(
		_ error: Error
	) -> AnyPublisher<CharactersPage, Error> {
		return Result.failure(error)
			.publisher
			.eraseToAnyPublisher()
	}
}

