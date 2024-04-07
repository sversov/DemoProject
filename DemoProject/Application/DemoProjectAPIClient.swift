//
//  DemoProjectAPIClient.swift
//  DemoProject
//
//  Created by Yevgeniy Prokoshev on 05/04/2024.
//

import Foundation
import Combine

struct DemoProjectAPIClient: APIClient {
	
	enum HTTPError: Error {
		case serverSideError(Int)
	}
	
	enum DecodingError: Error {
		case decodingError(String)
	}
	
	let baseURL: String
	let session: URLSession
	
	func send<Response>(
		request: Request<Response>
	) -> AnyPublisher<Response, Error> {
		
		guard let request = request.asURLRequest(baseURL: baseURL)
		else {
			return Fail(error: URLError(.badURL))
				.eraseToAnyPublisher()
		}
		return send(request: request)
	}
	
	private func send<Response: Decodable>(
		request: URLRequest
	) -> AnyPublisher<Response, Error> {
		
		session.dataTaskPublisher(for: request)
			.tryMap { data, response in
				if let response = response as? HTTPURLResponse,
				   (200...299).contains(response.statusCode) == false {
					throw HTTPError.serverSideError(response.statusCode)
				}
				return data
			}
			.decode(type: Response.self,
					decoder: JSONDecoder())
			.mapError({ error in
				return DecodingError
					.decodingError(error.localizedDescription)
			})
			.eraseToAnyPublisher()
	}
}
