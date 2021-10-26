//
//  PlayerControlsView.swift
//  Spotify
//
//  Created by Tarık Nasuhoğlu on 26.10.2021.
//

import Foundation
import UIKit

protocol PlayerControlsViewDelegate: AnyObject {
    func playerControlsViewChangeTrackCurrentTime(_ playerControlView: PlayerControlsView)
    func playerControlsViewDidTapPlayPauseButton(_ playerControlView: PlayerControlsView)
    func playerControlsViewDidTapForwardsButton(_ playerControlView: PlayerControlsView)
    func playerControlsViewDidTapBackwardsButton(_ playerControlView: PlayerControlsView)
}

final class PlayerControlsView: UIView {
    
    weak var delegate: PlayerControlsViewDelegate?
    
    private let volumeSlider: UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        return slider
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "name of Song"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "song of subTitle xXx"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let backButton: UIButton = {
        let btn = UIButton()
        btn.tintColor = .label
        let image = UIImage(
            systemName: "backward.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular)
        )
        btn.setImage(image, for: .normal)
        return btn
    }()
    
    private let forwardButton: UIButton = {
        let btn = UIButton()
        btn.tintColor = .label
        let image = UIImage(
            systemName: "forward.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular)
        )
        btn.setImage(image, for: .normal)
        return btn
    }()
    
    private let playPauseButton: UIButton = {
        let btn = UIButton()
        btn.tintColor = .label
        let image = UIImage(
            systemName: "pause.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular)
        )
        btn.setImage(image, for: .normal)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(nameLabel)
        addSubview(subTitleLabel)
        addSubview(volumeSlider)
        addSubview(backButton)
        addSubview(playPauseButton)
        addSubview(forwardButton)
        clipsToBounds = true
        
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        forwardButton.addTarget(self, action: #selector(didTapForward), for: .touchUpInside)
        volumeSlider.addTarget(self, action: #selector(volumeSliderChange), for: .editingChanged)
    }
    
    @objc private func didTapBack() {
        delegate?.playerControlsViewDidTapBackwardsButton(self)
    }
    
    @objc private func didTapPlayPause() {
        delegate?.playerControlsViewDidTapPlayPauseButton(self)
    }
    
    @objc private func didTapForward() {
        delegate?.playerControlsViewDidTapForwardsButton(self)
    }
    
    @objc private func volumeSliderChange(){
        delegate?.playerControlsViewChangeTrackCurrentTime(self)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("PlayerControlsView init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.frame = CGRect(x: 0, y: 0, width: width, height: 50)
        subTitleLabel.frame = CGRect(x: 0, y: nameLabel.bottom+10, width: width, height: 50)
        
        volumeSlider.frame = CGRect(x: 0, y: subTitleLabel.bottom+20, width: width-20, height: 44)
        
        let buttonSize: CGFloat = 60
        playPauseButton.frame = CGRect(
            x: (width-buttonSize)/2,
            y: volumeSlider.bottom+30,
            width: buttonSize,
            height: buttonSize
        )
        backButton.frame = CGRect(
            x: playPauseButton.left-80-buttonSize,
            y: playPauseButton.top,
            width: buttonSize,
            height: buttonSize
        )
        forwardButton.frame = CGRect(
            x: playPauseButton.right+80,
            y: playPauseButton.top,
            width: buttonSize,
            height: buttonSize
        )
    }
    
}
