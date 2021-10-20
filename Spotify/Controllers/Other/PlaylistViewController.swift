//
//  PlaylistViewController.swift
//  Spotify
//
//  Created by Tarık Nasuhoğlu on 18.10.2021.
//

import UIKit

class PlaylistViewController: UIViewController {

    private var playlist: PlaylistsItem
    private var playlistDetail: GetPlaylists?
    init(playlist: PlaylistsItem){
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(playlist)
        title = playlist.name
        view.backgroundColor = .systemBackground
        APICaller.shared.getPlaylists(for: playlist.id) { result in
            switch result {
            case .failure(let error):
                break
            case .success(let model):
                self.playlistDetail = model
                print(model)
                print(self.playlistDetail)
            }
        }
    }
}
