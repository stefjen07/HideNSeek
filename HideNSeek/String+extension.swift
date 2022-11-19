//
//  String+extension.swift
//  PineComm
//
//  Created by Евгений on 18.11.22.
//

import Foundation

extension String {
	var localized: String {
		NSLocalizedString(self, comment: "")
	}
}
