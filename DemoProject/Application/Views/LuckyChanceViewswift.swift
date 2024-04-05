//
//  LuckyChanceView.swift
//  DemoProject
//
//  Created by Yevgeniy Prokoshev on 05/04/2024.
//

import SwiftUI
import Combine

struct LuckyChanceView: View {
	@ObservedObject var viewModel: LuckyChanceViewModel
	
	var body: some View {
		VStack (spacing: 30){
			Text(viewModel.randomEmoji)
				.font(.system(size: viewModel.state == .idle ? 60 : 120))
			if viewModel.state == .idle {
				Button("Feeling Lucky",
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

class LuckyChanceViewModel: ObservableObject {
	
	enum State {
		case idle
		case shuffling
		case done
	}
	
	private let emojis = ["🥂", "🍹", "🍷", "🧉", "🍾", "🍸"]
	private let numberOfCycles = 20
	
	@Published private(set) var randomEmoji: String = "🍸"
	@Published private(set) var state: State = .idle

	private(set) var currentCycle = 0
	private(set) var timer: AnyCancellable?
	let finishHandler: () -> Void
	
	init(finishHandler: @escaping () -> Void) 
	{
		self.finishHandler = finishHandler
	}
	
	func playTheGame() {
		timer?.cancel()
		state = .shuffling
		timer = Timer
			.publish(every: 0.2,
					 on: .main,
					 in: .default)
			.autoconnect()
			.map ( { [weak self] _ in self?.currentCycle += 1 })
			.sink(receiveValue: { [weak self] _ in
				guard let self = self else { return }
				let randInt = Int.random(in: 0..<emojis.count)
				self.randomEmoji = self.emojis[randInt]
				if currentCycle > numberOfCycles {
					self.stop()
				}
			})
	}
	
	private func stop() {
		currentCycle = 0
		state = .done
		timer?.cancel()
		finishHandler()
	}
}

#Preview {
	LuckyChanceView(viewModel: LuckyChanceViewModel(finishHandler: {}))
}
