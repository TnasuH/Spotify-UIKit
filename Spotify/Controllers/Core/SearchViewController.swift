//
//  SearchViewController.swift
//  Spotify
//
//  Created by Tarık Nasuhoğlu on 18.10.2021.
//

import UIKit
import SafariServices

class SearchViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    private let searchController : UISearchController = {
        let vc = UISearchController(searchResultsController: SearchResultsViewController())
        vc.searchBar.placeholder = "Search in Songs, Artists, Albums"
        vc.searchBar.searchBarStyle = .minimal
        print("****")
        print(vc.searchBar.center.y/2)
        vc.definesPresentationContext = true
        return vc
    }()
    
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
            let item = NSCollectionLayoutItem(layoutSize:NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 2,
                leading: 7,
                bottom: 2,
                trailing: 7
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(150)),
                subitem: item,
                count: 2
            )
            
            group.contentInsets = NSDirectionalEdgeInsets(
                top: 10,
                leading: 0,
                bottom: 10,
                trailing: 0
            )
            
            
            return NSCollectionLayoutSection(group: group)
        })
    )
    
    private var categories = [CategoryItem]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        view.addSubview(collectionView)
        collectionView.register(CategoryCollectionViewCell.self,
                                forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        APICaller.shared.getCategories { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let categories):
                    self?.categories = categories
                    self?.collectionView.reloadData()
                    
                    //Hide searchBar like whatsapp search
//                    DispatchQueue.main.async {
//                        self?.collectionView.contentOffset = CGPoint(x: 0, y: self!.collectionView.contentOffset.y + 14);
//                    }
                    break
                case .failure(let error):
                    print(error)
                    
                    HapticsManager.shared.vibrate(for: .error)
                    break
                }
            }
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        navigationItem.largeTitleDisplayMode = .always
//        let indexPath = NSIndexPath(row: 0, section: 0) as IndexPath
//        collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.top, animated: true)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        
        // resultController.update(with: results)
        // Perform search
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let resultController = searchController.searchResultsController as? SearchResultsViewController,
              let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        resultController.delegate = self
        
        APICaller.shared.search(with: query) {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    resultController.update(with: results)
                case .failure(let error):
                    print(error.localizedDescription)
                    HapticsManager.shared.vibrate(for: .error)
                }
            }
        }
    }
}

extension SearchViewController: SearchResultsViewControllerDelegate {
    func didTapSearchResult(_ result: SearchResult) {
        switch result {
        case .artist(model: let artist):
            if let url = URL(string: artist.externalUrls.spotify) {
                let vc = SFSafariViewController(url: url)
                present(vc, animated:true)
            }
        case .track(model: let track):
            //vc = TrackViewController(track: track)
            PlaybackPresenter.shared.startPlayback(from: self, track: track)
            break
        case .album(model: let album):
            let vc = AlbumViewController(albumId: album.id)
            navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .playlist(model: let playlist):
            let vc = PlaylistViewController(playlist: playlist)
            navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        let category = categories[indexPath.row]
        cell.configure(with: CategoryCollectionViewCellViewModel(
            title: category.name,
            artworkURL: URL(string: category.icons.first?.url ?? "" )))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        HapticsManager.shared.vibrateForSelection()
        collectionView.deselectItem(at: indexPath, animated: true)
        let category = categories[indexPath.row]
        let vc = CategoryViewController(category: category)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
}
