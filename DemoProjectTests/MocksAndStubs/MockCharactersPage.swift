//
//  MockCharactersPage.swift
//  DemoProjectTests
//
//  Created by Yevgeniy Prokoshev on 15/01/2023.
//

import Foundation
@testable import DemoProject

extension CharactersPage {
	
	enum Mock {
		static func make() -> CharactersPage {
			CharactersPage.make()
		}
	}
}

extension CharactersPage.Page: Equatable {
	public static func == (
		lhs: CharactersPage.Page,
		rhs: CharactersPage.Page
	) -> Bool {
		lhs.numberOfPages == rhs.numberOfPages &&
		lhs.resultsCount == rhs.resultsCount &&
		lhs.nextPage == rhs.nextPage &&
		lhs.previousPage == rhs.previousPage
	}
}
