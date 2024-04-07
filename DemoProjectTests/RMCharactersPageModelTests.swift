//
//  RMCharactersPageModelTests.swift
//  DemoProjectTests
//
//  Created by Yevgeniy Prokoshev on 07/04/2024.
//

import XCTest
@testable import DemoProject

class RMCharactersPageModelTests: XCTestCase {

	private let decoder = JSONDecoder()
	
	func test_decode_validJSON_returnsExpectedResultsCount() throws {
		let data = MockRMCharactersPageModelJSON.make()
		let sut = try decoder.decode(RMCharactersPageModel.self,
									 from: data)
		XCTAssertEqual(sut.results.count, 1)
	}
	
	func test_decode_validJSON_returnsExpectedPageInfo() throws {
		let data = MockRMCharactersPageModelJSON.make()
		let sut = try decoder.decode(RMCharactersPageModel.self,
									 from: data)
		XCTAssertEqual(sut.info.numberOfPages, 10)
		XCTAssertNotNil(sut.info.nextPage)
		XCTAssertNil(sut.info.previousPage)
		XCTAssertEqual(sut.info.resultsCount, 10)
	}
	
	func test_decode_validJSON_returnsExpectedCharacter() throws {
		let data = MockRMCharactersPageModelJSON.make()
		let sut = try decoder.decode(RMCharactersPageModel.self,
									 from: data)
		
		XCTAssertEqual(sut.results.count, 1)
		let firstCharacter = try XCTUnwrap(sut.results.last)
		XCTAssertEqual(firstCharacter.id, 1)
		XCTAssertEqual(firstCharacter.name, "Rick Sanchez")
		XCTAssertEqual(firstCharacter.status, .alive)
		XCTAssertEqual(firstCharacter.species, "Human")
		XCTAssertEqual(firstCharacter.gender, .male)
		XCTAssertNotNil(firstCharacter.image)
	}
	
	func test_decode_malformedJSON_shouldThrow_dataCorruptedError() throws {
		let data = MockRMCharactersPageModelJSON.makeMalformed()
		do {
			_ = try decoder.decode(RMCharactersPageModel.self,
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
	
	func test_decode_missingKeyJSON_shouldThrow_keyNotFoundError() throws {
		let data = MockRMCharactersPageModelJSON.makeMissingKeyJSON()
		do {
			_ = try decoder.decode(RMCharactersPageModel.self,
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
