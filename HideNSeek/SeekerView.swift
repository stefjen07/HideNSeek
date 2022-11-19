//
//  SeekerView.swift
//  HideNSeek
//
//  Created by Евгений on 17.11.22.
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
			return "Звуковое оповещение"
		case .network:
			return "Бесшумное оповещение"
		}
	}
}

struct SeekerView: View {
	@ObservedObject var viewModel: ViewModel

    var body: some View {
		VStack {
			Spacer()
			Button(action: viewModel.toggleSeeking, label: {
				CircleButton(text: viewModel.isSeeking ? "Закончить поиск" : "Начать поиск", color: .blue)
			})
			Spacer()
			ForEach(Mode.allCases) { mode in
				GeometryReader { proxy in
					ZStack(alignment: .trailing) {
						Rectangle()
							.fill(LinearGradient(colors: [.green, .red], startPoint: .leading, endPoint: .trailing))
						Rectangle()
							.fill(Color.gray)
							.frame(width: proxy.size.width * (1 - viewModel.warmthDictionary[mode]!))
					}
				}
				.frame(height: 50)
				.cornerRadius(10)
			}
			Spacer()
		}
		.padding(20)
    }
}

struct SeekerView_Previews: PreviewProvider {
    static var previews: some View {
		SeekerView(viewModel: .init())
    }
}
