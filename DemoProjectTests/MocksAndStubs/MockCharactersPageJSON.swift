	//
	//  MockCharactersPageJSON.swift
	//  DemoProjectTests
	//
	//  Created by Yevgeniy Prokoshev on 07/04/2024.
	//

import XCTest

enum MockCharactersPageJSON {
	
	static func make() -> Data {
		let jsonString = pageJSON
		let data = jsonString.data(using: .utf8)!
		return data
	}
	
	static func makeMalformed() -> Data {
		let jsonString = "{\"malformed\"}"
		return jsonString.data(using: .utf8)!
	}
	
	static func makeMissingKeyJSON() -> Data {
		let jsonString = missingPageInfoKeyJSON
		return jsonString.data(using: .utf8)!
	}
}


private extension MockCharactersPageJSON {
	
	static let pageJSON = """
 {
 "info": {
  "count": 10,
  "pages": 10,
  "next": "https://rickandmortyapi.com/api/location/1",
  "prev": null
 },
 "results": [
  {
   "id": 1,
   "name": "Rick Sanchez",
   "status": "Alive",
   "species": "Human",
   "type": "",
   "gender": "Male",
   "origin": {
 "name": "Earth (C-137)",
 "url": "https://rickandmortyapi.com/api/location/1"
   },
   "location": {
 "name": "Citadel of Ricks",
 "url": "https://rickandmortyapi.com/api/location/3"
   },
   "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
   "episode": [
 "https://rickandmortyapi.com/api/episode/1",
   ],
   "url": "https://rickandmortyapi.com/api/character/1",
   "created": "2017-11-04T18:48:46.250Z"
  }
  ]
 }
 """
	
	static let missingPageInfoKeyJSON = """
 {
 "results": [
  {
   "id": 1,
   "name": "Rick Sanchez",
   "status": "Alive",
   "species": "Human",
   "type": "",
   "gender": "Male",
   "origin": {
  "name": "Earth (C-137)",
  "url": "https://rickandmortyapi.com/api/location/1"
   },
   "location": {
  "name": "Citadel of Ricks",
  "url": "https://rickandmortyapi.com/api/location/3"
   },
   "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
   "episode": [
  "https://rickandmortyapi.com/api/episode/1",
   ],
   "url": "https://rickandmortyapi.com/api/character/1",
   "created": "2017-11-04T18:48:46.250Z"
  }
  ]
 }
 """
}
