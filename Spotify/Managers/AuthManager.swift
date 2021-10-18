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
        static let tokenAPIURL: String = "https://accounts.spotify.com/api/token"
        static let redirectURI = "https://www.tnasuh.com"
        
        static let ud_accessToken = "access_token"
        static let ud_refreshToken = "refresh_token"
        static let ud_expirationDate = "expirationDate"
        
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
        
        let base = "https://accounts.spotify.com/authorize"
        let urlString = "\(base)?response_type=code&client_id=\(Constants.getClientID())&scope=\(scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
        return URL(string: urlString)
    }
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: Constants.ud_accessToken)
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: Constants.ud_refreshToken)
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: Constants.ud_expirationDate) as? Date
    }
    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else { return false }
        let currDate = Date()
        let seconds: TimeInterval = 300 // 300sec = 5min
        return currDate.addingTimeInterval(seconds) >= expirationDate
    }
    
    public func exchangeCodeForToken(code: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: Constants.tokenAPIURL) else {return}
       
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI)
        ]
        
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let basicToken = Constants.getClientID() + ":" + Constants.getClientSecret()
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Err!: Failure to get base64String")
            completion(false)
            return
        }
        req.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        req.httpBody = components.query?.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: req) {[weak self] data, urlResponse, error in
            guard let data = data, error == nil else {
                print("Err!: data error")
                completion(false)
                return
            }
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: result)
                
                completion(true)
            }
            catch{
                print("Err!: \(error.localizedDescription)")
                completion(false)
            }
        }
        task.resume()
    }
    
    public func refreshAccessToken() {
        
    }
    
    public func cacheToken(result: AuthResponse) {
        UserDefaults.standard.setValue(result.access_token, forKey: Constants.ud_accessToken)
        UserDefaults.standard.setValue(result.refresh_token, forKey: Constants.ud_refreshToken)
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: Constants.ud_expirationDate)
    }
}
