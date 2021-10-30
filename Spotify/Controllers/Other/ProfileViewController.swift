//
//  ProfileViewController.swift
//  Spotify
//
//  Created by Tarık Nasuhoğlu on 18.10.2021.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var models = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        fetchProfile()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    fileprivate func fetchProfile() {
        APICaller.shared.getCurrentUserProfile { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.updateUI(with: model)
                    break
                case .failure(let error):
                    HapticsManager.shared.vibrate(for: .error)
                    print("Err! getCurrentUserProfile: \(error.localizedDescription)")
                    self?.failedToUserProfile()
                }
            }
            
        }
    }
    private func updateUI(with model: User) {
        tableView.isHidden = false
        // configure table model
        models.append("Fullname: \(model.displayName)")
        models.append("Email: \(model.email)")
        models.append("UserID: \(model.id)")
        models.append("Plan: \(model.product)")
        createTableHeader(with: model.images?.first?.url)
        tableView.reloadData()
    }
    
    private func createTableHeader(with urlString: String?){
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.width/1.5))
        
        let imageSize: CGFloat = headerView.height / 2
        let imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        imageView.center = headerView.center
        imageView.sd_setImage(with: url, completed: nil)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageSize / 2
        headerView.addSubview(imageView)
        
        tableView.tableHeaderView = headerView
        
    }
    
    private func failedToUserProfile() {
        let label = UILabel(frame: .zero)
        label.text = "Failed to load profile"
        label.sizeToFit()
        label.textColor = .secondaryLabel
        view.addSubview(label)
        label.center = view.center
    }
    
    // MARK: TableView
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
}
