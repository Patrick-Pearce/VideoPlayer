//
//  CustomAVPlayer.swift
//  VideoPlayerSwiftUI
//

import AVKit
import SwiftUI

// need to make custom AVPlayer so that default controls can be hidden
struct CustomAVPlayer : UIViewControllerRepresentable {
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
