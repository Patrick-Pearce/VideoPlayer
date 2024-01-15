//
//  VideoPlayerModel.swift
//  VideoPlayerSwiftUI
//
//  Created by Patrick Pearce on 2024-01-15.
//

import SwiftUI
import Combine

// the model class interfaces with both the view and service classes
// the view calls the model to request info from the service
// when data is received the view is updated asynchronously
class VideoPlayerModel : ObservableObject {
    @Published var videos: [Video] = []
    @Published var currentVideo: Video?
    
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
            }, receiveValue: { videos in
                self.videos = videos
                self.currentVideo = videos.first
                print(videos)

            })
            .store(in: &cancellables)
    }
}
