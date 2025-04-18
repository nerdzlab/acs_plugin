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
        guard let path = Bundle.main.path(forResource: "raise_hand", ofType:"mp3") else {
            return }
        
        let url = URL(fileURLWithPath: path)

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
