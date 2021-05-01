//
//  PodcastDetailViewController.swift
//  Podcast
//
//  Created by Mika on 2021/3/21.
//

import UIKit
import Kingfisher
import FeedKit
import GRDB

class PodcastDetailViewController: UIViewController {

    var podcast: Podcast
    var episodes: [Episode] = []
    var episodeViews: [UIView] = []
    
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
        labelStackView.distribution = .fill
        labelStackView.alignment = .fill
        
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
        self.view.backgroundColor = .systemBackground
        
        let podcastImageView = UIImageView()
        let podcastTitleLabel = UILabel()
        let podcastDescriptionLabel = UILabel()
        let outerStackView = UIStackView()
        let podcastStackView = UIStackView()
        let podcastLabelsStackView = UIStackView()
        let episodeStackView = UIStackView()
        let detailViewScrollView = UIScrollView()
        
        
        // Set up subcribeButton
        let subcribeButton = UIButton(type: .custom)
//        subcribeButton.frame = CGRect(x: <#T##CGFloat#>, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
//        subcribeButton.setTitle("订阅", for: .normal)
        subcribeButton.setTitleColor(.white, for: .normal)
        subcribeButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
//        subcribeButton.backgroundColor = #colorLiteral(red: 0, green: 0.4739482999, blue: 0.9821667075, alpha: 1)
        subcribeButton.layer.cornerRadius = 5
        subcribeButton.snp.makeConstraints { make in
            make.width.equalTo(65)
            make.height.equalTo(26)
        }
        do {
            try GRDBHelper.shared.dbQueue.read { db in
                let matchedNumber = try Podcast.filter(Podcast.Columns.trackId == podcast.trackId).fetchCount(db)
                if matchedNumber == 0 {
                    subcribeButton.setTitle("订阅", for: .normal)
                    subcribeButton.backgroundColor = #colorLiteral(red: 0, green: 0.4739482999, blue: 0.9821667075, alpha: 1)
                    
                } else {
                    subcribeButton.setTitle("已订阅", for: .normal)
                    subcribeButton.backgroundColor = .gray
                }
            }
        } catch {
            print(error)
        }
        subcribeButton.addTarget(self, action: #selector(subcribeButtonClicked(sender:)), for: .touchUpInside)
        
        // Set up detailViewScrollView
        detailViewScrollView.translatesAutoresizingMaskIntoConstraints = false
        // If the content is not high enough, still make it scrollable.
        detailViewScrollView.alwaysBounceVertical = true
        self.view.addSubview(detailViewScrollView)
        NSLayoutConstraint.activate([
            detailViewScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            detailViewScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            detailViewScrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            detailViewScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        // Set up podcastImageView
        podcastImageView.kf.setImage(with: URL(string: podcast.artworkUrl600!))
        podcastImageView.layer.cornerRadius = 20
        podcastImageView.clipsToBounds = true
        podcastImageView.translatesAutoresizingMaskIntoConstraints = false
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
        
        
        // Set up podcastLabelsStackView
        podcastLabelsStackView.addArrangedSubview(podcastTitleLabel)
        podcastLabelsStackView.addArrangedSubview(podcastDescriptionLabel)
        podcastLabelsStackView.addArrangedSubview(subcribeButton)
        podcastLabelsStackView.axis = .vertical
        podcastLabelsStackView.distribution = .equalSpacing
        podcastLabelsStackView.alignment = .leading
        
        // Set up podcastStackView
        podcastStackView.addArrangedSubview(podcastImageView)
        podcastStackView.addArrangedSubview(podcastLabelsStackView)
        podcastStackView.axis = .horizontal
        podcastStackView.alignment = .top
        podcastStackView.distribution = .fill
        podcastStackView.spacing = 16
        
        // Set up episodeStackView
        episodeStackView.translatesAutoresizingMaskIntoConstraints = false
        episodeStackView.axis = .vertical
        episodeStackView.spacing = 16
        episodeStackView.alignment = .fill
        episodeStackView.distribution = .fill
        
        // Set up OuterStackView
        outerStackView.translatesAutoresizingMaskIntoConstraints = false
        outerStackView.addArrangedSubview(podcastStackView)
        outerStackView.addArrangedSubview(episodeStackView)
        outerStackView.axis = .vertical
        outerStackView.spacing = 16
        outerStackView.alignment = .fill
        outerStackView.distribution = .fill
        // https://useyourloaf.com/blog/adding-padding-to-a-stack-view/
        // We can set the margin of a UIStackView this way:
        outerStackView.isLayoutMarginsRelativeArrangement = true
        outerStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        detailViewScrollView.addSubview(outerStackView)
        NSLayoutConstraint.activate([
            outerStackView.leadingAnchor.constraint(equalTo: detailViewScrollView.leadingAnchor),
            outerStackView.trailingAnchor.constraint(equalTo: detailViewScrollView.trailingAnchor),
            outerStackView.topAnchor.constraint(equalTo: detailViewScrollView.topAnchor),
            outerStackView.bottomAnchor.constraint(equalTo: detailViewScrollView.bottomAnchor),
            // THIS ONE IS IMPORTANT!!!!!
            // UIScrollView needs not only leading, trailing, top and bottom constrains, but also width(sometimes also height).
            // https://stackoverflow.com/questions/33333943/dynamic-uistackview-inside-of-uiscrollview
            // If we use an UIStackView right inside an UIScrollView, we only need to set the width anchor.
            outerStackView.widthAnchor.constraint(equalTo: detailViewScrollView.widthAnchor),
        ])
        
        // Fetch episodes data
        NetworkManager.shared.fetchEpisodes(feedURL: podcast.feedUrl!, completionHandler: { episodes in
            self.episodes = episodes
            DispatchQueue.main.async {
                // We can use `.enumerated()` to traverse with index and item in an array.
                // We only display no more than 15 episodes
                for (index, episode) in episodes.enumerated() where index < 15 {
                    let episodeView = self.viewForPerEpisode(episode: episode)
                    episodeStackView.addArrangedSubview(episodeView)
                    
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.episodeTapped))
                    episodeView.addGestureRecognizer(tapGesture)
                    
                    self.episodeViews.append(episodeView)
                }
            }
        })
    }
    
    @objc func episodeTapped(sender: UITapGestureRecognizer) {
        if let episodeView = sender.view, let index = episodeViews.firstIndex(of: episodeView) {
            let playerViewController: PlayerViewController = PlayerViewController(episode: episodes[index])
            self.navigationController?.pushViewController(_: playerViewController, animated: true)
        }
    }
    
    @objc func subcribeButtonClicked(sender: UIButton) {


                            
        if sender.titleLabel?.text == "订阅" {
            sender.setTitle("已订阅", for: .normal)
            sender.backgroundColor = .gray
            GRDBHelper.shared.save(podcast)
        } else {
            sender.setTitle("订阅", for: .normal)
            sender.backgroundColor = #colorLiteral(red: 0, green: 0.4739482999, blue: 0.9821667075, alpha: 1)
            GRDBHelper.shared.deleteSubcribedPodcast(podcast)
        }
        NotificationCenter.default.post(name: Notification.Name("PoscastSubscriptionUpdate"), object: nil)
    }
}

