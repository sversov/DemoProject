//
//  CharacterDetailsViewModel.swift
//  DemoProject
//
//  Created by Yevgeniy Prokoshev on 07/04/2024.
//

import Foundation

class CharacterDetailsViewModel: ObservableObject {
	
	private let character: CharactersPage.Character
	
	init(character: CharactersPage.Character) {
		self.character = character
	}
	
	var name: String {
		return character.name
	}
	
	var gender: CharactersPage.Character.Gender {
		return character.gender
	}
	
	var image: URL? {
		return character.image
	}
	
	var status: CharactersPage.Character.Status {
		return character.status
	}
	
	var species: String {
		return character.species
	}
	
	var origin: CharactersPage.Character.Origin? {
		return character.origin
	}
	
	var location: CharactersPage.Character.Location? {
		return character.location
	}
}

extension CharactersPage.Character.Gender {
	
	var emoji: String {
		switch self {
			case .male: "🧔🏻‍♂️"
			case .female: "👩🏻‍🦰"
			case .genderless: "😀"
			case .unknown: "⁉️"
		}
	}
}


