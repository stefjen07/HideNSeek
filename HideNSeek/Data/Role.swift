//
//  Role.swift
//  HideNSeek
//
//  Created by Евгений on 20.11.22.
//

import SwiftUI

enum Role: String, Identifiable, CaseIterable {
	case seeker
	case hider

	var id: Int {
		rawValue.hashValue
	}

	var description: String {
		switch self {
		case .seeker:
			return "seeker".localized
		case .hider:
			return "hider".localized
		}
	}

	var color: Color {
		switch self {
		case .seeker:
			return .blue
		case .hider:
			return .green
		}
	}
}
