//
//  DetailsView.swift
//  VideoPlayerSwiftUI
//
//  Created by Patrick Pearce on 2024-01-15.
//

import SwiftUI
import MarkdownKit

// displays the video's info including author, title, and description
struct DetailsView: View {
    let video: Video?
    let font = Font.custom("Bradley Hand", size: 20.0)

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
