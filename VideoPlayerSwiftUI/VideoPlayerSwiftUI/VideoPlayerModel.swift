//
//  VideoPlayerModel.swift
//  VideoPlayerSwiftUI
//
//  Created by Patrick Pearce on 2024-01-15.
//

import SwiftUI
import Combine
import AVKit

// the model class interfaces with both the view and service classes
// the view calls the model to request info from the service
// when data is received the view is updated asynchronously
class VideoPlayerModel : ObservableObject {
    @Published var videos: [Video] = []
    @Published var currentVideo: Video?
    @Published var player: AVPlayer = AVPlayer()
    
    private var cancellables: Set<AnyCancellable> = []
    
    func fetchVideos() {
        VideoService.shared.fetchVideosInfo()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Error fetching videos: \(error)")
                }
            }, receiveValue: { [self] videos in
                self.videos = videos
                currentVideo = videos.first
                // after getting video data, take video URL and attempt to load video into the AVPlayer
                loadVideo(urlString: currentVideo?.fullURL)
            })
            .store(in: &cancellables)
    }
    
    private func loadVideo(urlString: String?) {
        if let url = URL(string: urlString ?? "") {
            self.player.replaceCurrentItem(with: AVPlayerItem(url: url))
        }
    }
}
