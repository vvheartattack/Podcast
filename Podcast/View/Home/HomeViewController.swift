//
//  HomeViewController.swift
//  Podcast
//
//  Created by Mika on 2021/3/20.
//

import UIKit
import Kingfisher
import Alamofire

class HomeViewController: UIViewController {
    
    var tableView: UITableView!
    var podcasts: [Podcast] = []
    var searchController: UISearchController!
    var searchRequest: DataRequest?

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = UIColor(red: 239, green: 239, blue: 239, alpha: 1)
        
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

extension HomeViewController: UITableViewDataSource {
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
//        cell.textLabel?.text = podcast.trackName
//        cell.imageView?.image = UIImage(systemName: "tortoise")
//        cell.imageView?.kf.setImage(with: URL(string: podcast.artworkUrl600!)) { result in
//            cell.setNeedsLayout()
//        }
        cell.titleLabel.sizeToFit()
        cell.descriptionLabel.sizeToFit()
        return cell
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let podcastDetailVC = PodcastDetailViewController(podcast: podcasts[indexPath.row])
        podcastDetailVC.view.backgroundColor = .white
        self.navigationController?.pushViewController(podcastDetailVC, animated: true)
    }
}

// MARK: - UISearchResultsUPdating
extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchRequest?.cancel()
        searchRequest = nil
        if let searchText = searchController.searchBar.text {
            searchRequest = NetworkManager.shared.fetchPodcasts(withSearchKeywords: searchText) { (podcasts) in
                self.podcasts = podcasts
                self.tableView.reloadData()
            }
        } else {
            self.podcasts = []
            self.tableView.reloadData()
        }
    }
}
