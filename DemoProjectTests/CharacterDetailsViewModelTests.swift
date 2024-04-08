//
//  CharacterDetailsViewModelTests.swift
//  DemoProjectTests
//
//  Created by Yevgeniy Prokoshev on 07/04/2024.
//

import XCTest
@testable import DemoProject

final class CharacterDetailsViewModelTests: XCTestCase {
	
	func test_init_shouldInitialiseInstanceProperty() {
		let expectedName = UUID().uuidString
		let expectedSpecies = UUID().uuidString
		let expectedStatus = CharactersPage
			.Character.Status.alive
		let expectedGender =  CharactersPage
			.Character.Gender.female
		let expectedURL = URL(string: "www.validURL.com")
		let sut = CharacterDetailsViewModel(
			character: CharactersPage
				.Character
				.make(name: expectedName,
					  species: expectedSpecies,
					  status: expectedStatus,
					  gender: expectedGender,
					  image: expectedURL))
		
		XCTAssertEqual(sut.name, expectedName)
		XCTAssertEqual(sut.status, expectedStatus)
		XCTAssertEqual(sut.species, expectedSpecies)
		XCTAssertEqual(sut.gender, expectedGender)
		XCTAssertNotNil(sut.image)
		XCTAssertNotNil(sut.origin?.name)
		XCTAssertNotNil(sut.location?.name)

	}
}
