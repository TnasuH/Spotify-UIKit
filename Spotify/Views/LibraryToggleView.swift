//
//  LibraryToggleView.swift
//  Spotify
//
//  Created by Tarık Nasuhoğlu on 27.10.2021.
//

import UIKit


protocol LibraryToggleViewDelegate: AnyObject {
    func LibraryToggleViewDidTapPlaylist(_ toggleView: LibraryToggleView)
    func LibraryToggleViewDidTapAlbums(_ toggleView: LibraryToggleView)
}

class LibraryToggleView: UIView {
    
    weak var delegate: LibraryToggleViewDelegate?
    
    enum State {
        case playlist
        case album
    }
    
    var state: State = .playlist
    
    private let playlistButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Playlists", for: .normal)
        return button
    }()
    private let albumsButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Albums", for: .normal)
        return button
    }()
    
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(albumsButton)
        addSubview(playlistButton)
        addSubview(indicatorView)
        
        playlistButton.addTarget(self, action: #selector(didTapPlaylistButton), for: .touchUpInside)
        albumsButton.addTarget(self, action: #selector(didTapAlbumsButton), for: .touchUpInside)
    }
    
    @objc private func didTapPlaylistButton() {
        state = .playlist
        delegate?.LibraryToggleViewDidTapPlaylist(self)
    }
    
    @objc private func didTapAlbumsButton() {
        state = .album
        delegate?.LibraryToggleViewDidTapAlbums(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("LibraryToggleView init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playlistButton.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        albumsButton.frame = CGRect(x: playlistButton.right+5, y:0, width: 100, height: 40)
        layoutIndicator()
    }
    
    private func layoutIndicator() {
        switch state {
        case .playlist:
            indicatorView.frame = CGRect(x: 0, y: playlistButton.bottom, width: 100, height: 3)
        case .album:
            indicatorView.frame = CGRect(x: 100, y: playlistButton.bottom, width: 100, height: 3)
        }
    }
    
    func update(with state: State) {
        self.state = state
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
    }
}
