//
//  AuthManager.swift
//  Spotify
//
//  Created by Tarık Nasuhoğlu on 18.10.2021.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    
    struct Constants {
        private static var clientID : String = "" // = "56c8955b963e43b69ee08ed36553cb4e"
        private static var clientSecret: String = "" // = "da90a6ea506e44478feefb8381ddc498"
        
        static func getClientID() -> String {
            if clientID.isEmpty {
                var nsDictionary: NSDictionary?
                 if let path = Bundle.main.path(forResource: "ClientConfig", ofType: "plist") {
                    nsDictionary = NSDictionary(contentsOfFile: path)
                     if let id = nsDictionary?.value(forKey: "ClientID") {
                         clientID = id as! String
                     }
                 }
            }
            return clientID
        }
        static func getClientSecret() -> String {
            if clientSecret.isEmpty {
                var nsDictionary: NSDictionary?
                 if let path = Bundle.main.path(forResource: "ClientConfig", ofType: "plist") {
                    nsDictionary = NSDictionary(contentsOfFile: path)
                     if let id = nsDictionary?.value(forKey: "ClientSecret") {
                         clientSecret = id as! String
                     }
                 }
            }
            return clientSecret
        }
    }
    
    private init() {}
    
    var isSignedIn: Bool {
        return false
    }
    
    private var accessToken: String? {
        return nil
    }
    
    private var refreshToken: String? {
        return nil
    }
    
    private var tokenExpirationDate: Date? {
        return nil
    }
    private var shouldRefreshToken: Bool {
        return false
    }
}
