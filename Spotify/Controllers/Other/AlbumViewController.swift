//
//  AlbumViewController.swift
//  Spotify
//
//  Created by Tarık Nasuhoğlu on 19.10.2021.
//

import UIKit

class AlbumViewController: UIViewController {

    private var album: GetAlbums?
    private var albumId: String!
    
    
    init(albumId: String){
        self.albumId = albumId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Album"
        view.backgroundColor = .systemBackground
        APICaller.shared.getAlbumDetail(for: albumId) { result in
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let model):
                    self.album = model
                    self.title = model.name
                    
                    print(self.album)
                    break
                case .failure(let error):
                    break
                }
            }
        }
    }
}
