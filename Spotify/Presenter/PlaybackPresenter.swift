//
//  PlaybackPresenter.swift
//  Spotify
//
//  Created by Tarık Nasuhoğlu on 26.10.2021.
//

import Foundation
import UIKit

final class PlaybackPresenter {
    
    static func startPlayback(
        from viewController:UIViewController,
        track: Track) {
            let vc = PlayerViewController()
            viewController.present(vc, animated: true, completion: nil)
    }
    
    static func startPlayback(
        from viewController:UIViewController,
        tracks: [Track]) {
            let vc = PlayerViewController()
            viewController.present(vc, animated: true, completion: nil)
    }
    
}
