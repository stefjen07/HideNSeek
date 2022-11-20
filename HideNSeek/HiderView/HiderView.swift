//
//  HiderView.swift
//  HideNSeek
//
//  Created by Евгений on 17.11.22.
//

import SwiftUI

struct HiderView: View {
	@ObservedObject var viewModel: ViewModel

    var body: some View {
		VStack {
			Spacer()
			Picker("mode", selection: $viewModel.currentMode) {
				ForEach(Mode.allCases) { mode in
					Text(mode.name)
						.tag(mode)
				}
			}
			.pickerStyle(SegmentedPickerStyle())
			.disabled(viewModel.isHiding)
			Spacer()
			Button(action: {
				viewModel.toggleHiding()
			}, label: {
				CircleButton(text: (viewModel.isHiding ? "stop-hiding" : "hid").localized, color: .accentColor)
			})
			Spacer()
		}
		.padding(20)
		.onDisappear {
			if viewModel.isHiding {
				viewModel.toggleHiding()
			}
		}
    }
}

struct HiderView_Previews: PreviewProvider {
    static var previews: some View {
		HiderView(viewModel: .init())
    }
}
