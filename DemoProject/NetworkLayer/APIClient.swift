//
//  APIClient.swift
//  DemoProject
//
//  Created by Yevgeniy Prokoshev on 13/01/2023.
//

import Combine
import Foundation

// TODO: Refactor to use async/await

protocol APIClient {
	func send<Response>(
		request: Request<Response>
	) -> AnyPublisher<Response, Error>
}

