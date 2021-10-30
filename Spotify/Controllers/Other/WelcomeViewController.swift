//
//  WelcomeViewController.swift
//  Spotify
//
//  Created by Tarık Nasuhoğlu on 18.10.2021.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private let signInBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 25
        btn.setTitle("Sign In with Spotify", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        return btn
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "albumCover")
        return imageView
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.6
        return view
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        label.text = "Listen to Millions\nof Songs on\nthe go"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Spotify"
        view.addSubview(imageView)
        view.addSubview(overlayView)
        view.addSubview(signInBtn)
        view.addSubview(label)
        view.addSubview(logoImageView)
        view.backgroundColor = .systemBackground
        signInBtn.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = view.bounds
        overlayView.frame = view.bounds
        signInBtn.frame = CGRect(x: 20,
                                 y: view.height-60-view.safeAreaInsets.bottom,
                                 width: view.width-40,
                                 height: 50)
        
        logoImageView.frame = CGRect(x: (view.width-120)/2, y: (view.height-350)/2, width: 120, height: 120)

        label.frame = CGRect(x: 30, y: logoImageView.bottom+30, width: view.width-60, height: 150)
    }
    
    @objc func didTapSignIn() {
        let vc = AuthViewController()
        vc.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success: success)
            }
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleSignIn(success: Bool){
        // Log user in or yell at them for error
        guard success else {
            let alert = UIAlertController(title: "Oupss!", message: "Something went wrong when signing in", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return
        }
        
        let mainAppTabBarVC = TabBarViewController()
        mainAppTabBarVC.modalPresentationStyle = .fullScreen
        present(mainAppTabBarVC, animated: true)
    }
    
}
