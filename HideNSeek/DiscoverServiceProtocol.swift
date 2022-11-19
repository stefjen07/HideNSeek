//
//  DiscoverServiceProtocol.swift
//  HideNSeek
//
//  Created by Евгений on 19.11.22.
//

import Foundation

protocol DiscoverServiceProtocol: AnyObject {
	func startSeeking()
	func stopSeeking()
	func startAdvertising()
	func stopAdvertising()

	var delegate: DiscoverServiceDelegate? { get set }
}

protocol DiscoverServiceDelegate {
	func warmthChanged(_ newWarmth: Double, mode: Mode)
}
