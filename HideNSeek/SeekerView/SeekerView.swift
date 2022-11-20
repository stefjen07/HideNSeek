//
//  SeekerView.swift
//  HideNSeek
//
//  Created by Евгений on 17.11.22.
//

import SwiftUI

struct SeekerView: View {
	@ObservedObject var viewModel: ViewModel

    var body: some View {
		VStack {
			Spacer()
			Button(action: viewModel.toggleSeeking, label: {
				CircleButton(text: (viewModel.isSeeking ? "stop-search" : "start-search").localized, color: .accentColor)
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
						HStack {
							mode.icon
								.foregroundColor(.white)
							Spacer()
						}
						.padding(.horizontal, 15)
					}
				}
				.frame(height: 50)
				.cornerRadius(10)
			}
			Spacer()
		}
		.padding(20)
		.onDisappear {
			if viewModel.isSeeking {
				viewModel.toggleSeeking()
			}
		}
    }
}

struct SeekerView_Previews: PreviewProvider {
    static var previews: some View {
		SeekerView(viewModel: .init())
    }
}
