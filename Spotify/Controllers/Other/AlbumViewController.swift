//
//  AlbumViewController.swift
//  Spotify
//
//  Created by Tarık Nasuhoğlu on 19.10.2021.
//

import UIKit

class AlbumViewController: UIViewController {

    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(
            sectionProvider: { sectionIndex, _ -> NSCollectionLayoutSection? in
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalHeight(1.0))
                )
                
                item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
                
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(100)
                    ),
                    subitem: item,
                    count: 1)
                // Section
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [
                    NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .fractionalWidth(1)),
                        elementKind: UICollectionView.elementKindSectionHeader,
                        alignment: .top)
                ]
                return section
            }
        )
    )
    
    private var viewModels = [RecommendedTrackCellViewModel]()
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
        collectionView.register(RecommendedTrackCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier)
        collectionView.register(PlaylistHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier)
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        
        APICaller.shared.getAlbumDetail(for: albumId) {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let model):
                    self?.album = model
                    self?.title = model.name
                    self?.viewModels = model.tracks.items.compactMap({
                        return RecommendedTrackCellViewModel(
                            name: $0.name,
                            artistName: $0.artists.first?.name ?? "-",
                            artworkURL: URL(string: model.images.randomElement()?.url ?? "")
                        )
                    })
                    self?.collectionView.reloadData()
                    break
                case .failure(let error):
                    HapticsManager.shared.vibrate(for: .error)
                    print("Err55! \(error.localizedDescription)")
                    break
                }
            }
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapShare)
        )
    }
    
    @objc func didTapShare() {
        guard let url = URL(string: album!.externalUrls.spotify) else {
            return
        }
        
        let vc = UIActivityViewController(
            activityItems: [url],
            applicationActivities: []
        )
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        
    }
}

extension AlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier, for: indexPath) as? RecommendedTrackCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: viewModels[indexPath.row])
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier,
            for: indexPath) as? PlaylistHeaderCollectionReusableView, kind == UICollectionView.elementKindSectionHeader
        else {
            return UICollectionReusableView()
        }
        let headerViewModel = PlaylistHeaderViewModel(
            name: album?.name,
            ownerName: album?.artists.first?.name ?? "-",
            description: "Release Date: \(String.formattedDate(string: album?.releaseDate ?? ""))",
            artworkURL: URL(string: album?.images.first?.url ?? "")
        )
        header.configure(with: headerViewModel)
        header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        //Play song func
        
    }
}

extension AlbumViewController: PlaylistHeaderCollectionReusableViewDelegate {
    func playlistHeaderCollectionReusableViewPlayAllButtonTapped(_ header: PlaylistHeaderCollectionReusableView) {
        //Start playlist play all in queue
        print("play All2")
        var tracks = [Track]()
        
        self.album?.tracks.items.compactMap({
            tracks.append(Track(album: nil, artists: nil, availableMarkets: $0.availableMarkets, discNumber: $0.discNumber, durationms: $0.durationms, episode: false, explicit: $0.explicit, externalids: Externalids(isrc: ""), externalUrls: $0.externalUrls, href: $0.href, id: $0.id, isLocal: $0.isLocal, name: $0.name, popularity: 0, previewurl: $0.previewurl, track: true, trackNumber: $0.trackNumber, type: $0.type, uri: $0.uri, restrictions: nil, images: self.album?.images))
        })
        if !tracks.isEmpty {
            PlaybackPresenter.shared.startPlayback(from: self, tracks: tracks)
        }
    }
    
    
}

    
    
