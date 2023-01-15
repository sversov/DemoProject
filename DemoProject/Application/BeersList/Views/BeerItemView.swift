//
//  BeerItemView.swift
//  DemoProject
//
//  Created by Yevgeniy Prokoshev on 13/01/2023.
//

import SwiftUI

struct BeerItemView: View {
	
	let imageURL: URL?
	let title: String
	let firstBrewed: String
	
	var body: some View {
		ZStack {
			roundedRectangleView
			HStack(spacing: 10) {
				if let url = imageURL {
					BeerProfileImage(url: url)
						.frame(width: 60, height: 60)
						.background(Color.gray.opacity(0.4))
						.clipShape(Circle())
						.shadow(
							color: .black.opacity(0.5),
							radius: 2,
							y: 2)
				} else {
					EmptyView()
				}
				beerDescriptionView(
					title: title,
					firstBrewed: firstBrewed)
				Spacer(minLength: 15)
				Image(systemName:"chevron.right")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.foregroundColor(.blue)
					.frame(height: 16)
			}
			.padding(10)
		}
	}
	
	private var roundedRectangleView: some View {
		RoundedRectangle(cornerRadius: 8)
			.foregroundColor(.black.opacity(0.03))
			.shadow(
				color: .gray.opacity(0.3),
				radius: 3,
				y: 2)
		
	}
	
}

private extension BeerItemView {
	
	func beerDescriptionView(title: String,
							 firstBrewed: String
	) -> some View {
		VStack(alignment: .leading) {
			Text(title)
				.bold()
				.font(.title2)
			Text("First brewed: \(firstBrewed)")
				.font(.caption2)
		}
	}
}
struct BeerItemView_Previews: PreviewProvider {
	static var previews: some View {
		BeerItemView(
			imageURL: URL(string: "https://images.punkapi.com/v2/4.png")!,
			title: "Punk API",
			firstBrewed: "01/2000")
	}
}
