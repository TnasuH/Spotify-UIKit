//
//  ViewController.swift
//  Spotify
//
//  Created by Tarık Nasuhoğlu on 18.10.2021.
//

import UIKit

enum BrowseSectionType {
    case newReleases(viewModel: [NewReleasesCellViewModel])        //1
    case featuredPlaylist(viewModel: [FeaturedPlaylistCellViewModel])   //2
    case recommandedTracks(viewModel: [RecommendedTrackCellViewModel])  //3
    
    var title: String {
        switch self {
        case .featuredPlaylist:
            return "Featured Playlist"
        case .newReleases:
            return "New Released Albums"
        case .recommandedTracks:
            return "Recommended"
        }
    }
}

class HomeViewController: UIViewController {
    
    private var newAlbums: [Album] = []
    private var playList: [PlaylistsItem] = []
    private var tracks: [Track] = []
    
    
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            return HomeViewController.createSectionLayout(section: sectionIndex)
        })
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private var sections = [BrowseSectionType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSettings))
        configureCollectionView()
        view.addSubview(spinner)
        fetchData()
        addLongTapGesture()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func addLongTapGesture() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        collectionView.addGestureRecognizer(gesture)
    }
    
    @objc private func didLongPress(_ gesture: UITapGestureRecognizer) {
        guard gesture.state == .began else {
            return
        }
        
        let touchPoint = gesture.location(in: collectionView)
        
        guard let indexPath = collectionView.indexPathForItem(at: touchPoint),
              indexPath.section == 2
        else {
            return
        }
        
        let model = tracks[indexPath.row]
        
        let actionSheet = UIAlertController(title: model.name, message: "Would you like to add to playlist?", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Add", style: .default, handler: {[weak self] _ in
            DispatchQueue.main.async {
                let vc = LibraryPlaylistsViewController()
                vc.selectionHandler = { playlist in
                    APICaller.shared.addTrackToPlaylist(track: model, playlist: playlist) {[weak self] success in
                        DispatchQueue.main.async {
                            if success == false {
                                let alert = UIAlertController(title: "Oups.. Something went wrong", message: "There was an error, please try again", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                                self?.present(alert, animated: true)
                            }
                        }
                    }
                }
                vc.title = "Select playlist"
                self?.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(NewReleaseCollectionViewCell.self, forCellWithReuseIdentifier: NewReleaseCollectionViewCell.identifier)
        collectionView.register(FeaturedPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
        collectionView.register(RecommendedTrackCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier)
        collectionView.register(
            TitleHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TitleHeaderCollectionReusableView.identifier
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
    }
    
    private func fetchData() {
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        var newReleases: NewReleases?
        var featuredPlayList: FeaturedPlaylists?
        var recommendations: Recommendations?
        
        // New Release
        APICaller.shared.getNewReleases { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let model):
                newReleases = model
            case .failure(let error):
                print("Err!1: \(error)")
            }
        }
        
        // Featured playlist
        APICaller.shared.getAllFeaturedPlaylists { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let model):
                featuredPlayList = model
                break
            case .failure(let error):
                print("Err!2: \(error)")
                break
            }
        }
        // Recommended tracks
        APICaller.shared.getGenres { result in
            switch result {
            case .success(let model):
                let genres = model.genres
                var seeds = Set<String>()
                while seeds.count < 4 {
                    if let seed = genres.randomElement() {
                        if !seeds.contains(seed){
                            seeds.insert(seed)
                        }
                    }
                }
                APICaller.shared.getRecommendations(genres: seeds) { resultOfRecommended in
                    defer {
                        group.leave()
                    }
                    switch resultOfRecommended {
                    case .success(let model):
                        recommendations = model
                    case .failure(let error):
                        print("Err!3: \(error)")
                    }
                }
            case .failure(let error):
                print("Err!4: \(error)")
            }
        }
        
        group.notify(queue: .main) {
            guard let releases = newReleases?.albums.items,
                  let playList = featuredPlayList?.playlists.items,
                  let tracks = recommendations else {
                      fatalError("Models are nil")
                  }
            self.configureModels(newAlbums: releases, playList: playList, tracks: tracks.tracks)
        }
    }
    
    private func configureModels(
        newAlbums: [Album],
        playList: [PlaylistsItem],
        tracks: [Track]
    ) {
        self.newAlbums = newAlbums
        self.playList = playList
        self.tracks = tracks
        // Configure Models
        sections.append(.newReleases(viewModel: newAlbums.compactMap({
            return NewReleasesCellViewModel(
                name: $0.name,
                artworkURL: URL(string: $0.images.first?.url ?? ""),
                numberOfTracks: $0.totalTracks,
                artistName: $0.artists.first?.name ?? "-"
            )
        })))
        sections.append(.featuredPlaylist(viewModel: playList.compactMap({
            
            return FeaturedPlaylistCellViewModel(
                name: $0.name,
                artworkURL: URL(string: $0.images.first?.url ?? ""),
                creatorName: $0.owner.name ?? $0.owner.id
            )
        })))
        sections.append(.recommandedTracks(viewModel: tracks.compactMap({
            return RecommendedTrackCellViewModel(
                name: $0.name ,
                artistName: $0.artists?.first?.name ?? "-",
                artworkURL: URL(string: $0.album?.images.first?.url ?? "")
            )
        })))
        collectionView.reloadData()
    }
    
    @objc func didTapSettings() {
        let vc = SettingsViewController()
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        switch type {
        case .featuredPlaylist(viewModel: let viewModels):
            return viewModels.count
        case .newReleases(viewModel: let viewModels):
            return viewModels.count
        case .recommandedTracks(viewModel: let viewModels):
            return viewModels.count
        }
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let type = sections[indexPath.section]
        switch type {
        case .featuredPlaylist(viewModel: let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier,
                for: indexPath)
                    as? FeaturedPlaylistCollectionViewCell  else {
                        return UICollectionViewCell()
                    }
            cell.configure(with: viewModels[indexPath.row])
            return cell
        case .newReleases(viewModel: let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NewReleaseCollectionViewCell.identifier,
                for: indexPath)
                    as? NewReleaseCollectionViewCell  else {
                        return UICollectionViewCell()
                    }
            cell.configure(with: viewModels[indexPath.row])
            return cell
        case .recommandedTracks(viewModel: let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier,
                for: indexPath)
                    as? RecommendedTrackCollectionViewCell else {
                        return UICollectionViewCell()
                    }
            cell.configure(with: viewModels[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TitleHeaderCollectionReusableView.identifier,
            for: indexPath) as? TitleHeaderCollectionReusableView,
              kind == UICollectionView.elementKindSectionHeader else
              {
                  return UICollectionReusableView()
              }
        let title = sections[indexPath.section].title
        header.configure(with: title)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let section = sections[indexPath.section]
        switch section {
        case .featuredPlaylist:
            let playlist = playList[indexPath.row]
            let vc = PlaylistViewController(playlist: playlist)
            vc.title = playlist.name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .recommandedTracks:
            let track = tracks[indexPath.row]
            PlaybackPresenter.shared.startPlayback(from: self, track: track)
        case .newReleases:
            let album = newAlbums[indexPath.row]
            let vc = AlbumViewController(albumId: album.id)
            vc.title = album.name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    private static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        let supplementaryViews = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(75)
                ),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .topLeading
            )
        ]
        
        switch section {
        case 0:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0))
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            // Vertical Group in horizontal group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(390)
                ),
                subitem: item,
                count: 3)
            
            // Horizontal Group in horizontal group
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .absolute(390)
                ),
                subitem: verticalGroup,
                count: 1)
            // Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementaryViews
            return section
        case 1:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(200),
                    heightDimension: .absolute(400))
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(200),
                    heightDimension: .absolute(400)
                ),
                subitem: item,
                count: 2)
            
            // Horizontal Group in horizontal group
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(200),
                    heightDimension: .absolute(400)
                ),
                subitem: verticalGroup,
                count: 1)
            // Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = supplementaryViews
            return section
        case 2:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0))
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(80)
                ),
                subitem: item,
                count: 1)
            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryViews
            return section
        default:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0))
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(390)
                ),
                subitem: item,
                count: 1)
            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryViews
            return section
        }
    }
}
