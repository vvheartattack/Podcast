//
//  NetworkManager.swift
//  Podcast
//
//  Created by Mika on 2021/3/15.
//

import Foundation
import Alamofire
import FeedKit
class NetworkManager {
    
    /// 这是一个 NetworkManager 类的单例对象。
    static let shared = NetworkManager()
    
    func fetchPodcasts(withSearchKeywords keywords: String, completionHandler: @escaping ([Podcast]) -> ()) -> DataRequest {
        let parameters = ["term": keywords, "media": "podcast"]
        return AF.request("https://itunes.apple.com/search", method: .get, parameters: parameters)
            .response { (response) in
                guard response.error == nil  else {
                    print("iTunes podcast request failed", response.error!)
                    return
                }
                
                if let data = response.data {
                    do {
                        let results = try JSONDecoder().decode(SearchResults.self, from: data)
                        completionHandler(results.results)
                    } catch let error {
                        print("Failed to decode. Error: \(error)")
                    }
                }
            }
    }
    
    func fetchEpisodes(feedURL: String, completionHandler: @escaping ([Episode]) -> ()) {
        guard let url = URL(string: feedURL) else { return }
        let parser = FeedParser(URL: url)
        parser.parseAsync(result: { (result) in
            switch result {
            case .success(let feed):
                // Grab the parsed feed directly as an optional rss, atom or json feed object
                guard let feed = feed.rssFeed else { return }
                    
                let episodes = feed.toEpisodes()
                completionHandler(episodes)
                    
            case .failure(let error):
                print(error)
                }
            })
    }
    
    func login(withUserID userID: String, andPassword password: String, completionHandler: @escaping (ResultEntity<Bool>) -> ()) -> DataRequest {
        let parameters = ["name": userID, "password": password]
        return AF.request("http://127.0.0.1:8080/login", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
            .response { (response) in
                guard response.error == nil  else {
                    print("login request failed", response.error!)
                    return
                }
                
                if let data = response.data {
                    do {
                        let result = try JSONDecoder().decode(ResultEntity<Bool>.self, from: data)
                        completionHandler(result)
                    } catch let error {
                        print("Failed to decode. Error: \(error)")
                    }
                }
        }
    }
    
    func fetchComment(withPodcastTrackID podcastTrackID: Int, andEpisodeID episodeID: String, completionHandler: @escaping (ResultEntity<[Comment]>) -> ()) -> DataRequest {
        let parameters = ["podcastTrackID": podcastTrackID, "episodeID": episodeID] as [String : Any]
        return AF.request("http://127.0.0.1:8080/comment",method: .get, parameters: parameters)
            .response { (response) in
                guard response.error == nil  else {
                    print("fetch comments failed", response.error!)
                    return
                }
                
                if let data = response.data {
                    do {
                        let results = try JSONDecoder().decode(ResultEntity<[Comment]>.self, from: data)
                        completionHandler(results)
                    } catch let error {
                        print("Failed to decode. Error: \(error)")
                    }
                }
            }
    }
    
    func postComment(withPodcastTrackID podcastTrackID: Int, andEpisodeID episodeID: String, andUserName userName: String, andCommentContent commentContent: String, completionHandler: @escaping (ResultEntity<Comment>) -> ()) -> DataRequest {
        let parameters: [String: Any] = ["podcastTrackID": podcastTrackID, "episodeID": episodeID, "userName": userName, "commentContent": commentContent]
        return AF.request("http://127.0.0.1:8080/comment", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
            .response { (response) in
                guard response.error == nil  else {
                    print("post comment request failed", response.error!)
                    return
                }
                
                if let data = response.data {
                    do {
                        let result = try JSONDecoder().decode(ResultEntity<Comment>.self, from: data)
                        completionHandler(result)
                    } catch let error {
                        print("Failed to decode. Error: \(error)")
                    }
                }
            }
        
    }
}
