//
//  Beer.swift
//  DemoProject
//
//  Created by Yevgeniy Prokoshev on 13/01/2023.
//

import Foundation

/*
 [{"id":4,
 "name":"Pilsen Lager",
 "tagline":"Unleash the Yeast Series.",
 "first_brewed":"09/2013",
 "description":"Our Unleash the Yeast series was an epic experiment into the differences in aroma and flavour provided by switching up your yeast. We brewed up a wort with a light caramel note and some toasty biscuit flavour, and hopped it with Amarillo and Centennial for a citrusy bitterness. Everything else is down to the yeast. Pilsner yeast ferments with no fruity esters or spicy phenols, although it can add a hint of butterscotch.",
 "image_url":"https://images.punkapi.com/v2/4.png",
 "abv":6.3,
 "ibu":55,
 "target_fg":1012,
 "target_og":1060,
 "ebc":30,
 "srm":15,
 "ph":4.4,
 "attenuation_level":80,
 "volume":{
 "value":20,
 "unit":"litres"
 },
 "boil_volume":{
 "value":25,
 "unit":"litres"
 },
 "method":{
 "mash_temp":[
 {
 "temp":{
 "value":65,
 "unit":"celsius"
 },
 "duration":null
 }
 ],
 "fermentation":{
 "temp":{
 "value":9,
 "unit":"celsius"
 }
 },
 "twist":null
 },
 "ingredients":{
 "malt":[
 {
 "name":"Extra Pale",
 "amount":{
 "value":4.58,
 "unit":"kilograms"
 }
 },
 {
 "name":"Caramalt",
 "amount":{
 "value":0.25,
 "unit":"kilograms"
 }
 },
 {
 "name":"Dark Crystal",
 "amount":{
 "value":0.06,
 "unit":"kilograms"
 }
 },
 {
 "name":"Munich",
 "amount":{
 "value":0.25,
 "unit":"kilograms"
 }
 }
 ],
 "hops":[
 {
 "name":"Centennial",
 "amount":{
 "value":5,
 "unit":"grams"
 },
 "add":"start",
 "attribute":"bitter"
 },
 {
 "name":"Amarillo",
 "amount":{
 "value":5,
 "unit":"grams"
 },
 "add":"start",
 "attribute":"bitter"
 },
 {
 "name":"Centennial",
 "amount":{
 "value":10,
 "unit":"grams"
 },
 "add":"middle",
 "attribute":"flavour"
 },
 {
 "name":"Amarillo",
 "amount":{
 "value":10,
 "unit":"grams"
 },
 "add":"middle",
 "attribute":"flavour"
 },
 {
 "name":"Centennial",
 "amount":{
 "value":17.5,
 "unit":"grams"
 },
 "add":"end",
 "attribute":"flavour"
 },
 {
 "name":"Amarillo",
 "amount":{
 "value":17.5,
 "unit":"grams"
 },
 "add":"end",
 "attribute":"flavour"
 }
 ],
 "yeast":"Wyeast 2007 - Pilsen Lager™"
 },
 "food_pairing":[
 "Spicy crab cakes",
 "Spicy cucumber and carrot Thai salad",
 "Sweet filled dumplings"
 ],
 "brewers_tips":"Play around with the fermentation temperature to get the best flavour profile from the individual yeasts.",
 "contributed_by":"Ali Skinner <AliSkinner>"
 },]

 */

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
