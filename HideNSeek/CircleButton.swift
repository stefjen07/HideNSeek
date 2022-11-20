//
//  CircleButton.swift
//  HideNSeek
//
//  Created by Евгений on 17.11.22.
//

import SwiftUI

struct CircleButton: View {
	var text: String
	var color: Color

    var body: some View {
		Text(text)
			.font(.title)
			.bold()
			.foregroundColor(.white)
			.frame(width: 200, height: 200)
			.background(
				Circle()
					.foregroundColor(color)
			)
    }
}

struct CircleButton_Previews: PreviewProvider {
    static var previews: some View {
		CircleButton(text: "Button", color: .red)
    }
}
