//
//  TabBarViewController.swift
//  Spotify
//
//  Created by Tarık Nasuhoğlu on 18.10.2021.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let homeNC = createNavController(for: HomeViewController(), title: "Home", image: UIImage(systemName:"house"), selectedImage: UIImage(systemName:"house"), tagForTabBarItem: 1)
        let searchNC =  createNavController(for: SearchViewController(), title: "Search", image: UIImage(systemName:"magnifyingglass"), selectedImage: UIImage(systemName:"magnifyingglass"), tagForTabBarItem: 2)
        let libNC = createNavController(for: LibraryViewController(), title: "Library",image: UIImage(systemName: "music.note.list"), selectedImage: UIImage(systemName: "music.note.list"), tagForTabBarItem: 3)
        
        setViewControllers([homeNC, searchNC, libNC], animated: false)
        
        
    }

    fileprivate func createNavController(for rootViewController: UIViewController,
                                         title: String, image: UIImage?, selectedImage: UIImage?, tagForTabBarItem: Int) -> UINavigationController {
        rootViewController.title = title
        rootViewController.navigationItem.largeTitleDisplayMode = .always
        let nc = UINavigationController(rootViewController: rootViewController)
        nc.navigationBar.prefersLargeTitles = true
        nc.tabBarItem.title = title
        nc.tabBarItem.image = image
        nc.tabBarItem.selectedImage = image
        nc.tabBarItem.tag = tagForTabBarItem
        nc.navigationBar.tintColor = .label
        //navController.tabBarItem.selectedImage = selectedImage
        //navController.tabBarItem.image = image
        
        return nc
    }
    
}
