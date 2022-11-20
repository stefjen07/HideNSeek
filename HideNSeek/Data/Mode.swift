//
//  Mode.swift
//  HideNSeek
//
//  Created by Евгений on 20.11.22.
//

import SwiftUI

enum Mode: String, Identifiable, CaseIterable {
	case sound
	case network

	var id: Int {
		hashValue
	}

	var name: String {
		switch self {
		case .sound:
			return "sound-advertising".localized
		case .network:
			return "silence-advertising".localized
		}
	}

	var icon: Image {
		switch self {
		case .sound:
			return Image(systemName: "speaker.wave.2.fill")
		case .network:
			return Image(systemName: "antenna.radiowaves.left.and.right")
		}
	}
}
