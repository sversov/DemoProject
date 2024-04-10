//
//  AsynchronousImage.swift
//  DemoProject
//
//  Created by Yevgeniy Prokoshev on 05/04/2024.
//

import SwiftUI

// TODO: Refactor to load data, use caching etc.

struct AsynchronousImage: View {
	let url: URL
	
	var body: some View {
		AsyncImage(url: url) { image in
			image.resizable()
		} placeholder: {
			ProgressView()
		}
	}
}

#Preview("With URL") {
	AsynchronousImage(url: URL(string: "https://rickandmortyapi.com/api/character/avatar/3.jpeg")!)
}

#Preview("With Progress") {
	AsynchronousImage(url: URL(string: "invalid URL")!)
}
