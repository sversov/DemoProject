//
//  APIClient.swift
//  DemoProject
//
//  Created by Yevgeniy Prokoshev on 13/01/2023.
//

import Combine
import Foundation

protocol APIClient {
	func send<Response>(
		request: Request<Response>
	) -> AnyPublisher<Response, Error>
}

