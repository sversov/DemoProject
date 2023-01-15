//
//  Request.swift
//  DemoProject
//
//  Created by Yevgeniy Prokoshev on 13/01/2023.
//

import Foundation

struct Request<Response: Decodable> {
	var method: String
	var path: String
	var headers: [String: String]?
	var query: [String: String]?
}

extension Request {
	
	func asURLRequest(baseURL: String) -> URLRequest? {
		guard let url = makeURL(baseURL: baseURL)
		else { return nil }
		return makeRequest(from: url)
	}
	
	private func makeURL(baseURL: String) -> URL? {
		guard var components = URLComponents(string: baseURL)
		else { return nil }
		
		components.path = "\(components.path)\(path)"
		if let query = query {
			components.queryItems = query.map(URLQueryItem.init)
		}
		
		guard let url = components.url
		else { return nil }
		
		return url
	}
	
	private func makeRequest(from url: URL) -> URLRequest {
		var request = URLRequest(url: url)
		request.httpMethod = method
		request.allHTTPHeaderFields = headers
		return request
	}
}
