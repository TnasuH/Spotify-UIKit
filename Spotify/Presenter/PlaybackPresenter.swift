//
//  PlaybackPresenter.swift
//  Spotify
//
//  Created by Tarık Nasuhoğlu on 26.10.2021.
//

import Foundation
import UIKit
import AVFoundation

protocol PlayerDataSource: AnyObject {
    var songName: String? { get }
    var subTitle: String? { get }
    var artworkURL: URL? { get }
}

final class PlaybackPresenter {
    
    static let shared = PlaybackPresenter()
    
    private var track: Track?
    private var tracks = [Track]()
    private var currentTrackIndex = 0
    
    var currentTrack: Track? {
        if let track = track, tracks.isEmpty {
            return track
        }
        else if !tracks.isEmpty {
            return tracks[currentTrackIndex]
        }
        return nil
    }
    
    var player: AVPlayer?
    var playerItems = [AVPlayerItem]()
    var playerVC: PlayerViewController?
    
    func startPlayback(
        from viewController:UIViewController,
        track: Track) {
            guard let url = URL(string: track.previewurl ?? "") else { return }
            player = AVPlayer(url: url)
            let vc = PlayerViewController()
            self.track = track
            self.tracks = []
            vc.title = track.name
            vc.dataSource = self
            vc.delegate = self
            viewController.present(UINavigationController(rootViewController: vc), animated: true) { [weak self] in
                self?.player?.play()
            }
            self.playerVC = vc
        }
    
    func startPlayback(
        from viewController:UIViewController,
        tracks: [Track]) {
            self.track = nil
            self.tracks = tracks.filter({ $0.previewurl != nil })
            self.currentTrackIndex = 0
            guard let url = URL(string: self.tracks[currentTrackIndex].previewurl ?? "") else { return }
            player = AVPlayer(url: url)
            self.playerItems = self.tracks.compactMap({
                AVPlayerItem(url: URL(string: $0.previewurl!)!)
            })
            self.player?.volume = 0.5
            let vc = PlayerViewController()
            vc.dataSource = self
            vc.delegate = self
            viewController.present(UINavigationController(rootViewController: vc), animated: true) { [weak self] in
                self?.player?.play()
            }
            self.playerVC = vc
        }
}

extension PlaybackPresenter: PlayerViewControllerDelegate {
    func sliderValueChanged(_ value: Float) {
        player?.volume = value
    }
    
    func didTapPlayPause() {
        if let player = player {
            if player.timeControlStatus == .playing {
                player.pause()
            } else if player.timeControlStatus == .paused {
                player.play()
            }
        }
    }
    
    func didTapForward() {
        if tracks.isEmpty {
            // Not playlist or album
            player?.pause()
            player?.replaceCurrentItem(with: AVPlayerItem(url: URL(string: currentTrack!.previewurl!)!))
            player?.play()
        } else if !playerItems.isEmpty {
            if currentTrackIndex + 1 > playerItems.count {
                currentTrackIndex = 0
            } else {
                currentTrackIndex += 1;
            }
            player?.replaceCurrentItem(with: playerItems[currentTrackIndex])
            player?.play()
            playerVC?.refreshUI()
        }
    }
    
    func didTapBackward() {
        if tracks.isEmpty {
            // Not playlist or album
            player?.pause()
            player?.replaceCurrentItem(with: AVPlayerItem(url: URL(string: currentTrack!.previewurl!)!))
            player?.play()
        } else {
            if currentTrackIndex - 1 < 0 {
                currentTrackIndex = (playerItems.count - 1) < 0 ? 0 : (playerItems.count - 1)
            } else {
                currentTrackIndex -= 1
            }
            player?.replaceCurrentItem(with: playerItems[currentTrackIndex])
            player?.play()
            self.playerVC?.refreshUI()
        }
    }
}

extension PlaybackPresenter: PlayerDataSource {
    var songName: String? {
        return currentTrack?.name
    }
    
    var subTitle: String? {
        return currentTrack?.artists?.first?.name
    }
    
    var artworkURL: URL? {
        if let url = currentTrack?.album?.images.first?.url {
            return URL(string: url)
        }
        if let trackImageUrl = currentTrack?.images?.first?.url {
            return URL(string: trackImageUrl)
        }
        return nil
    }
}
