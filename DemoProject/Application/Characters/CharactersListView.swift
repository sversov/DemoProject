//
//  CharactersListView.swift
//  DemoProject
//
//  Created by Yevgeniy Prokoshev on 07/04/2024.
//

import SwiftUI

struct CharactersListView: View {
	
	@ObservedObject var viewModel: CharactersListViewModel
	let onSelection: ((CharactersPage.Character) -> Void)
	
    var body: some View {
		contentView
			.onAppear { viewModel.fetchCharacters() }
    }
	
	@ViewBuilder
	private var contentView: some View {
		switch viewModel.state {
			case .idle:
				EmptyView()
			case .loading:
				ProgressView()
					.frame(width: 40,
						   height: 40)
			case .error(let error):
				errorView(error: error)
			case .loaded(let characters):
				listView(characters: characters)
		}
	}
	
}

extension CharactersListView {
	
	private func errorView(
		error: Error
	) -> some View {
		VStack(spacing: 20) {
			Text(error.localizedDescription)
			Button {
				viewModel.fetchCharacters()
			} label: {
				Text("Try Again")
			}
			.buttonStyle(.borderedProminent)
			.controlSize(.large)
			.tint(.green)
		}
	}
	
	@ViewBuilder
	private func listView(
		characters: [CharactersPage.Character]
	) -> some View {
		List {
			ForEach(characters) { character in
				CharacterItemView(name: character.name,
								  status: character.status)
				.onTapGesture {
					onSelection(character)
				}
				.listRowSeparator(.hidden)
			}
		}
		.listStyle(.plain)
	}
}

#Preview {
	CharactersListView(
		viewModel: CharactersListViewModel(
			apiClient: DemoProjectAPIClient(
				baseURL: "https://rickandmortyapi.com/api",
				session: .shared)),
		onSelection: { _ in })
}

//#Preview("Error") {
//	CharactersListView(
//		viewModel: CharactersListViewModel(
//			apiClient: DemoProjectAPIClient(
//				baseURL: "https://rickandmortyapi.com/api/123",
//				session: .shared)),
//		onSelection: { _ in })
//}
