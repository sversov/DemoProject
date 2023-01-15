//
//  BeerDetailsViewModelTests.swift
//  DemoProjectTests
//
//  Created by Yevgeniy Prokoshev on 15/01/2023.
//

import XCTest
@testable import DemoProject
import SwiftUI

class BeerDetailsViewModelTests: XCTestCase {
	
	func test_init_shouldConvertABVAndIBUIntoStringRepresentation() {
		let ABV: Float = 5.50
		let IBU: Float = 55.0
		
		let beer = Beer.Mock.makeSingleBeer(abv: ABV, ibu: IBU)
		let sut = makeSUT(beer: beer)
	
		XCTAssertEqual(sut.abv, "5.5")
		XCTAssertEqual(sut.ibu, "55.0")
	}
	
	func test_init_withNilIBU_shouldReturnNilIBUIntoString() {
		
		let beer = Beer.Mock.makeSingleBeer(ibu: nil)
		let sut = makeSUT(beer: beer)
		
		XCTAssertNil(sut.ibu)
	}
}

extension BeerDetailsViewModelTests {
	
	func makeSUT(beer: Beer) -> BeerDetailsViewModel {
		return BeerDetailsViewModel(beer: beer)
	}
}
