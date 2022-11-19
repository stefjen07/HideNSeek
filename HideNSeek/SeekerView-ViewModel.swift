//
//  SeekerView-ViewModel.swift
//  HideNSeek
//
//  Created by Евгений on 18.11.22.
//

import SwiftUI

extension SeekerView {
	@MainActor class ViewModel: ObservableObject, DiscoverServiceDelegate {
		var discoverServices: [DiscoverServiceProtocol]

		@Published var isSeeking = false
		@Published var warmthDictionary: [Mode: Double] = [
			.sound: 0,
			.network: 0
		]

		init(discoverServices: [DiscoverServiceProtocol] = [AudioService(recording: true), BluetoothService()]) {
			self.discoverServices = discoverServices

			self.discoverServices.forEach { $0.delegate = self }
		}

		func warmthChanged(_ newWarmth: Double, mode: Mode) {
			DispatchQueue.main.async {
				withAnimation {
					self.warmthDictionary[mode] = newWarmth
				}
			}
		}

		func toggleSeeking() {
			isSeeking.toggle()

			if isSeeking {
				discoverServices.forEach { $0.startSeeking() }
			} else {
				discoverServices.forEach { $0.stopSeeking() }
			}
		}
	}
}
