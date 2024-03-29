//
//  AuthManager.swift
//  Spotify
//
//  Created by Tarık Nasuhoğlu on 18.10.2021.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    
    private var refreshingToken = false
    
    struct Constants {
        private static var clientID : String = ""
        private static var clientSecret: String = ""
        static let tokenAPIURL: String = "https://accounts.spotify.com/api/token"
        static let redirectURI = "http://www.tnasuh.com"
        static let scopes = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
        
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
        
        let base = "https://accounts.spotify.com/authorize"
        let urlString = "\(base)?response_type=code&client_id=\(Constants.getClientID())&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
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
        //Get_Token
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
    
    private var onRefreshBlock = [((String) -> Void)]()
    
    /// Supplies valid token to be used with API Calls
    public func withValidToken(completion: @escaping (String) -> Void) {
        guard !refreshingToken else {
            // append the completion
            onRefreshBlock.append(completion)
            return
        }
        
        if shouldRefreshToken {
            // refresh
            refreshIfNeeded { [weak self]success in
                if success {
                    if let token = self?.accessToken, success {
                        completion(token)
                    }
                }
            }
        } else if let token = accessToken {
            completion(token)
        }
    }
    
    public func refreshIfNeeded(completion: ((Bool) -> Void)?) {
        guard !refreshingToken else {
            return
        }
        
        guard shouldRefreshToken else {
            completion?(true)
            return
        }
        guard let refreshToken = self.refreshToken else {
            return
        }
        // refresh the token
        guard let url = URL(string: Constants.tokenAPIURL) else {return}
       
        refreshingToken = true
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]
        
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let basicToken = Constants.getClientID() + ":" + Constants.getClientSecret()
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Err!: Failure to get base64String")
            completion?(false)
            return
        }
        req.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        print("base64String")
        req.httpBody = components.query?.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: req) {[weak self] data, urlResponse, error in
            self?.refreshingToken = false
            guard let data = data, error == nil else {
                print("Err!: data error")
                completion?(false)
                return
            }
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.onRefreshBlock.forEach{ $0(result.access_token) }
                self?.onRefreshBlock.removeAll()
                self?.cacheToken(result: result)                
                completion?(true)
            }
            catch{
                print("Err!: \(error)")
                completion?(false)
            }
        }
        task.resume()
    }
    
    public func cacheToken(result: AuthResponse) {
        UserDefaults.standard.setValue(result.access_token, forKey: Constants.ud_accessToken)
        if let refresh_token = result.refresh_token {
            UserDefaults.standard.setValue(refresh_token, forKey: Constants.ud_refreshToken)
        }
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: Constants.ud_expirationDate)
    }
    
    public func signOut(completion: (Bool) -> Void) {
        UserDefaults.standard.setValue(nil, forKey: Constants.ud_accessToken)
        UserDefaults.standard.setValue(nil, forKey: Constants.ud_refreshToken)
        UserDefaults.standard.setValue(nil, forKey: Constants.ud_expirationDate)
        UserDefaults.standard.setValue(nil, forKey: PublicConstant.ud_loginUserId)
        completion(true)
    }
}
