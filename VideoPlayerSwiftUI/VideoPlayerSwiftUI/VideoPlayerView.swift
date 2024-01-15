//
//  VideoPlayerView.swift
//  VideoPlayerSwiftUI
//
//  Created by Patrick Pearce on 2024-01-15.
//

import SwiftUI

struct VideoPlayerView: View {
    var body : some View {
        // the title header of the app
        Rectangle()
            .fill(Color.black)
            .overlay(
                Text("Video Player")
                    .font(Font.system(size: 30.0))
                    .foregroundColor(.white)
            )
    }
}
