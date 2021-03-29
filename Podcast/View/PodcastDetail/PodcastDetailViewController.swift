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
        let podcastTitleLabel = UILabel()
        let podcastDescriptionLabel = UILabel()
//        var episodeImageView = UIImageView()
        let OuterStackView = UIStackView()
        let podcastStackView = UIStackView()
//        let podcastImageStackView = UIStackView()
        let podcastLabelsStackView = UIStackView()
        let episodeStackView = UIStackView()
        let detailViewScrollView = UIScrollView()

        // Set up podcastImageView
        podcastImageView.kf.setImage(with: URL(string: podcast.artworkUrl600!))
        podcastImageView.layer.cornerRadius = 20
        podcastImageView.clipsToBounds = true
        NSLayoutConstraint.activate([
            podcastImageView.widthAnchor.constraint(equalToConstant: 150),
            podcastImageView.heightAnchor.constraint(equalToConstant: 150),
        ])
        
        
        // Set up podcastTitleLabel
        podcastTitleLabel.text = podcast.trackName
        
        //Set up podcastDescriptionLabel
        podcastDescriptionLabel.text = podcast.artistName
        
        // Set up OuterStackView
        OuterStackView.addArrangedSubview(podcastStackView)
        OuterStackView.addArrangedSubview(episodeStackView)
        OuterStackView.axis = .vertical
        
        // Set up podcastLabelsStackView
        podcastLabelsStackView.addArrangedSubview(podcastTitleLabel)
        podcastLabelsStackView.addArrangedSubview(podcastDescriptionLabel)
        podcastLabelsStackView.axis = .vertical
        

        
        
        // Set up podcastStackView
        podcastStackView.addArrangedSubview(podcastImageView)
        podcastStackView.addArrangedSubview(podcastLabelsStackView)
        podcastStackView.axis = .horizontal
        podcastStackView.alignment = .top
        
        
        // Set up episodeStackView
        
        // Set up detailViewScrollView
        detailViewScrollView.addSubview(OuterStackView)
        
        
//        OuterStackView.distribution = .fillEqually
        OuterStackView.translatesAutoresizingMaskIntoConstraints = false
//        OuterStackView.contentMode = .scaleAspectFit
        self.view.addSubview(OuterStackView)
        NSLayoutConstraint.activate([
            OuterStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            OuterStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            OuterStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            OuterStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -16)
        ])
        
        
        
//        NetworkManager.shared.fetchEpisodes(feedURL: podcast.feedUrl!, completionHandler: { episodes in
//            self.episodes = episodes
//            DispatchQueue.main.async {
//                print(episodes.map{ $0.imageUrl }.filter{   $0 != nil})
//                detailStackView.kf.setImage(with: URL(string: episodes[0].imageUrl!))
//            }
//        })
        
        
        
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
