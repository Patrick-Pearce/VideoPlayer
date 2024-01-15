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
            DetailsView(video: viewModel.currentVideo)
        }.onAppear {
            viewModel.fetchVideos()
        }
    }
}

// displays the video's info including author, title, and description
struct DetailsView: View {
    let video: Video?
    let font = Font.system(size: 20.0)

    var body: some View {
        ScrollView() {
            // after the view is updated with the video data the video data is used to populate the details
            if let video = video {
                VStack(alignment: .leading) {
                    Text(video.title).font(font)
                    Text(video.author.name).font(font).padding(.bottom, 10)
                    Text(video.description)
                }.padding()
            } else {
                Text("No video selected").font(font)
            }
        }
    }
}
