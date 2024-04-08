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

struct CharactersPage: Decodable {
	
	struct Page: Decodable {
		let resultsCount: Int
		let numberOfPages: Int
		let nextPage: URL?
		let previousPage: URL?
	}
	
	struct Character: Decodable, Identifiable {
		
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
	let results: [Character]
}


extension CharactersPage.Page {
	
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


extension CharactersPage.Character.Origin {
	
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

extension CharactersPage.Character.Location {
	
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

extension CharactersPage {
	
	static func make() -> CharactersPage {
		return CharactersPage(
			info: .make(),
			results: .make(count: 10))
	}
}
 
extension CharactersPage.Character {
	static func make(
		name: String = UUID().uuidString,
		species: String = UUID().uuidString,
		status: CharactersPage.Character.Status = .alive,
		gender: CharactersPage.Character.Gender = .male,
		image: URL? = URL(string: "https://rickandmortyapi.com/api/character/avatar/3.jpeg")
	) -> CharactersPage.Character {
		CharactersPage.Character(
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

private extension CharactersPage.Page {
	static func make() -> CharactersPage.Page {
		CharactersPage.Page(
			resultsCount: 10,
			numberOfPages: 10,
			nextPage: nil,
			previousPage: nil)
	}
}

private extension CharactersPage.Character.Origin {
	static func make() -> CharactersPage.Character.Origin {
		CharactersPage.Character.Origin(
			name: "Origin Name",
			url: nil)
	}
}

private extension CharactersPage.Character.Location {
	static func make() -> CharactersPage.Character.Location {
		CharactersPage.Character.Location(
			name: "Location Name",
			url: nil)
	}
}

private extension Array where Element == CharactersPage.Character {
	static func make(count: Int) -> [CharactersPage.Character] {
		let result = (0...count).map { _ in
			return CharactersPage.Character.make()
		}
		return result
	}
}
