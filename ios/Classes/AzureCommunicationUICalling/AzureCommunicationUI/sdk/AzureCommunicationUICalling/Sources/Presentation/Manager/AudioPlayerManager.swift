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
        let bundleURL = Bundle(for: AcsPlugin.self).url(forResource: "raise_hand", withExtension: "wav")
                
        if let bundleURL {
            player = try? AVAudioPlayer(contentsOf: bundleURL)
            player?.play()
        }
    }
    
    func playReactionReceivedSound() {
        let bundleURL = Bundle(for: AcsPlugin.self).url(forResource: "reaction_received", withExtension: "wav")
                
        if let bundleURL {
            player = try? AVAudioPlayer(contentsOf: bundleURL)
            player?.play()
        }
    }
    
    func playUserJoinedSound() {
        let bundleURL = Bundle(for: AcsPlugin.self).url(forResource: "user_joined_call", withExtension: "wav")
                
        if let bundleURL {
            player = try? AVAudioPlayer(contentsOf: bundleURL)
            player?.play()
        }
    }
}
