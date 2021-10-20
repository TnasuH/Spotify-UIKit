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
    
    // MARK: - Albums
    
    public func getAlbumDetail(for albumId: String, completion: @escaping (Result<GetAlbums,Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/albums/" + albumId), type: .GET)
        { request in
            let task = URLSession.shared.dataTask(with: request, completionHandler: { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(GetAlbums.self, from: data)
                    completion(.success(result))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            })
            task.resume()
        }
    }
    
    // MARK: - Playlist
    
    // MARK: - Browse API
    
    public func getNewReleases(completion: @escaping (Result<NewReleases, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/new-releases?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(NewReleases.self, from: data)
                    completion(.success(result))
                } catch {
                    print("Err!: \(error)")
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getAllFeaturedPlaylists(completion: @escaping (Result<FeaturedPlaylists, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/featured-playlists?limit=20"), type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, urlResponse, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(FeaturedPlaylists.self, from: data)
                    completion(.success(result))
                }
                catch {
                    print(error)
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
    
    public func getRecommendations(genres: Set<String>, completion: @escaping (Result<Recommendations, Error>) -> Void) {
        let seeds = genres.joined(separator: ",")
        createRequest(with: URL(string: Constants.baseAPIURL + "/recommendations?limit=10&seed_genres=\(seeds)"),
                      type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(Recommendations.self, from: data)
                    completion(.success(result))
                }
                catch {
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
            var request = URLRequest(url: apiURL)
            print(token)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
         
    }
    
}
