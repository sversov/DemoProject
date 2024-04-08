//
//  CharacterDetailsView.swift
//  DemoProject
//
//  Created by Yevgeniy Prokoshev on 07/04/2024.
//

import SwiftUI

struct CharacterDetailsView: View {
	
	@ObservedObject var model: CharacterDetailsViewModel
	
    var body: some View {
		ScrollView {
			VStack(alignment: .center,
				   spacing: 10) {
				headerView(
					name: model.name,
					gender: model.gender, 
					species: model.species)
				.cardStyle()
				
				profileView(imageURL: model.image)
					.clipShape(Circle())
					.overlay(Circle().stroke(lineWidth: 3.0))
				statusView(
					status: model.status)
				.cardStyle()
				originView(
					origin: model.origin)
				.cardStyle()
				locationView(
					location: model.location)
				.cardStyle()
			}.padding()
		}
    }
}

private extension CharacterDetailsView {
	
	@ViewBuilder
	func headerView(
		name: String,
		gender: CharactersPage.Character.Gender,
		species: String
	) -> some View {
		VStack(alignment: .leading, spacing: 10) {
			Text(name)
				.font(.title)
				.bold()
			genderView(
				gender: gender,
				species: species)
		}
	}
	
	
	@ViewBuilder
	func profileView(
		imageURL: URL?
	) -> some View {
		if let imageURL = imageURL {
			AsynchronousImage(url: imageURL)
				.aspectRatio(contentMode: .fit)
				.frame(height: 300,
					   alignment: .center)
		} else {
			Text("👽")
				.font(.system(size: 80))
				.frame(height: 300,
					   alignment: .center)
		}
	}
	
	func genderView(
		gender: CharactersPage.Character.Gender,
		species: String
	) -> some View {
		VStack(alignment: .leading) {
			HStack {
				Text(gender.emoji)
				Text(gender.rawValue + " - " +  species)
					.font(.title3)
				.bold()
			}
		}
	}
	
	func statusView(
		status: CharactersPage.Character.Status
	) -> some View {
		VStack(alignment: .leading) {
			Text("Status")
				.font(.caption)
				.bold()
				.foregroundStyle(.secondary)
			HStack {
				statusIndicatorView(status: status)
					.frame(width: 15, height: 15)
				Text(status.rawValue)
					.font(.title3)
					.bold()
			}
		}
	}
	
	func statusIndicatorView(
		status: CharactersPage.Character.Status
	) -> some View {
		Circle()
			.fill(status.colour)
	}
	
	func originView(
		origin: CharactersPage.Character.Origin?
	) -> some View {
		VStack(alignment: .leading) {
			Text("Origin")
				.font(.caption)
				.bold()
				.foregroundStyle(.secondary)
			HStack {
				Text("🪐")
				Text(origin?.name ?? "Unknown")
					.font(.title3)
				.bold()
			}
		}
	}
	
	func locationView(
		location: CharactersPage.Character.Location?
	) -> some View {
		VStack(alignment: .leading) {
			Text("Current Location")
				.font(.caption)
				.bold()
				.foregroundStyle(.secondary)
			HStack {
				Text("📍")
				Text(location?.name ?? "Unknown")
					.font(.title3)
					.bold()
			}
		}
	}
	
}

extension CharactersPage.Character.Status {
	
	var colour: Color {
		switch self {
			case .alive: .green
			case .dead: .red
			case .unknown: .gray
		}
	}
}

extension View {
	func cardStyle() -> some View {
		self
			.frame(maxWidth: .infinity,
				   alignment: .leading)
			.padding(10)
			.background(.teal)
			.clipShape(RoundedRectangle(cornerRadius: 12,
										style: .continuous))
	}
}

#Preview("Status-Alive") {
	CharacterDetailsView(
		model: CharacterDetailsViewModel(
			character: .make(status: .alive,
							 gender: .male)))
}

#Preview("Status-Dead") {
	CharacterDetailsView(
		model: CharacterDetailsViewModel(
			character: .make(status: .dead,
							 gender: .female)))
}

#Preview("Status-Unknown") {
	CharacterDetailsView(
		model: CharacterDetailsViewModel(
			character: .make(status: .unknown,
							 gender: .genderless)))
}

#Preview("Gender-Unknown") {
	CharacterDetailsView(
		model: CharacterDetailsViewModel(
			character: .make(status: .dead,
							 gender: .unknown)))
}
