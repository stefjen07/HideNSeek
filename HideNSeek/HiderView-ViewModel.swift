//
//  HiderView-ViewModel.swift
//  HideNSeek
//
//  Created by Евгений on 17.11.22.
//

import Foundation

extension HiderView {
	@MainActor class ViewModel: ObservableObject {
		var audioService: AudioServiceProtocol

		@Published var isHiding = false
		var timer: Timer?

		init(audioService: AudioServiceProtocol = AudioService(recording: false)) {
			self.audioService = audioService
		}

		func toggleHiding() {
			isHiding.toggle()

			if isHiding {
				timer = Timer.scheduledTimer(withTimeInterval: Constants.soundInterval, repeats: true) { _ in
					self.audioService.playSound()
				}
			} else {
				timer?.invalidate()
			}
		}
	}
}
