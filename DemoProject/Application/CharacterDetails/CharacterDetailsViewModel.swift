//
//  CharacterDetailsViewModel.swift
//  DemoProject
//
//  Created by Yevgeniy Prokoshev on 07/04/2024.
//

import Foundation

class CharacterDetailsViewModel: ObservableObject {
	
	private let character: RMCharactersPageModel.RMCharacter
	
	init(character: RMCharactersPageModel.RMCharacter) {
		self.character = character
	}
	
	var name: String {
		return character.name
	}
	
	var gender: RMCharactersPageModel.RMCharacter.Gender {
		return character.gender
	}
	
	var image: URL? {
		return character.image
	}
	
	var status: RMCharactersPageModel.RMCharacter.Status {
		return character.status
	}
	
	var species: String {
		return character.species
	}
	
	var origin: RMCharactersPageModel.RMCharacter.Origin? {
		return character.origin
	}
	
	var location: RMCharactersPageModel.RMCharacter.Location? {
		return character.location
	}
}

extension RMCharactersPageModel.RMCharacter.Gender {
	
	var emoji: String {
		switch self {
			case .male: "🧔🏻‍♂️"
			case .female: "👩🏻‍🦰"
			case .genderless: "😀"
			case .unknown: "⁉️"
		}
	}
}


