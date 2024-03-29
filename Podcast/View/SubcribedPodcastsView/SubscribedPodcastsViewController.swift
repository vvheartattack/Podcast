//
//  SubcribedPodcastsViewController.swift
//  Podcast
//
//  Created by Mika on 2021/4/21.
//

import UIKit
import GRDB
import SnapKit

class SubscribedPodcastsViewController: UIViewController {
    var tableView: UITableView!
    var podcasts: [Podcast] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.title = "已订阅"
        self.tableView = UITableView()
        fetchData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateSubscribedPodcast(_:)), name: .podcastSubscriptionUpdate, object: nil)
        
        // Set tableView
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.bottom.trailing.leading.equalToSuperview()
        }
        self.tableView.dataSource = self
        self.tableView.register(SearchViewTableViewCell.self, forCellReuseIdentifier: "datacell")
        self.tableView.delegate = self

        // Do any additional setup after loading the view.
    }
    @objc func didUpdateSubscribedPodcast(_ notification: Notification)
    {
        fetchData()
    }
    
    func fetchData() {
        podcasts = SubscribeHelper.fetchAllByTimeOrder()
        self.tableView.reloadData()
    }
    
}

extension SubscribedPodcastsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let podcastDetailVC = PodcastDetailViewController(podcast: podcasts[indexPath.row])
        self.navigationController?.pushViewController(podcastDetailVC, animated: true)
    }
    
}

extension SubscribedPodcastsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "datacell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SearchViewTableViewCell
        let podcast = podcasts[indexPath.row]
        cell.cellIamgeView.kf.setImage(with: URL(string: podcast.artworkUrl600!)) { result in
            cell.setNeedsLayout()
        }
        cell.titleLabel.text = podcast.trackName
        cell.descriptionLabel.text = podcast.artistName
        cell.titleLabel.sizeToFit()
        cell.descriptionLabel.sizeToFit()
        return cell
    }
    
    
    
}
