//
//  ImageButton.swift
//  VideoPlayerSwiftUI
//

import SwiftUI

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
