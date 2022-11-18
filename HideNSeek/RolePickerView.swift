//
//  RolePickerView.swift
//  HideNSeek
//
//  Created by Евгений on 17.11.22.
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
			return "Ищущий"
		case .hider:
			return "Прячущийся"
		}
	}

	var color: Color {
		switch self {
		case .seeker:
			return .red
		case .hider:
			return .blue
		}
	}
}

struct RolePickerView: View {
    var body: some View {
		VStack {
			Spacer()
			Text("Выберите роль")
				.font(.largeTitle)
				.bold()
			ForEach(Role.allCases) { role in
				Spacer()
				NavigationLink(destination: {
					switch role {
					case .seeker:
						AnyView(SeekerView(viewModel: .init()))
					case .hider:
						AnyView(HiderView(viewModel: .init()))
					}
				}, label: {
					CircleButton(text: role.description, color: role.color)
				})
			}
			Spacer()
		}
    }
}

struct RolePickerView_Previews: PreviewProvider {
    static var previews: some View {
        RolePickerView()
    }
}
