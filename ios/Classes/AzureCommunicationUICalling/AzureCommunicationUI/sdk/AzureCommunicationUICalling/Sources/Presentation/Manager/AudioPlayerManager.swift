//
//  AudioPlayerManager.swift
//  Pods
//
//  Created by Yriy Malyts on 18.04.2025.
//

import AVFoundation

public class AudioPlayerManager {
    static let shared = AudioPlayerManager()
    
    var player: AVAudioPlayer?

    func playRaiseHandSound() {
        let bundleURL = Bundle(for: AcsPlugin.self).url(forResource: "raise_hand", withExtension: "mp3")
                
        if let bundleURL {
            player = try? AVAudioPlayer(contentsOf: bundleURL)
            player?.play()
        }
    }
}
