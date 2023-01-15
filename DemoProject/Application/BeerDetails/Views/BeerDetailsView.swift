//
//  BeerDetailsView.swift
//  DemoProject
//
//  Created by Yevgeniy Prokoshev on 14/01/2023.
//

import SwiftUI

struct BeerDetailsView: View {
	
	let viewModel: BeerDetailsViewModel
	
	var body: some View {
		ScrollView {
			VStack {
				ZStack {
					Color.clear
					VStack {
						HStack(spacing: 10) {
							propertyView(title: "ABV",
										 text: viewModel.abv,
										 color: .green)
							if let ibu = viewModel.ibu {
								propertyView(title: "IBU",
											 text: ibu,
											 color: .orange)
							}
						}
						.padding()
						.frame(maxWidth: .infinity,
							   alignment: .leading)
						headerView(imageURL: viewModel.imageURL,
								   title: viewModel.beerName,
								   subtitle: viewModel.tagline)
					}
				}
			}
			VStack(alignment: .leading,
				   spacing: 8) {
				descriptionView(title: "Description",
								body: viewModel.beerDescription)
				descriptionView(title: "Tips",
								body: viewModel.brewersTips)
			}
		}
	}
}

private extension BeerDetailsView {
	
	@ViewBuilder
	func headerView(imageURL: URL?,
					title: String,
					subtitle: String) -> some View {
		VStack {
			if let imageURL = imageURL {
				BeerProfileImage(url: imageURL)
					.aspectRatio(contentMode: .fit)
					.frame(height: 300,
						   alignment: .center)
			} else {
				Text("🍻")
					.font(.system(size: 80))
					.frame(height: 300,
						   alignment: .center)
			}
			Text(title)
				.font(.largeTitle)
				.bold()
				.foregroundColor(.black)
				.frame(maxWidth: .infinity,
					   alignment: .leading)
			Text(subtitle)
				.font(.headline)
				.bold()
				.foregroundColor(.cyan)
				.frame(maxWidth: .infinity,
					   alignment: .leading)
		}.padding(6)
	}
	
	@ViewBuilder
	func descriptionView(title: String,
						 body: String) -> some View {
		ZStack {
			Rectangle()
				.foregroundColor(.cyan.opacity(0.8))
			Text(title)
				.frame(maxWidth: .infinity,
					   alignment: .leading)
				.font(.title2)
				.padding(8)
		}
		Text(body)
			.padding(8)
	}
	
	func propertyView(title: String,
					  text: String,
					  color: Color) -> some View {
		VStack(spacing: 5) {
			Text(title)
				.font(.caption)
				.bold()
				.foregroundColor(color)
			Text(text)
				.font(.caption)
				.bold()
				.foregroundColor(.black)
				.padding()
				.background(.cyan)
				.clipShape(Circle())
		}
	}
}

#if DEBUG
struct BeerDetailsView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			BeerDetailsView(viewModel: BeerDetailsViewModel(beer: Beer.makePreviewModel()))
			BeerDetailsView(viewModel: BeerDetailsViewModel(beer: Beer.makePreviewModel(imageURL: nil)))
			BeerDetailsView(viewModel: BeerDetailsViewModel(beer: Beer.makePreviewModel(ibu: nil)))
		}
	}
}
#endif
