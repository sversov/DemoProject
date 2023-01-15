//
//  APIClientStub.swift
//  DemoProjectTests
//
//  Created by Yevgeniy Prokoshev on 15/01/2023.
//
import Combine
@testable import DemoProject

struct APIClientStub: APIClient {
	
	private let mockResponse = Beer.Mock.make()
	
	typealias BeerPublisher = AnyPublisher<[Beer], Error>
	var publisher: BeerPublisher = MockPublisher.makeSuccess()
	
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
		_ beers: [Beer] = Beer.Mock.make()
	) -> AnyPublisher<[Beer], Error> {
		return Result.success(beers)
			.publisher
			.eraseToAnyPublisher()
	}
	
	static func makeFailure(
		_ error: Error
	) -> AnyPublisher<[Beer], Error> {
		return Result.failure(error)
			.publisher
			.eraseToAnyPublisher()
	}
}

