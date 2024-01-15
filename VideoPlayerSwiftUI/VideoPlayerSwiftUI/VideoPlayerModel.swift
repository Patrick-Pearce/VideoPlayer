//
//  VideoPlayerModel.swift
//  VideoPlayerSwiftUI
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
    @Published var isPlaying: Bool = false
    @Published var currentIndex: Int = 0
    @Published var player: AVPlayer = AVPlayer()
    
    private var cancellables: Set<AnyCancellable> = []
    
    func togglePlayPause() {
        isPlaying.toggle()
    }
    
    func playNextVideo() {
        if currentIndex < videos.count - 1 {
            currentIndex += 1
            currentVideo = videos[currentIndex]
            loadVideo(video: videos[currentIndex])
        }
    }

    func playPreviousVideo() {
        if currentIndex > 0 {
            currentIndex -= 1
            currentVideo = videos[currentIndex]
            loadVideo(video: videos[currentIndex])
        }
    }
    
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
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                // sort the videos from most recent video to oldest based on published at
                let sortedVideos = videos.sorted(by: { (video1, video2) -> Bool in
                   if let date1 = dateFormatter.date(from: video1.publishedAt),
                      let date2 = dateFormatter.date(from: video2.publishedAt) {
                       return date1 > date2
                   }
                   return false
                })
                self.videos = sortedVideos
                currentVideo = sortedVideos.first
                // after getting video data, take video URL and attempt to load video into the AVPlayer
                loadVideo(video: currentVideo)
                // pause video on first load
                togglePlayPause()
            })
            .store(in: &cancellables)
    }
    
    private func loadVideo(video: Video?) {
        if let url = URL(string: video?.fullURL ?? "") {
            self.player.replaceCurrentItem(with: AVPlayerItem(url: url))
        }
    }
}
