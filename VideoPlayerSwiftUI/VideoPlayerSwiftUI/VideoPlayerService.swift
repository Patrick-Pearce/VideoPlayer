//
//  VideoPlayerService.swift
//  VideoPlayerSwiftUI
//
//  Created by Patrick Pearce on 2024-01-15.
//

import Foundation
import SwiftUI
import Combine

// The format that the fetched JSON is in
struct Video: Codable {
    let id: String
    let title: String
    let hlsURL: String
    let fullURL: String
    let description: String
    let publishedAt: String
    let author: Author
}

struct Author: Codable {
    let id: String
    let name: String
}

class VideoService {
    // create a singleton instance of this class
    static let shared = VideoService()
    
    // fetches data from the server and maps it to the video struct
    // returns a publisher that publishes videos info or error
    func fetchVideosInfo() -> AnyPublisher<[Video], Error> {
        guard let url = URL(string: "http://localhost:4000/videos") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Video].self, decoder: JSONDecoder())
            .map { videoDataArray in
                return videoDataArray.map { videoData in
                    Video(
                        id: videoData.id,
                        title: videoData.title,
                        hlsURL: videoData.hlsURL,
                        fullURL: videoData.fullURL,
                        description: videoData.description,
                        publishedAt: videoData.publishedAt,
                        author: videoData.author
                    )
                }
            }
            .eraseToAnyPublisher()
    }
}
