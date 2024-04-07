//
//  RMCharacterModel.swift
//  DemoProject
//
//  Created by Yevgeniy Prokoshev on 07/04/2024.
//

import Foundation

/*
 {
 "info": {
 "count": 826,
 "pages": 42,
 "next": "https://rickandmortyapi.com/api/character/?page=2",
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
 "name": "Earth",
 "url": "https://rickandmortyapi.com/api/location/1"
 },
 "location": {
 "name": "Earth",
 "url": "https://rickandmortyapi.com/api/location/20"
 },
 "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
 "episode": [
 "https://rickandmortyapi.com/api/episode/1",
 "https://rickandmortyapi.com/api/episode/2",
 // ...
 ],
 "url": "https://rickandmortyapi.com/api/character/1",
 "created": "2017-11-04T18:48:46.250Z"
 },
 // ...
 ]
 }
 */

struct RMCharactersPageModel: Decodable {
	
	struct Page: Decodable {
		let resultsCount: Int
		let numberOfPages: Int
		let nextPage: URL?
		let previousPage: URL?
	}
	
	struct RMCharacter: Decodable, Identifiable {
		
		struct Origin: Decodable {
			let name: String?
			let url: URL?
		}
		
		struct Location: Decodable {
			let name: String?
			let url: URL?
		}
		
		enum Status: String, Decodable {
			case alive = "Alive"
			case dead = "Dead"
			case unknown = "unknown"
		}
		
		enum Gender: String, Decodable, CaseIterable {
			case male = "Male"
			case female = "Female"
			case genderless = "Genderless"
			case unknown = "unknown"
		}
		
		let id: Int
		let name: String
		let status: Status
		let species: String
		let gender: Gender
		let origin: Origin?
		let location: Location?
		let image: URL?
	}
	
	let info: Page
	let results: [RMCharacter]
}


extension RMCharactersPageModel.Page {
	
	enum CodingKeys: String, CodingKey{
		case resultsCount = "count"
		case numberOfPages = "pages"
		case nextPage = "next"
		case previousPage = "prev"
	}
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		self.resultsCount = try values.decode(Int.self, forKey: .resultsCount)
		self.numberOfPages = try values.decode(Int.self, forKey: .numberOfPages)
		self.nextPage = try? values.decodeIfPresent(URL.self, forKey: .nextPage)
		self.previousPage = try? values.decodeIfPresent(URL.self, forKey: .previousPage)
	}
}


extension RMCharactersPageModel.RMCharacter.Origin {
	
	enum CodingKeys: String, CodingKey{
		case name
		case url
	}
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		self.name = try? values.decodeIfPresent(String.self, forKey: .name)
		self.url = try? values.decodeIfPresent(URL.self, forKey: .url)
	}
}

extension RMCharactersPageModel.RMCharacter.Location {
	
	enum CodingKeys: String, CodingKey{
		case name
		case url
	}
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		self.name = try? values.decodeIfPresent(String.self, forKey: .name)
		self.url = try? values.decodeIfPresent(URL.self, forKey: .url)
	}
}

extension RMCharactersPageModel {
	
	static func make() -> RMCharactersPageModel {
		return RMCharactersPageModel(
			info: .make(),
			results: .make(count: 10))
	}
}
 
extension RMCharactersPageModel.RMCharacter {
	static func make(
		name: String = UUID().uuidString,
		species: String = UUID().uuidString,
		status: RMCharactersPageModel.RMCharacter.Status = .alive,
		gender: RMCharactersPageModel.RMCharacter.Gender = .male,
		image: URL? = URL(string: "https://rickandmortyapi.com/api/character/avatar/3.jpeg")
	) -> RMCharactersPageModel.RMCharacter {
		RMCharactersPageModel.RMCharacter(
			id: UUID().hashValue,
			name: name,
			status: status,
			species: species,
			gender: gender,
			origin: .make(),
			location: .make(),
			image: image)
	}
}

private extension RMCharactersPageModel.Page {
	static func make() -> RMCharactersPageModel.Page {
		RMCharactersPageModel.Page(
			resultsCount: 10,
			numberOfPages: 10,
			nextPage: nil,
			previousPage: nil)
	}
}

private extension RMCharactersPageModel.RMCharacter.Origin {
	static func make() -> RMCharactersPageModel.RMCharacter.Origin {
		RMCharactersPageModel.RMCharacter.Origin(
			name: "Origin Name",
			url: nil)
	}
}

private extension RMCharactersPageModel.RMCharacter.Location {
	static func make() -> RMCharactersPageModel.RMCharacter.Location {
		RMCharactersPageModel.RMCharacter.Location(
			name: "Location Name",
			url: nil)
	}
}

private extension Array where Element == RMCharactersPageModel.RMCharacter {
	static func make(count: Int) -> [RMCharactersPageModel.RMCharacter] {
		let result = (0...count).map { _ in
			return RMCharactersPageModel.RMCharacter.make()
		}
		return result
	}
}
