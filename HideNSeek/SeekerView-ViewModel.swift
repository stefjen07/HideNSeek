//
//  SeekerView-ViewModel.swift
//  HideNSeek
//
//  Created by Евгений on 18.11.22.
//

import SwiftUI

extension SeekerView {
	@MainActor class ViewModel: ObservableObject, AudioServiceDelegate {
		var audioService: AudioServiceProtocol

		@Published var currentMode = Mode.sound
		@Published var isSeeking = false
		@Published var warmth: Double = 0

		init(audioService: AudioServiceProtocol = AudioService(recording: true)) {
			self.audioService = audioService
			self.audioService.delegate = self
		}

		func warmthChanged(_ newWarmth: Double) {
			DispatchQueue.main.async {
				withAnimation {
					self.warmth = newWarmth
				}
			}
		}

		func toggleSeeking() {
			isSeeking.toggle()

			if isSeeking {
				audioService.startSeeking()
			} else {
				audioService.stopSeeking()
			}
		}
	}
}
