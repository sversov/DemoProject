//
//  Request+CRUD.swift
//  DemoProject
//
//  Created by Yevgeniy Prokoshev on 13/01/2023.
//

import Foundation

extension Request {
	public static func get(
		_ path: String,
		query: [String: String]? = nil
	) -> Request {
		Request(method: "GET",
				path: path,
				query: query)
	}
}
