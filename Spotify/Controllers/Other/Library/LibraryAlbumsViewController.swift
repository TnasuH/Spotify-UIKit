//
//  LibraryAlbumsViewController.swift
//  Spotify
//
//  Created by Tarık Nasuhoğlu on 27.10.2021.
//

import UIKit

class LibraryAlbumsViewController: UIViewController {

    private var albums = [Album]()
    
    private let noAlbumsView = ActionLabelView()
    
    private let albumTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)
        tableView.isHidden = true
        return tableView
    }()
    
    private var notificationObserver : NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        albumTableView.delegate = self
        view.backgroundColor = .systemBackground
        albumTableView.dataSource = self
        view.addSubview(albumTableView)
        setupNoAlbumsView()
        fetchData()
        notificationObserver = NotificationCenter.default.addObserver(forName: .albumSavedNotification, object: nil, queue: .main, using: { [weak self] _ in
            self?.fetchData()
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noAlbumsView.frame = CGRect(x: (view.width-150)/2, y: (view.height-150)/2, width: 150, height: 150)
        albumTableView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    private func fetchData() {
        albums.removeAll()
        APICaller.shared.getCurrentUserAlbums { [weak self] result in
            DispatchQueue.main.async {
                self?.updateUI()
                switch result {
                case .success(let res):
                    self?.albums = res
                    self?.updateUI()
                case .failure(let error):
                    HapticsManager.shared.vibrate(for: .error)
                    print("Err!8: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func setupNoAlbumsView() {
        view.addSubview(noAlbumsView)
        noAlbumsView.delegate = self
        noAlbumsView.configure(with: ActionLabelViewViewModel(
            text: "You have not save any albums yet.", actionTitle: "Browse"))
    }
    
    private func updateUI() {
        
        if albums.count != 0 {
            //show table
            noAlbumsView.isHidden = true
            albumTableView.isHidden = false
            albumTableView.reloadData()
        } else {
            //hide table
            noAlbumsView.isHidden = false
            albumTableView.isHidden = true
            
        }
    }
}

extension LibraryAlbumsViewController: ActionLabelViewDelegate {
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
        tabBarController?.selectedIndex = 0
    }
}


extension LibraryAlbumsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else {
            return UITableViewCell()
        }
        let item = albums[indexPath.row] as Album
        cell.configure(with: SearchResultSubtitleTableViewCellViewModel(title: item.name, subtitle: item.artists.first?.name ?? item.artists.first?.id ?? "-", artworkURL: URL(string: item.images.first?.url ?? "")))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        let album = self.albums[indexPath.row]
        let vc = AlbumViewController(albumId: album.id)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
