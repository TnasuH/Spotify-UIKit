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
        btn.setTitle("Sign In with Spotify", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Spotify"
        view.backgroundColor = .systemGreen
        view.addSubview(signInBtn)
        signInBtn.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInBtn.frame = CGRect(x: 20,
                                 y: view.height-60-view.safeAreaInsets.bottom,
                                 width: view.width-40,
                                 height: 50)
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
    }
    
}
