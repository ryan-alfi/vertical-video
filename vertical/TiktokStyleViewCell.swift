//
//  TiktokStyleViewCell.swift
//  vertical
//
//  Created by Ari Fajrianda Alfi on 27/10/25.
//

import UIKit

class TiktokStyleViewCell: UICollectionViewCell {
    static let reuseIdentifier = "TikTokStyleCell"
    
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    private let backgroundColorView = UIView()
    //1 Added
    private var playerView: PlayerView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // Background color view
        backgroundColorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(backgroundColorView)
        
        //2 Added
        // playerView
        let playerView = PlayerView()
        playerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(playerView)
        
        
        // Title label
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // Subtitle label
        subtitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        subtitleLabel.textColor = .white.withAlphaComponent(0.8)
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            // Background color view
            backgroundColorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundColorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundColorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundColorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            //3 Added
            // player view
            playerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            playerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            playerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // Title label
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            // 1 Modified
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 36),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -20),
            
            // Subtitle label
            // 2 Modified
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -36),
            subtitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            subtitleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -20)
        ])
        // 4 Added
        self.playerView = playerView
    }
    
    func configure(with item: Item) {
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        
        // Set background color based on iOS system color name
        if let color = UIColor.init(hex: item.colourName) {
            backgroundColorView.backgroundColor = color
        }
        // 5 Added
        /*
        if let url = Bundle.main.url(forResource: item.videoUrl, withExtension: "mp4") {
            self.playerView?.playMedia(at: url)
        }
        */
        if let url = URL(string: item.videoUrl) {
            self.playerView?.playMedia(at: url)
        }
    }
    
    func play() {
        self.playerView?.play()
    }
    func pause() {
        self.playerView?.pause()
    }
}
