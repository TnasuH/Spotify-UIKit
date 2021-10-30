//
//  LibraryPlaylistsViewController.swift
//  Spotify
//
//  Created by Tarık Nasuhoğlu on 27.10.2021.
//

import UIKit

class LibraryPlaylistsViewController: UIViewController {

    public var selectionHandler: ((PlaylistsItem) -> Void)?
    
    private var playlists: Playlists?
    
    private let noPlaylistView = ActionLabelView()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)
        tableView.isHidden = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        view.backgroundColor = .systemBackground
        tableView.dataSource = self
        view.addSubview(tableView)
        setupNoPlaylistView()
        fetchData()
        
        if selectionHandler != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        noPlaylistView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        noPlaylistView.center = view.center
        tableView.frame = view.bounds
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    private func fetchData() {
        APICaller.shared.getCurrentUserPlaylists { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let res):
                    if self?.selectionHandler != nil {
                        var myPlaylists = [PlaylistsItem]()
                        res.items.compactMap({
                            if $0.owner.id == PublicConstant.getLoginUserId() {
                                myPlaylists.append($0)
                            }
                        })
                        self?.playlists = Playlists(href: res.href, items: myPlaylists, limit: res.limit, next: res.next, offset: res.offset, previous: res.previous, total: res.total)
                    } else {
                        self?.playlists = res
                    }
                    
                   
                    self?.updateUI()
                case .failure(let error):
                    print("Err!8: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func setupNoPlaylistView() {
        view.addSubview(noPlaylistView)
        noPlaylistView.delegate = self
        noPlaylistView.configure(with: ActionLabelViewViewModel(
            text: "You don't have any playlists yet.", actionTitle: "Create"))
    }
    
    private func updateUI() {
        if let playlist = playlists, playlist.items.isEmpty {
            //show label
            noPlaylistView.isHidden = false
            tableView.isHidden = true
        } else {
            //show table
            noPlaylistView.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
    
    public func showCreatePlaylistAlert() {
        let alert = UIAlertController(
            title: "Create a playlist",
            message: "Please enter a playlist name",
            preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Playlist..."
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { _ in
            guard let field = alert.textFields?.first,
                  let text = field.text,
                  !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                      return
                  }
            APICaller.shared.createPlaylist(with: text) {[weak self] success in
                if success == true {
                    //refresh playlist
                    self?.fetchData()
                    print("asd")
                } else {
                    print("Failed to create the playlist ")
                }
            }
        }))
        present(alert, animated: true)
    }
}

extension LibraryPlaylistsViewController: ActionLabelViewDelegate {
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
        showCreatePlaylistAlert()
    }
}


extension LibraryPlaylistsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else {
            return UITableViewCell()
        }
        let item = playlists!.items[indexPath.row] as PlaylistsItem
        cell.configure(with: SearchResultSubtitleTableViewCellViewModel(title: item.name, subtitle: item.owner.displayName ?? item.owner.name ?? "-", artworkURL: URL(string: item.images.first?.url ?? "")))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let playlist = playlists?.items[indexPath.row] {
            
            guard selectionHandler == nil else {
                selectionHandler?(playlist)
                dismiss(animated: true, completion: nil)
                return
            }
            
            let vc = PlaylistViewController(playlist: playlist)
            vc.isOwner = true
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
