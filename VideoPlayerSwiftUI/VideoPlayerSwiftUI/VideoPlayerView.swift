//
//  VideoPlayerView.swift
//  VideoPlayerSwiftUI
//
//  Created by Patrick Pearce on 2024-01-15.
//

import SwiftUI

struct VideoPlayerView: View {
    @ObservedObject private var viewModel = VideoPlayerModel()
    let customFont = Font.custom("Bradley Hand", size: 30.0)
    
    var body : some View {
        // the title header of the app
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color.black)
                    .frame(height: geometry.size.height * 0.10)
                    .overlay(
                        Text("Video Player")
                            .font(customFont)
                            .foregroundColor(.white)
                    )
                
                CustomAVPlayer(player: $viewModel.player, isPlaying: $viewModel.isPlaying)
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
