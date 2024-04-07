//
//  APIClientStub.swift
//  DemoProjectTests
//
//  Created by Yevgeniy Prokoshev on 04/07/2024.
//
import Combine
@testable import DemoProject

struct APIClientStub: APIClient {
	
	private let mockResponse = RMCharactersPageModel.Mock.make()
	
	typealias PagePublisher = AnyPublisher<RMCharactersPageModel, Error>
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
		_ page: RMCharactersPageModel = RMCharactersPageModel.Mock.make()
	) -> AnyPublisher<RMCharactersPageModel, Error> {
		return Result.success(page)
			.publisher
			.eraseToAnyPublisher()
	}
	
	static func makeFailure(
		_ error: Error
	) -> AnyPublisher<RMCharactersPageModel, Error> {
		return Result.failure(error)
			.publisher
			.eraseToAnyPublisher()
	}
}

