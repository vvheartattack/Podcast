//
//  SearchViewController.swift
//  Podcast
//
//  Created by Mika on 2021/5/3.
//

import UIKit
import Kingfisher
import Alamofire

class SearchViewController: UIViewController {
    
    var tableView: UITableView!
    var podcasts: [Podcast] = []
    var searchController: UISearchController!
    var searchRequest: DataRequest?

    override func viewDidLoad() {
        super.viewDidLoad()

        //set searchController
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = searchController

        
        self.tableView = UITableView()
//        self.tableView.backgroundColor = UIColor(red: 239, green: 239, blue: 239, alpha: 1)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        self.tableView.dataSource = self
        self.tableView.register(SearchViewTableViewCell.self, forCellReuseIdentifier: "datacell")
        self.tableView.delegate = self
        
        self.updateSearchResults(for: searchController)

        // Do any additional setup after loading the view.
    }
}


// MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "datacell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,for: indexPath) as! SearchViewTableViewCell
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

// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let podcastDetailVC = PodcastDetailViewController(podcast: podcasts[indexPath.row])
        podcastDetailVC.view.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1)
        self.navigationController?.pushViewController(podcastDetailVC, animated: true)
    }
}

// MARK: - UISearchResultsUPdating
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchRequest?.cancel()
        searchRequest = nil
        let searchText: String? = searchController.searchBar.text
        
        if searchText != "" {
            searchRequest = NetworkManager.shared.fetchPodcasts(withSearchKeywords: searchText!) { (podcasts) in
                self.podcasts = podcasts
                self.tableView.reloadData()
            }
        } else {

            let podcast1 = Podcast(trackId: 1472032462, trackName: "Nice Try", artistName: "Nice Try Podcast", artworkUrl600: "https://is4-ssl.mzstatic.com/image/thumb/Podcasts124/v4/5a/c2/73/5ac2732b-39c1-7ca1-d8b4-f780aeaded23/mza_1074270643340895275.jpg/600x600bb.jpg", trackCount: 71, feedUrl: "https://nicetrypod.com/episodes/feed.xml")
            let podcast2 = Podcast(trackId: 1512341530, trackName: "郭德纲于谦助眠相声集", artistName: "酸奶酒鬼", artworkUrl600: "https://is2-ssl.mzstatic.com/image/thumb/Podcasts123/v4/0c/71/97/0c71972e-d8e6-aa1b-e2ba-da5fed83e013/mza_1869713097538247862.jpg/600x600bb.jpg", trackCount: 11, feedUrl: "http://www.ximalaya.com/album/37742509.xml")
            let podcast3 = Podcast(trackId: 1166949390, trackName: "日谈公园", artistName: "日谈公园", artworkUrl600: "https://is4-ssl.mzstatic.com/image/thumb/Podcasts124/v4/5e/b1/fd/5eb1fd90-509a-94ce-3e23-3f46c9e520da/mza_6791329813785612578.jpg/600x600bb.jpg", trackCount: 348, feedUrl: "http://www.ximalaya.com/album/5574153.xml")
            let podcast4 = Podcast(trackId: 1493503146, trackName: "忽左忽右", artistName: "JustPod", artworkUrl600: "https://is2-ssl.mzstatic.com/image/thumb/Podcasts123/v4/d1/89/29/d189297e-7498-54bb-5fc9-919d1dd4e702/mza_3939122817325515104.png/600x600bb.jpg", trackCount: 154, feedUrl: "https://justpodmedia.com/rss/left-right.xml")
            let podcast5 = Podcast(trackId: 1487143507, trackName: "不合时宜", artistName: "JustPod", artworkUrl600: "https://is5-ssl.mzstatic.com/image/thumb/Podcasts114/v4/12/9b/31/129b31cc-166a-1799-7085-9e1f0fe5c215/mza_4089001267238303775.png/600x600bb.jpg", trackCount: 73, feedUrl: "https://justpodmedia.com/rss/theweirdo.xml")
            self.podcasts = [podcast1, podcast2, podcast3, podcast4, podcast5]
            self.tableView.reloadData()
        }
    }
}
