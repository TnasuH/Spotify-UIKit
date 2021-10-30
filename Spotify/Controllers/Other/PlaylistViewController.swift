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
    private var viewModels = [RecommendedTrackCellViewModel]()
    public var isOwner: Bool = false
    
    init(playlist: PlaylistsItem){
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = playlist.name
        view.backgroundColor = .systemBackground
        
        collectionView.register(RecommendedTrackCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier)
        
        collectionView.register(PlaylistHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier)
        
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        
        APICaller.shared.getPlaylists(for: playlist.id) {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print("Err!66 \(error)")
                    HapticsManager.shared.vibrate(for: .error)
                    break
                case .success(let model):
                    self?.playlistDetail = model
                    self?.viewModels = model.tracks.items.compactMap({
                        return RecommendedTrackCellViewModel(
                            name: $0.track.name,
                            artistName: $0.track.artists?.first?.name ?? "-",
                            artworkURL: URL(string: $0.track.album?.images.first?.url ?? "")
                        )
                    })
                    self?.collectionView.reloadData()
                }
            }
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapShare)
        )
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        collectionView.addGestureRecognizer(gesture)
    }
    
    @objc private func didLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else {
            return
        }
        if playlist.owner.id != PublicConstant.getLoginUserId() {
            return
        }
        
        let touchPoint = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: touchPoint) else { return }
        
        if let trackToDelete = self.playlistDetail?.tracks.items[indexPath.row].track {
            
            let actionSheet = UIAlertController(title: "Remove", message: "Would you like to remove this from the playlist?", preferredStyle: .actionSheet)
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            actionSheet.addAction(UIAlertAction(title: "Remove", style: .default, handler: { _ in
                
                APICaller.shared.removeTrackFromPlaylist(track: trackToDelete, playlist: self.playlist) { [weak self] result in
                    DispatchQueue.main.async {
                        if result == false {
                            
                            HapticsManager.shared.vibrate(for: .error)
                            let alert = UIAlertController(title: "Oups.. Something went wrong", message: "Please try again", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                            self?.present(alert,animated:true)
                        } else {
                            HapticsManager.shared.vibrateForSelection()
                            self?.playlistDetail?.tracks.items.remove(at: indexPath.row)
                            self?.viewModels.remove(at: indexPath.row)
                            self?.collectionView.reloadData()
                        }
                    }
                }
                
            }))
            present(actionSheet, animated: true)
        }
        
    }
    
    @objc func didTapShare() {
        guard let url = URL(string: playlist.externalUrls.spotify) else {
            return
        }
        let vc = UIActivityViewController(
            activityItems: [url],
            applicationActivities: []
        )
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}

extension PlaylistViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
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
            name: self.playlist.name,
            ownerName: self.playlist.owner.name ?? self.playlistDetail?.owner.id,
            description: self.playlist.itemDescription,
            artworkURL: URL(string: self.playlist.images.first?.url ?? "")
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

extension PlaylistViewController: PlaylistHeaderCollectionReusableViewDelegate {
    func playlistHeaderCollectionReusableViewPlayAllButtonTapped(_ header: PlaylistHeaderCollectionReusableView) {
        //Start playlist play all in queue
        let tracksList = self.playlistDetail?.tracks.items.compactMap({ $0.track })
        if let tracks = tracksList, tracks.count > 0 {
            PlaybackPresenter.shared.startPlayback(from: self, tracks: tracks)
        }
        
    }
    
    
}
