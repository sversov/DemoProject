//
//  CharacterGenderTests.swift
//  DemoProjectTests
//
//  Created by Yevgeniy Prokoshev on 07/04/2024.
//

import XCTest
@testable import DemoProject

final class CharacterGenderTests: XCTestCase {
	
	func test_genderEmoji_shouldReturnExpectedEmoji() {
		
		CharactersPage.Character.Gender.allCases.forEach { sut in
			switch sut {
				case .female: XCTAssertEqual(sut.emoji, "👩🏻‍🦰")
				case .male: XCTAssertEqual(sut.emoji, "🧔🏻‍♂️")
				case .genderless: XCTAssertEqual(sut.emoji, "😀")
				case .unknown: XCTAssertEqual(sut.emoji, "⁉️")
			}
		}
	}
	
}
