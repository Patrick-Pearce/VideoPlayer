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
                
                AVPlayerControllerRepresented(player: $viewModel.player, isPlaying: $viewModel.isPlaying)
                    .frame(height: geometry.size.height * 0.30)
                    .overlay(
                        // add media controls to custom AVPlayer
                        HStack(spacing: 15) {
                            ImageButton(imageName: "previous", circleSize: 50, imageSize: 30) {
                                viewModel.playPreviousVideo()
                            }
                            .disabled(viewModel.currentIndex == 0 || viewModel.videos.isEmpty)
                            .opacity(viewModel.currentIndex == 0 || viewModel.videos.isEmpty ? 0.5 : 1.0)
                            
                            ImageButton(imageName: viewModel.isPlaying ? "play" : "pause", circleSize: 80, imageSize: 60) {
                                viewModel.togglePlayPause()
                            }
                            
                            ImageButton(imageName: "next", circleSize: 50, imageSize: 30) {
                                viewModel.playNextVideo()
                            }
                            .disabled(viewModel.currentIndex == viewModel.videos.count - 1 || viewModel.videos.isEmpty)
                            .opacity(viewModel.currentIndex == viewModel.videos.count - 1 || viewModel.videos.isEmpty ? 0.5 : 1.0)
                        }
                    )
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
    @Binding var isPlaying : Bool
    
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
        if isPlaying {
            uiViewController.player?.pause()
        } else {
            uiViewController.player?.play()
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

struct ImageButton: View {
    let imageName: String
    let circleSize: CGFloat
    let imageSize: CGFloat
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Image(systemName: "circle.fill")
                .foregroundColor(.white)
                .font(.system(size: circleSize))
                .overlay(
                    Image(uiImage: UIImage(named: imageName)!)
                        .frame(width: imageSize, height: imageSize)
                )
        }
    }
}
