//
//  Beer.swift
//  DemoProject
//
//  Created by Yevgeniy Prokoshev on 13/01/2023.
//

import Foundation

/*
 {
 "drinks": [
 {
 "idDrink": "11007",
 "strDrink": "Margarita",
 "strDrinkAlternate": null,
 "strTags": "IBA,ContemporaryClassic",
 "strVideo": null,
 "strCategory": "Ordinary Drink",
 "strIBA": "Contemporary Classics",
 "strAlcoholic": "Alcoholic",
 "strGlass": "Cocktail glass",
 "strInstructions": "Rub the rim of the glass with the lime slice to make the salt stick to it. Take care to moisten only the outer rim and sprinkle the salt on it. The salt should present to the lips of the imbiber and never mix into the cocktail. Shake the other ingredients with ice, then carefully pour into the glass.",
 "strInstructionsES": null,
 "strInstructionsDE": "Reiben Sie den Rand des Glases mit der Limettenscheibe, damit das Salz daran haftet. Achten Sie darauf, dass nur der \u00e4u\u00dfere Rand angefeuchtet wird und streuen Sie das Salz darauf. Das Salz sollte sich auf den Lippen des Genie\u00dfers befinden und niemals in den Cocktail einmischen. Die anderen Zutaten mit Eis sch\u00fctteln und vorsichtig in das Glas geben.",
 "strInstructionsFR": null,
 "strInstructionsIT": "Strofina il bordo del bicchiere con la fetta di lime per far aderire il sale.\r\nAvere cura di inumidire solo il bordo esterno e cospargere di sale.\r\nIl sale dovrebbe presentarsi alle labbra del bevitore e non mescolarsi mai al cocktail.\r\nShakerare gli altri ingredienti con ghiaccio, quindi versarli delicatamente nel bicchiere.",
 "strInstructionsZH-HANS": null,
 "strInstructionsZH-HANT": null,
 "strDrinkThumb": "https:\/\/www.thecocktaildb.com\/images\/media\/drink\/5noda61589575158.jpg",
 "strIngredient1": "Tequila",
 "strIngredient2": "Triple sec",
 "strIngredient3": "Lime juice",
 "strIngredient4": "Salt",
 "strIngredient5": null,
 "strIngredient6": null,
 "strIngredient7": null,
 "strIngredient8": null,
 "strIngredient9": null,
 "strIngredient10": null,
 "strIngredient11": null,
 "strIngredient12": null,
 "strIngredient13": null,
 "strIngredient14": null,
 "strIngredient15": null,
 "strMeasure1": "1 1\/2 oz ",
 "strMeasure2": "1\/2 oz ",
 "strMeasure3": "1 oz ",
 "strMeasure4": null,
 "strMeasure5": null,
 "strMeasure6": null,
 "strMeasure7": null,
 "strMeasure8": null,
 "strMeasure9": null,
 "strMeasure10": null,
 "strMeasure11": null,
 "strMeasure12": null,
 "strMeasure13": null,
 "strMeasure14": null,
 "strMeasure15": null,
 "strImageSource": "https:\/\/commons.wikimedia.org\/wiki\/File:Klassiche_Margarita.jpg",
 "strImageAttribution": "Cocktailmarler",
 "strCreativeCommonsConfirmed": "Yes",
 "dateModified": "2015-08-18 14:42:59"
 }
 ]
 }
 */

struct DrinkContainer: Decodable {
	let drinks: [Drink]
}

struct Drink: Decodable {
	let id: Int
	let name: String
	let tags: [String]
	let category: String?
	let glass: String?
	let isAlcoholic: Bool
	let instructions: String?
	let thumbnail: URL?
	let ingredients: [Ingredient]
	
	enum CodingKeys: String, CodingKey {
		case id = "idDrink"
		case name = "strDrink"
		case tags = "strTags"
		case category = "strCategory"
		case isAlcoholic = "strAlcoholic"
		case glass = "strGlass"
		case instructions = "strInstructions"
		case thumbnail = "strDrinkThumb"
	}
	
	struct IngredientsCodingKeys: CodingKey {
		var stringValue: String
		var intValue: Int?
		init?(stringValue: String) {
			self.stringValue = stringValue
		}
		
		init?(intValue: Int) {
			self.stringValue = "\(intValue)"
			self.intValue = intValue
		}
	}
	
	struct Ingredient {
		let name: String
		let measure: String?
	}
	
	init(from decoder: Decoder) throws {
		let drinkContainer = try decoder.container(keyedBy: CodingKeys.self)
		let ingredientsContainer = try decoder.container(keyedBy: IngredientsCodingKeys.self)
		
		self.id = try drinkContainer.decode(Int.self, forKey: .id)
		self.name = try drinkContainer.decode(String.self, forKey: .name)
		let tags = try drinkContainer.decode(String.self, forKey: .tags)
		self.tags = tags.components(separatedBy: ",").filter({$0.isEmpty == false })
		self.category = try drinkContainer.decode(String.self, forKey: .category)
		self.glass = try drinkContainer.decode(String.self, forKey: .glass)
		let isAlcoholic = try drinkContainer.decode(String.self, forKey: .isAlcoholic)
		self.isAlcoholic = (isAlcoholic == "Alcoholic")
		self.instructions = try drinkContainer.decode(String.self, forKey: .instructions)
		let thumbnailURLString = try drinkContainer.decode(String.self, forKey: .thumbnail)
		self.thumbnail = URL(string: thumbnailURLString)
		self.ingredients = []
	}
}
 
struct Beer: Decodable,
			 Identifiable,
			 Equatable {
	
	let id: Int
	let name: String
	let tagline: String
	let firstBrewed: String
	let beerDescription: String
	let imageURL: URL?
	let abv: Float
	let ibu: Float?
	let brewersTips: String
	
	enum CodingKeys: String, CodingKey {
		case id
		case name
		case tagline
		case firstBrewed = "first_brewed"
		case beerDescription = "description"
		case imageURL = "image_url"
		case abv
		case ibu
		case brewersTips = "brewers_tips"
	}
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		
		self.id = try values.decode(Int.self, forKey: .id)
		self.name = try values.decode(String.self, forKey: .name)
		self.tagline = try values.decode(String.self, forKey: .tagline)
		self.beerDescription = try values.decode(String.self, forKey: .beerDescription)
		self.firstBrewed = try values.decode(String.self, forKey: .firstBrewed)
		
		let imageURLString = try values.decode(String.self, forKey: .imageURL)
		self.imageURL = URL(string: imageURLString)
		self.abv = try values.decode(Float.self, forKey: .abv)
		self.ibu = try values.decodeIfPresent(Float.self, forKey: .ibu)
		self.brewersTips =  try values.decode(String.self, forKey: .brewersTips)
	}
	
	init(id: Int = UUID().hashValue,
		 name: String,
		 tagline: String,
		 firstBrewed: String,
		 beerDescription: String,
		 imageURL: URL?,
		 abv: Float,
		 ibu: Float?,
		 brewersTips: String) {
		self.id = id
		self.name = name
		self.tagline = tagline
		self.firstBrewed = firstBrewed
		self.beerDescription = beerDescription
		self.imageURL = imageURL
		self.abv = abv
		self.ibu = ibu
		self.brewersTips = brewersTips
	}
}

#if DEBUG
extension Beer {
	
	static func makePreviewModel(
		name: String =  "Pilsen Lager",
		tagline: String = "Unleash the Yeast Series.",
		firstBrewed: String = "09/2013",
		beerDescription: String = "Our Unleash the Yeast series was an epic experiment into the differences in aroma and flavour provided by switching up your yeast. We brewed up a wort with a light caramel note and some toasty biscuit flavour, and hopped it with Amarillo and Centennial for a citrusy bitterness. Everything else is down to the yeast. Pilsner yeast ferments with no fruity esters or spicy phenols, although it can add a hint of butterscotch.",
		imageURL: URL? = URL(string: "https://images.punkapi.com/v2/4.png"),
		abv: Float = 6.3,
		ibu: Float? = 55,
		brewersTips: String = "Play around with the fermentation temperature to get the best flavour profile from the individual yeasts."
	) -> Beer {
		
		return Beer(name: name,
					tagline: tagline,
					firstBrewed: firstBrewed,
					beerDescription: beerDescription ,
					imageURL: imageURL,
					abv: abv,
					ibu: ibu,
					brewersTips: brewersTips)
	}
}
#endif
