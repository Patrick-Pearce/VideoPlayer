//
//  VideoPlayerView.swift
//  VideoPlayerSwiftUI
//
//  Created by Patrick Pearce on 2024-01-15.
//

import SwiftUI
import Combine

struct VideoPlayerView: View {
    @State private var videos: [Video] = []
    @State private var currentVideo: Video?
    @State private var cancellables: Set<AnyCancellable> = []
    
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
                    fetchVideos()
                }
        }
    }
    
    private func fetchVideos() {
        VideoService.shared.fetchVideosInfo()
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Error fetching videos: \(error)")
                }
            }, receiveValue: { videos in
                self.videos = videos
                self.currentVideo = videos.first
                print(videos)

            })
            .store(in: &cancellables)
    }
}
