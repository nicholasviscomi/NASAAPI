//
//  CollectionViewCell.swift
//  NasaAPI
//
//  Created by Nick Viscomi on 9/23/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import UIKit
import AVFoundation

class CollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let field = UIImageView()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.contentMode = .scaleAspectFit
        return field
    }()
    
    let titleLabel: UILabel = {
        let field = UILabel()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = .systemFont(ofSize: 18, weight: .semibold)
        field.textColor = .label
        field.numberOfLines = 0
        field.backgroundColor = UIColor.tertiarySystemBackground.withAlphaComponent(1)
        field.textAlignment = .center
        return field
    }()
    
    let dateLabel: UILabel = {
        let field = UILabel()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = .systemFont(ofSize: 20, weight: .bold)
        field.textColor = .label
        field.backgroundColor = UIColor.tertiarySystemBackground.withAlphaComponent(1)
        field.textAlignment = .center
        return field
    }()
    
    let bg: UIView = {
        let field = UIView()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = .tertiarySystemBackground
        return field
    }()
    
    var detailViewDelegate: DetailViewDelegate?
    
    var model: APOD?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureSelf()
        setFrames()
    }
    
    fileprivate func setFrames() {
        NSLayoutConstraint.activate([
//            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
        NSLayoutConstraint.activate([
            bg.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -5),
            bg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            bg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            bg.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0)
        ])
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bg.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            dateLabel.heightAnchor.constraint(equalToConstant: 25),
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
    }
    
    fileprivate func configureSelf() {
        self.clipsToBounds = false
        contentView.addSubview(imageView)
        contentView.addSubview(bg)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
    
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
        contentView.backgroundColor = .secondarySystemBackground
    }
    
    let days = ["Today", "Yesterday", "2 Days Ago", "3 Days Ago", "4 Days Ago", "5 Days Ago", "6 Days Ago"]
    
    func configure(model: APOD, indexPath: IndexPath) {
        if model.media_type == "video" {
//            print("video type found")
//            playVideo(model: model)
            self.imageView.image = model.image
        } else {
            self.imageView.image = model.image
        }
        self.titleLabel.text = "    \(model.title)"
        self.model = model
        
        self.dateLabel.text = days[indexPath.row]//model.date
    }
    
    func playVideo(model: APOD) {
        if let url = URL(string: model.videoUrl ?? "") {
            //2. Create AVPlayer object
            let asset = AVAsset(url: url)
            let playerItem = AVPlayerItem(asset: asset)
            let player = AVPlayer(playerItem: playerItem)
            
            //3. Create AVPlayerLayer object
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.imageView.bounds //bounds of the view in which AVPlayer should be displayed
            playerLayer.videoGravity = .resizeAspect
            
            //4. Add playerLayer to view's layer
            self.contentView.layer.addSublayer(playerLayer)
            
            //5. Play Video
            player.play()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
    
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
    }
}
