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
    
    func fetchPodcasts(withSearchKeywords keywords: String, completionHandler: @escaping ([Podcast]) -> ()) {
        let parameters = ["term": keywords, "media": "podcast"]
        AF.request("https://itunes.apple.com/search", method: .get, parameters: parameters)
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
        DispatchQueue.global(qos: .background).async {
            
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
    }
}
