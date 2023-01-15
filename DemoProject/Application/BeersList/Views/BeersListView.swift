//
//  BeersListView.swift
//  DemoProject
//
//  Created by Yevgeniy Prokoshev on 13/01/2023.
//

import Foundation
import SwiftUI

struct BeersListView: View {
	
	@ObservedObject var viewModel: BeersListViewModel
	
	let onBeerSelection: ((Beer) -> Void)
	
	var body: some View {
		contentView
			.onAppear { viewModel.fetchBeers() }
	}
	
	@ViewBuilder
	private var contentView: some View {
		switch viewModel.state {
			case .idle:
				Color.clear
			case .loading:
				ProgressView()
					.frame(width: 40,
						   height: 40)
			case .error(let error):
				errorView(error: error)
			case .loaded(let beers):
				listView(beers: beers)
		}
	}
	
	private func errorView(error: Error) -> some View {
		VStack {
			Text(error.localizedDescription)
			Button {
				viewModel.fetchBeers()
			} label: {
				Text("Try Again")
			}
		}
	}
	
	private func listView(beers: [Beer]) -> some View {
		List {
			ForEach(beers) { beer in
				BeerItemView(imageURL: beer.imageURL,
							title: beer.name,
							firstBrewed: beer.firstBrewed)
				.onTapGesture {
					onBeerSelection(beer)
				}
				.listRowSeparator(.hidden)
			}
		}
		.listStyle(PlainListStyle())
	}
}

#if DEBUG
struct BeersListView_Previews: PreviewProvider {
	static var previews: some View {
		BeersListView(viewModel: BeersListViewModel.makePreviewModel(),
					  onBeerSelection: { _ in})
	}
}

extension BeersListViewModel {
	static func makePreviewModel() -> BeersListViewModel {
		return BeersListViewModel(apiClient: PunkAPIClient(
			baseURL: "https://api.punkapi.com/v2",
			session: .shared))
	}
}
#endif
