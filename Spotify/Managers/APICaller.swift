//
//  APICaller.swift
//  Spotify
//
//  Created by Tarık Nasuhoğlu on 18.10.2021.
//

import Foundation

final class APICaller {
    
    static let shared = APICaller()
    
    private init() {
    }
    
    struct Constants {
        static let baseAPIURL = "https://api.spotify.com/v1"
    }
    
    enum APIError: Error {
        case failedToGetData
    }
    
    // MARK: - Browse API
    
    public func getNewReleases(completion: @escaping (Result<NewReleaseResponse, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/new-releases?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(NewReleaseResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    print("Err!: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getAllFeaturedPlaylists(completion: @escaping (Result<FeaturedPlaylistResponse, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/featured-playlists"), type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, urlResponse, error in
                guard let data = data, error == nil else {
                    print("-----2")
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let res = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    print("res is \(res)")
                    
                    let result = try JSONDecoder().decode(FeaturedPlaylistResponse.self, from: data)
                    print("******")
                    completion(.success(result))
                }
                catch {
                    
                    print("-----1 \(error.localizedDescription)")
                    print("-----1.1 \(error)")
                    
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getGenres(completion: @escaping (Result<RecommendedGenresResponse, Error>) -> Void) {
                createRequest(with: URL(string: Constants.baseAPIURL + "/recommendations/available-genre-seeds"), type: .GET) { baseRequest in
                    let task = URLSession.shared.dataTask(with: baseRequest) { data, urlResponse, error in
                        guard let data = data, error == nil else {
                            completion(.failure(APIError.failedToGetData))
                            return
                        }
                        do {
                            let result = try JSONDecoder().decode(RecommendedGenresResponse.self, from: data)
                            completion(.success(result))
                        }
                        catch {
                            completion(.failure(error))
                        }
                    }
                    task.resume()
                }
            }
    
    public func getRecommendations(genres: Set<String>, completion: @escaping (Result<RecommendationsResponse, Error>) -> Void) {
        print("asd \(genres)")
        let seeds = genres.joined(separator: ",")
        createRequest(with: URL(string: Constants.baseAPIURL + "/recommendations?limit=2&seed_genres=\(seeds)"),
                      type: .GET) { request in
            print("baseRequest is: \(request.url?.absoluteString)")
            let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                print("!! \(data) \(error) \(urlResponse)")
                guard let data = data, error == nil else {
                    print("errr1")
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
                    print("Recommendations!! \(result)")
                    completion(.success(result))
                }
                catch {
                    print("errr2")
                    print(error.localizedDescription)
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - User Profile API
    
    public func getCurrentUserProfile(completion: @escaping (Result<User, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/me"),
                      type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with:  baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(User.self, from: data)
                    completion(.success(result))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Private
    
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    private func createRequest(with url: URL?,
                               type: HTTPMethod,
                               completion: @escaping (URLRequest) -> Void) {
        
        AuthManager.shared.withValidToken { token in
            guard let apiURL = url else { return }
            print("Bearer \(token)")
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
         
    }
    
}
