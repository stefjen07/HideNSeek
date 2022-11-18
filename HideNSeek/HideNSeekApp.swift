//
//  HideNSeekApp.swift
//  HideNSeek
//
//  Created by Евгений on 17.11.22.
//

import SwiftUI

@main
struct HideNSeekApp: App {
    var body: some Scene {
        WindowGroup {
			NavigationView {
				RolePickerView()
			}
			.navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
