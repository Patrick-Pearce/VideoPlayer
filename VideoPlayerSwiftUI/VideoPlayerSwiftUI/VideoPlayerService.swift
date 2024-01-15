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
