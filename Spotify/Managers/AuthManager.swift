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
        private static var clientID : String = ""
        private static var clientSecret: String = ""
        
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
    
    public var signInURL: URL? {
        let scopes = "user-read-private"
        let redirectURI = "https://www.tnasuh.com"
        let base = "https://accounts.spotify.com/authorize"
        let urlString = "\(base)?response_type=code&client_id=\(Constants.getClientID())&scope=\(scopes)&redirect_uri=\(redirectURI)&show_dialog=TRUE"
        return URL(string: urlString)
    }
    
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
    
    public func exchangeCodeForToken(code: String, completion: @escaping (Bool) -> Void) {
        
    }
    
    public func refreshAccessToken() {
        
    }
    
    public func cacheToken() {
        
    }
}
