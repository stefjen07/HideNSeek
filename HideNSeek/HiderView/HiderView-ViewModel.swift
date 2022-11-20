//
//  HiderView-ViewModel.swift
//  HideNSeek
//
//  Created by Евгений on 17.11.22.
//

import Foundation

extension HiderView {
	@MainActor class ViewModel: ObservableObject {
		var discoverService: DiscoverServiceProtocol

		@Published var isHiding = false
		@Published var currentMode = Mode.sound {
			didSet {
				switch currentMode {
				case .sound:
					discoverService = AudioService(recording: false)
				case .network:
					discoverService = BluetoothService()
				}
			}
		}

		init(discoverService: DiscoverServiceProtocol = AudioService(recording: false)) {
			self.discoverService = discoverService
		}

		func toggleHiding() {
			isHiding.toggle()

			if isHiding {
				self.discoverService.startAdvertising()
			} else {
				self.discoverService.stopAdvertising()
			}
		}
	}
}
