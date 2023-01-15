//
//  BeerModelTests.swift
//  DemoProjectTests
//
//  Created by Yevgeniy Prokoshev on 15/01/2023.
//

import XCTest
@testable import DemoProject

class BeerModelTests: XCTestCase {

	private let decoder = JSONDecoder()
	
	func test_decode_validJSON_returnsExpectedBeersCount() throws {
		let expectedBeersCount =  3
		let data = MockBeerJSON.make(amount: expectedBeersCount)
		let sut = try decoder.decode([Beer].self,
									 from: data)
		XCTAssertEqual(sut.count, expectedBeersCount)
	}
	
	func test_decode_validJSON_returnsExpectedBeer() throws {
		let data = MockBeerJSON.make(amount: 1)
		let sut = try decoder.decode([Beer].self,
									 from: data).first
		
		XCTAssertEqual(sut?.name, "Buzz")
		XCTAssertEqual(sut?.tagline, "A Real Bitter Experience.")
		XCTAssertEqual(sut?.firstBrewed, "09/2007")
		XCTAssertEqual(sut?.beerDescription, "A light, crisp and bitter IPA brewed with English and American hops")
		XCTAssertEqual(sut?.imageURL, URL(string: "https://images.punkapi.com/v2/keg.png")!)
		XCTAssertEqual(sut?.abv, 4.5)
		XCTAssertEqual(sut?.ibu, 60)
		XCTAssertEqual(sut?.brewersTips, "The earthy and floral aromas from the hops can be overpowering.")
	}
	
	func test_decode_malformedJSON_shouldThrowDataCorruptedError() throws {
		let data = MockBeerJSON.makeMalformed()
		do {
			_ = try decoder.decode([Beer].self,
								   from: data)
			XCTFail(#function)
		} catch let error as DecodingError {
			switch error {
				case .dataCorrupted: XCTAssert(true)
				default: XCTFail(#function)
			}
		} catch {
			XCTFail(#function)
		}
	}
	
	func test_decode_missingKeyJSON_shouldThrow_() throws {
		let data = MockBeerJSON.makeMissingKeyJSON()
		do {
			_ = try decoder.decode([Beer].self,
								   from: data)
			XCTFail(#function)
		} catch let error as DecodingError {
			switch error {
				case .keyNotFound: XCTAssert(true)
				default: XCTFail(#function)
			}
		} catch {
			XCTFail(#function)
		}
	}
}
