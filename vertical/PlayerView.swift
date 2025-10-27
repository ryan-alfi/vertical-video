//
//  PlayerView.swift
//  vertical
//
//  Created by Ari Fajrianda Alfi on 27/10/25.
//

import UIKit
import AVFoundation
import Combine

class PlayerView: UIView {
    // MARK: - Properties
    private var playerLayer: AVPlayerLayer?
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var subscriptions = Set<AnyCancellable>()
    private var videoGravity: AVLayerVideoGravity = .resizeAspectFill
    
    private var isLooping: Bool = true
    public var onVideoFinished: (() -> Void)?
    
    // MARK: - Internal methods
    func playMedia(at url: URL) {
        // make an av asset from url
        let asset = AVURLAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        
        // setup player layer
        let playerLayer = AVPlayerLayer()
        self.layer.addSublayer(playerLayer)
        playerLayer.frame = bounds
        self.playerLayer = playerLayer
        
        // setup AVPlayer
        let player = AVPlayer(playerItem: playerItem)
        player.isMuted = false // audio
        player.actionAtItemEnd = isLooping ? .none : .pause
        self.player = player
        
        // Assign to player to player layer to display
        self.playerLayer?.player = player
        self.playerLayer?.videoGravity = videoGravity
        self.playerItem = playerItem
        
        self.bindPublishers()
        
        // Set the item as the player's current item.
        self.player?.replaceCurrentItem(with: playerItem)
    }
    
    private func bindPublishers() {
        self.playerItem?.publisher(for: \.status)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let self else { return }
                switch status {
                case .readyToPlay:
                    // Ready to play. Present playback UI.
                    self.player?.play()
                case .failed: break
                    // A failure while loading media occurred.
                default:
                    break
                }
            }
            .store(in: &subscriptions)
        
        // Observe when video ends to loop it
        NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime, object: playerItem)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                print("Video ended, looping...")
                // Seek to beginning and play again
                if self.isLooping == true {
                    self.player?.seek(to: .zero)
                    self.player?.play()
                } else {
                    self.onVideoFinished?()
                }
            }
            .store(in: &subscriptions)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.playerLayer?.frame = bounds
    }
    
    func play() {
        self.player?.play()
    }
    func pause() {
        self.player?.pause()
    }
    
}
