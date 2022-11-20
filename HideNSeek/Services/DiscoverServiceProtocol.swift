//
//  DiscoverServiceProtocol.swift
//  HideNSeek
//
//  Created by Евгений on 19.11.22.
//

import Foundation

protocol DiscoverServiceProtocol: AnyObject {
	var delegate: DiscoverServiceDelegate? { get set }

	func startSeeking()
	func stopSeeking()
	func startAdvertising()
	func stopAdvertising()
}

protocol DiscoverServiceDelegate {
	func discoverService(_ discoverService: DiscoverServiceProtocol, newWarmth: Double, mode: Mode)
}
