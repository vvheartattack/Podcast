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
    
    private func viewForPerEpisode(episode: Episode) -> UIView {
        let view = UIView()
        let outerStackView = UIStackView()
        let labelStackView = UIStackView()
        let episodeTitleLabel = UILabel()
        let episodeDescriptionLabel = UILabel()
        let episodeImageView = UIImageView()
//        let episodeDateLabel = UILabel()
        
        // Set Up font of labels
        episodeDescriptionLabel.textColor = UIColor.gray
        episodeDescriptionLabel.font = .systemFont(ofSize: 17)
        episodeTitleLabel.text = episode.title
        episodeTitleLabel.font = .systemFont(ofSize: 17, weight: .medium)
        
        episodeDescriptionLabel.text = episode.description
//        episodeDateLabel.text = String(episode.pubDate)
        episodeImageView.kf.setImage(with: URL(string: episode.imageUrl!))
        
        // Set Up labelStackView
        labelStackView.addArrangedSubview(episodeTitleLabel)
        labelStackView.addArrangedSubview(episodeDescriptionLabel)
        labelStackView.axis = .vertical
        
        // Set up outerStackView
        episodeImageView.layer.cornerRadius = 10
        episodeImageView.clipsToBounds = true
        episodeImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            episodeImageView.widthAnchor.constraint(equalToConstant: 60),
            episodeImageView.heightAnchor.constraint(equalToConstant: 60),
        ])
        outerStackView.addArrangedSubview(episodeImageView)
        outerStackView.axis = .horizontal
        outerStackView.alignment = .top
        outerStackView.distribution = .fill
        outerStackView.addArrangedSubview(labelStackView)
        
        outerStackView.spacing = 16
        
        view.addSubview(outerStackView)
        outerStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            outerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            outerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            outerStackView.topAnchor.constraint(equalTo: view.topAnchor),
            outerStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
//        self.view.backgroundColor = UIColor(red: 239, green: 239, blue: 239, alpha: 1)
        
        
        let podcastImageView = UIImageView()
        let podcastTitleLabel = UILabel()
        let podcastDescriptionLabel = UILabel()
        let outerStackView = UIStackView()
        let podcastStackView = UIStackView()
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
        podcastTitleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        
        //Set up podcastDescriptionLabel
        podcastDescriptionLabel.text = podcast.artistName
        podcastDescriptionLabel.textColor = UIColor.gray
        podcastDescriptionLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        
        // Set up OuterStackView
        outerStackView.addArrangedSubview(podcastStackView)
        outerStackView.addArrangedSubview(episodeStackView)
        outerStackView.axis = .vertical
        outerStackView.spacing = 16
        
        // Set up podcastLabelsStackView
        podcastLabelsStackView.addArrangedSubview(podcastTitleLabel)
        podcastLabelsStackView.addArrangedSubview(podcastDescriptionLabel)
        podcastLabelsStackView.axis = .vertical
        

        
        
        // Set up podcastStackView
        podcastStackView.addArrangedSubview(podcastImageView)
        podcastStackView.addArrangedSubview(podcastLabelsStackView)
        podcastStackView.axis = .horizontal
        podcastStackView.alignment = .top
        podcastStackView.spacing = 16
        
        
        // Set up episodeStackView
        NetworkManager.shared.fetchEpisodes(feedURL: podcast.feedUrl!, completionHandler: { episodes in
            self.episodes = episodes
            DispatchQueue.main.async {
                for i in episodes {
                    episodeStackView.addArrangedSubview(self.viewForPerEpisode(episode: i))
                }
            }
        })
        
        episodeStackView.axis = .vertical
        episodeStackView.spacing = 16
        
        // Set up detailViewScrollView
        detailViewScrollView.addSubview(outerStackView)
        
        
//        OuterStackView.distribution = .fillEqually
        outerStackView.translatesAutoresizingMaskIntoConstraints = false
//        OuterStackView.contentMode = .scaleAspectFit
        self.view.addSubview(outerStackView)
        NSLayoutConstraint.activate([
            outerStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            outerStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            outerStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            outerStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -16)
        ])
        detailViewScrollView.addSubview(outerStackView)
        detailViewScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailViewScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            detailViewScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            detailViewScrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            detailViewScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        self.view.addSubview(detailViewScrollView)
        
        
        
        
        
        
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

}
