//
//  BeerDetailsViewModel.swift
//  DemoProject
//
//  Created by Yevgeniy Prokoshev on 14/01/2023.
//

import Foundation


class BeerDetailsViewModel {

	// MARK: - Properties -
	// MARK: Internal
	let title: String
	let beerName: String
	let beerDescription: String
	let imageURL: URL?
	let tagline: String
	let abv: String
	let ibu: String?
	let brewersTips: String

	// MARK: Private
	private let beer: Beer
	
	init(beer: Beer) {
		self.beer = beer
		self.title = beer.name
		self.beerName = beer.name
		self.beerDescription = beer.beerDescription
		self.imageURL = beer.imageURL
		self.tagline = beer.tagline
		self.abv = String(format: "%.1f", beer.abv)
		
		self.ibu = beer.ibu.map { String(format: "%.1f", $0) }
		self.brewersTips = beer.brewersTips
	}
	
}
