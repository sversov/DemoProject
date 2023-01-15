//
//  MockCreditReportInfo.swift
//  DemoProjectTests
//
//  Created by Yevgeniy Prokoshev on 15/01/2023.
//

import Foundation
@testable import DemoProject

extension Beer {
	
	enum Mock {
		
		static func make(amount: Int = 5) -> [Beer] {
			return (0..<amount).map { _ in Mock.makeSingleBeer() }
		}
		
		static func makeSingleBeer(
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
}
