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
		Button(action: {
			viewModel.toggleHiding()
		}, label: {
			CircleButton(text: viewModel.isHiding ? "Закончить прятки" : "Спрятался", color: .blue)
		})
    }
}

struct HiderView_Previews: PreviewProvider {
    static var previews: some View {
		HiderView(viewModel: .init())
    }
}
