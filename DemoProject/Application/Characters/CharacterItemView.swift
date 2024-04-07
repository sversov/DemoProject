//
//  CharacterItemView.swift
//  DemoProject
//
//  Created by Yevgeniy Prokoshev on 07/04/2024.
//

import SwiftUI

struct CharacterItemView: View {
	
	let name: String
	let status: RMCharactersPageModel.RMCharacter.Status
	
	var body: some View {
		HStack {
			VStack(alignment: .leading) {
				Text(name)
					.font(.title)
				Text(status.rawValue)
					.font(.callout)
			}
			Spacer(minLength: 15)
			Image(systemName:"chevron.right")
				.resizable()
				.aspectRatio(contentMode: .fit)
				.foregroundColor(.teal)
				.frame(height: 16)
		}
		.padding(10)
		.background(.quinary)
		.clipShape(RoundedRectangle(cornerRadius: 12,
									style: .continuous))
	}
}

#Preview("Alive") {
	CharacterItemView(name: "Rick Sanches",
					  status: .alive)
}

#Preview("Dead") {
	CharacterItemView(name: "Rick Sanches",
					  status: .dead)
}

#Preview("Unknown") {
	CharacterItemView(name: "Rick Sanches",
					  status: .unknown)
}


