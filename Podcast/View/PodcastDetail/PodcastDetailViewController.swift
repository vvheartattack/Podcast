//
//  PodcastDetailViewController.swift
//  Podcast
//
//  Created by Mika on 2021/3/21.
//

import UIKit
import Kingfisher
import FeedKit

class PodcastDetailViewController: UIViewController {

    var podcast: Podcast
    var episodes: [Episode] = []
    init(podcast: Podcast) {
        self.podcast = podcast
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let podcastImageView = UIImageView()
        podcastImageView.translatesAutoresizingMaskIntoConstraints = false
        podcastImageView.contentMode = .scaleAspectFit
        self.view.addSubview(podcastImageView)
        NSLayoutConstraint.activate([
            podcastImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            podcastImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            podcastImageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            podcastImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        podcastImageView.kf.setImage(with: URL(string: podcast.artworkUrl600!))
        let episodeImageView = UIImageView()
        episodeImageView.translatesAutoresizingMaskIntoConstraints = false
        episodeImageView.contentMode = .scaleAspectFit
        self.view.addSubview(episodeImageView)
        NSLayoutConstraint.activate([
            episodeImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            episodeImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            episodeImageView.topAnchor.constraint(equalTo: podcastImageView.bottomAnchor),
            episodeImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        NetworkManager.shared.fetchEpisodes(feedURL: podcast.feedUrl!, completionHandler: { episodes in
            self.episodes = episodes
            episodeImageView.kf.setImage(with: URL(string: episodes[0].imageUrl ?? ""))
        })
        
        
        
//        let label = UILabel()
//        label.text = "123"
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.sizeToFit()
//        self.view.addSubview(label)
//        NSLayoutConstraint.activate([
//            label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
//        ])
        
        
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
