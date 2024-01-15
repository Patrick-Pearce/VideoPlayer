//
//  VideoPlayerView.swift
//  VideoPlayerSwiftUI
//
//  Created by Patrick Pearce on 2024-01-15.
//

import SwiftUI
import Combine

struct VideoPlayerView: View {
    @ObservedObject private var viewModel = VideoPlayerModel()
    
    var body : some View {
        // the title header of the app
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.black)
                .overlay(
                    Text("Video Player")
                        .font(Font.system(size: 30.0))
                        .foregroundColor(.white)
                )
                .onAppear {
                    viewModel.fetchVideos()
                }
        }
    }
}
