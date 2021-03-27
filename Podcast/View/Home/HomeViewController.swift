//
//  HomeViewController.swift
//  Podcast
//
//  Created by Mika on 2021/3/20.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController {
    
    var tableView: UITableView!
    var podcasts: [Podcast] = []
    var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set searchController
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
//        searchController.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = searchController

        
        self.tableView = UITableView()
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "datacell")
        self.tableView.delegate = self
        
        NetworkManager.shared.fetchPodcasts(withSearchKeywords: "郭德纲") { (podcasts) in
            self.podcasts = podcasts
            self.tableView.reloadData()
        }
        

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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,for: indexPath)
        let podcast = podcasts[indexPath.row]
        cell.textLabel?.text = podcast.trackName
        cell.imageView?.image = UIImage(systemName: "tortoise")
        cell.imageView?.kf.setImage(with: URL(string: podcast.artworkUrl600!)) { result in
            cell.setNeedsLayout()
        }
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
        if let searchText = searchController.searchBar.text,
           searchText != "" {
            let searchResults = podcasts.filter({ (podcasts) -> Bool in
                podcasts.trackName!.localizedCaseInsensitiveContains(searchText)
        
            })
        } else {
        }
            
    }
}
