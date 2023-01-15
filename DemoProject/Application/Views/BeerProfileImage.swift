//
//  BeerProfileImage.swift
//  DemoProject
//
//  Created by Yevgeniy Prokoshev on 14/01/2023.
//

import SwiftUI

struct BeerProfileImage: View {
	let url: URL
	
	var body: some View {
		AsyncImage(
			url: url,
			transaction: Transaction(animation: .easeInOut)
		) { phase in
			switch phase {
				case .empty:
					ProgressView()
						.tint(.white)
				case .success(let image):
					image
						.resizable()
						.aspectRatio(contentMode: .fill)
						.transition(.scale(scale: 0.1, anchor: .center))
				case .failure:
					VStack(spacing: 5) {
						Text("🍺")
						Image(systemName: "wifi.slash")
					}
				@unknown default:
					EmptyView()
			}
		}
	}
}
