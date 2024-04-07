//
//  AsynchronousImage.swift
//  DemoProject
//
//  Created by Yevgeniy Prokoshev on 05/04/2024.
//

import SwiftUI

struct AsynchronousImage: View {
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
						Text("🤖")
						font(.system(size: 30))
						Image(systemName: "wifi.slash")
					}
				@unknown default:
					EmptyView()
			}
		}
	}
}

#Preview("With URL") {
	AsynchronousImage(url: URL(string: "https://rickandmortyapi.com/api/character/avatar/3.jpeg")!)
}
