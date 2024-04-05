//
//  LuckyChanceView.swift
//  DemoProject
//
//  Created by Yevgeniy Prokoshev on 05/04/2024.
//

import SwiftUI

struct LuckyChanceView: View {
	@ObservedObject var viewModel: LuckyChanceViewModel
	
	var body: some View {
		VStack (spacing: 30){
			Text(viewModel.randomEmoji)
				.font(.system(size: viewModel.state == .idle ? 60 : 120))
			if viewModel.state == .idle {
				Button(viewModel.buttonTitle,
					   action: { viewModel.playTheGame() })
				.buttonStyle(.borderedProminent)
				.controlSize(.large)
				.tint(.green)
			}
		}
		.animation(.spring,
				   value: viewModel.state)
	}
}

#Preview {
	LuckyChanceView(viewModel: LuckyChanceViewModel(finishHandler: {}))
}
