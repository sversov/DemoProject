//
//  MockCreditReportInfo.swift
//  DemoProjectTests
//
//  Created by Yevgeniy Prokoshev on 15/01/2023.
//

import Foundation
@testable import DemoProject

extension RMCharactersPageModel {
	
	enum Mock {
		static func make() -> RMCharactersPageModel {
			RMCharactersPageModel.make()
		}
	}
}

extension RMCharactersPageModel.Page: Equatable {
	public static func == (
		lhs: RMCharactersPageModel.Page,
		rhs: RMCharactersPageModel.Page
	) -> Bool {
		lhs.numberOfPages == rhs.numberOfPages &&
		lhs.resultsCount == rhs.resultsCount &&
		lhs.nextPage == rhs.nextPage &&
		lhs.previousPage == rhs.previousPage
	}
}
