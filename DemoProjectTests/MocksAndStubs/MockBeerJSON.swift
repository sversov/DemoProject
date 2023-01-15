//
//  MockBeerJSON.swift
//  DemoProjectTests
//
//  Created by Yevgeniy Prokoshev on 15/01/2023.
//

import XCTest

enum MockBeerJSON {
	
	static func make(amount: Int) -> Data {
		let beersArray = Array(repeating: beerJSON,
							   count: amount)
			.joined(separator: ",")
									
		let jsonString = "[\(beersArray)]"
		let data = jsonString.data(using: .utf8)!
		return data
	}
	
	static func makeMalformed() -> Data {
		let jsonString = "{\"malformed\"}"
		return jsonString.data(using: .utf8)!
	}
	
	static func makeMissingKeyJSON() -> Data {
		let jsonString = "[\(MockBeerJSON.missingNameKeyJSON)]"
		return jsonString.data(using: .utf8)!
	}
}


private extension MockBeerJSON {
	static let missingNameKeyJSON = """
 {
   "id":1,
   "tagline":"A Real Bitter Experience.",
   "first_brewed":"09/2007",
   "description":"A light, crisp and bitter IPA brewed with English and American hops",
   "image_url":"https://images.punkapi.com/v2/keg.png",
   "abv":4.5,
   "ibu":60,
   "brewers_tips":"The earthy and floral aromas from the hops can be overpowering.",
 }
 """
	static let beerJSON = """
 {
   "id":1,
   "name":"Buzz",
   "tagline":"A Real Bitter Experience.",
   "first_brewed":"09/2007",
   "description":"A light, crisp and bitter IPA brewed with English and American hops",
   "image_url":"https://images.punkapi.com/v2/keg.png",
   "abv":4.5,
   "ibu":60,
   "brewers_tips":"The earthy and floral aromas from the hops can be overpowering.",
 }
 """
}
