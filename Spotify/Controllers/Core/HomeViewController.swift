//
//  ViewController.swift
//  Spotify
//
//  Created by Tarık Nasuhoğlu on 18.10.2021.
//

import UIKit

enum BrowseSectionType {
    case newReleases(viewModel: [NewReleasesCellViewModel])        //1
    case featuredPlaylist(viewModel: [NewReleasesCellViewModel])   //2
    case recommandedTracks(viewModel: [NewReleasesCellViewModel])  //3
}

class HomeViewController: UIViewController {
    
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(NewReleaseCollectionViewCell.self, forCellWithReuseIdentifier: NewReleaseCollectionViewCell.identifier)
        collectionView.register(FeaturedPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
        collectionView.register(RecommendedTrackCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
    }
    
    private func fetchData() {
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        var newReleases: NewReleaseResponse?
        var featuredPlayList: FeaturedPlaylistResponse?
        var recommendations: RecommendationsResponse?
        
        // New Release
        APICaller.shared.getNewReleases { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let model):
                newReleases = model
            case .failure(let error):
                print("Err!: \(error.localizedDescription)")
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
                print("Err!: \(error.localizedDescription)")
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
                        print("Err!: \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                print("Err!: \(error.localizedDescription)")
            }
        }
        
        group.notify(queue: .main) {
            guard let releases = newReleases?.albums.items,
                  let playList = featuredPlayList?.playlists?.items,
                  let tracks = recommendations else {
                      fatalError("Models are nil")
                      return
                  }
            self.configureModels(newAlbums: releases, playList: playList, tracks: tracks.tracks)
        }
    }
    
    private func configureModels(
        newAlbums: [AlbumElement],
        playList: [PlaylistsItem],
        tracks: [Track]
    ) {
        print("***")
        print(newAlbums.count)
        print(playList.count)
        print(tracks.count)
        print("---")
        // Configure Models
        sections.append(.newReleases(viewModel: newAlbums.compactMap({
            return NewReleasesCellViewModel(
                name: $0.name,
                artworkURL: URL(string: $0.images.first?.url ?? ""),
                numberOfTracks: 4,
                artistName: $0.artists.first?.name ?? "-"
            )
        })))
        sections.append(.featuredPlaylist(viewModel: playList.compactMap({
            return NewReleasesCellViewModel(
                name: $0.name,
                artworkURL: URL(string: $0.images.first?.url ?? ""),
                numberOfTracks: $0.tracks.total,
                artistName: "-"
            )
        })))
        sections.append(.recommandedTracks(viewModel: tracks.compactMap({
            return NewReleasesCellViewModel(
                name: $0.name ?? "-",
                artworkURL: URL(string: $0.album?.images.first?.url ?? ""),
                numberOfTracks: 4,
                artistName: $0.artists.first?.name ?? "-"
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
        print("arribaa")
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
            cell.backgroundColor = .green
            return cell
        case .newReleases(viewModel: let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NewReleaseCollectionViewCell.identifier,
                for: indexPath)
            as? NewReleaseCollectionViewCell  else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        case .recommandedTracks(viewModel: let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier,
                for: indexPath)
            as? RecommendedTrackCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.backgroundColor = .blue
            return cell
        }
        
       
    }
    
    private static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
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
            return section
        }
    }
}
