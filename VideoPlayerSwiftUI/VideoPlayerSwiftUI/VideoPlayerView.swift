//
//  VideoPlayerView.swift
//  VideoPlayerSwiftUI
//
//  Created by Patrick Pearce on 2024-01-15.
//

import SwiftUI
import Combine
import MarkdownKit
import AVKit

struct VideoPlayerView: View {
    @ObservedObject private var viewModel = VideoPlayerModel()
    
    var body : some View {
        // the title header of the app
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color.black)
                    .frame(height: geometry.size.height * 0.10)
                    .overlay(
                        Text("Video Player")
                            .font(Font.system(size: 30.0))
                            .foregroundColor(.white)
                    )
                
                AVPlayerControllerRepresented(player: $viewModel.player)
                    .frame(height: geometry.size.height * 0.30)
                DetailsView(video: viewModel.currentVideo)
            }.onAppear {
                viewModel.fetchVideos()
            }
        }
    }
}

// need to make custom AVPlayer so that default controls can be hidden
struct AVPlayerControllerRepresented : UIViewControllerRepresentable {
    @Binding var player : AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        // added to hide default media controls
        controller.showsPlaybackControls = false
        // added to remove black bars and have video fit full screen
        controller.videoGravity = .resize
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
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
                    let parser = MarkdownParser()
                    let markdown = AttributedString(parser.parse(video.description))
                    Text(markdown)
                }.padding()
            } else {
                Text("No video selected").font(font)
            }
        }
    }
}
