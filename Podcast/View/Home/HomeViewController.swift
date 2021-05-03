//
//  HomeViewController.swift
//  Podcast
//
//  Created by Mika on 2021/3/20.
//

import UIKit

class HomeViewController: UIViewController {
    static let sectionHeaderElementKind = "section-header-element-kind"
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, PodcastItem>!
    var currentSnapshot: NSDiffableDataSourceSnapshot<Section, PodcastItem>!
    
    /// An enum represents `UICollectionView`'s section, with a `String` raw value to indicate its name.
    enum Section: String {
        case recommendation = "今日推荐"
        case recentSubscribed = "最新订阅"
        case recentUpdeted = "最近更新"
    }
    
    /// We cannot use same item across different sections, this is one workaroud that can make
    /// same podcast different across different sections.
    struct PodcastItem: Hashable {
        var podcast: Podcast
        var section: Section
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
        configureDataSource()
        generateSnapshot()
        
        // Observe `PoscastSubscriptionUpdate` event.
        NotificationCenter.default.addObserver(self, selector: #selector(fetchSubscribedPoscasts), name: Notification.Name("PoscastSubscriptionUpdate"), object: nil)
    }
    
    private func configureCollectionView() {
        // MARK: - UICollectionViewLayout
        func createLayout() -> UICollectionViewLayout {
            let layout = UICollectionViewCompositionalLayout {
                (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
                let section: Section = self.currentSnapshot.sectionIdentifiers[sectionIndex]
                // If there is no data in the section, we need to 'hide' it.
                // For more information, refer to the comments in `generateEmptyLayout()`.
                guard self.currentSnapshot.itemIdentifiers(inSection: section).count != 0 else {
                    return generateEmptyLayout()
                }
                
                switch section {
                case .recommendation:
                    return generateRecommendationLayout()
                case .recentSubscribed:
                    return generateRecentSubscribedLayout()
                case .recentUpdeted:
                    return generateRecentUpdetedLayout()
                }
            }
            return layout
        }
        
        func generateRecommendationLayout() -> NSCollectionLayoutSection {
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1 / 2))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(250), heightDimension: .absolute(168))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 2)
            group.interItemSpacing = .fixed(8)
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: HomeViewController.sectionHeaderElementKind, alignment: .top)
            
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [sectionHeader]
            section.orthogonalScrollingBehavior = .groupPaging
            section.contentInsets = .init(top: 16, leading: 20, bottom: 16, trailing: 20)
            section.interGroupSpacing = 12.0
            
            return section
        }
        
        func generateRecentSubscribedLayout() -> NSCollectionLayoutSection {
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .estimated(270))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: HomeViewController.sectionHeaderElementKind, alignment: .top)
            
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [sectionHeader]
            section.orthogonalScrollingBehavior = .groupPaging
            section.contentInsets = .init(top: 16, leading: 20, bottom: 16, trailing: 20)
            section.interGroupSpacing = 12.0
            
            return section
        }
        
        func generateRecentUpdetedLayout() -> NSCollectionLayoutSection {
            // Not implemented yet...
            generateRecommendationLayout()
        }
        
        /// We need to 'hide' some sections if they have no data. If we create and delete sections in data source, it will be a nightmare
        /// to maintain the order of sections .We just push all sections in, and use this empty layout style to make it easy.
        /// - Returns: An empty collection view layout.
        func generateEmptyLayout() -> NSCollectionLayoutSection {
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        
        // MARK: -  View constrains
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureDataSource() {
        
        // MARK: - Set `RecentlySubscribedPodcastCell` and `RecommendationPodcastCell`.
        let recentlySubscribedPodcastCellRegistration = UICollectionView.CellRegistration<RecentlySubscribedPodcastCell, PodcastItem> { (cell, indexPath, podcastItem) in
            cell.thumbnailView.kf.setImage(with: URL(string: podcastItem.podcast.artworkUrl600!))
            cell.titleLabel.text = podcastItem.podcast.trackName
            cell.authorLabel.text = podcastItem.podcast.artistName
        }
        
        let recommendationPodcastCellRegistration = UICollectionView.CellRegistration<RecommendationPodcastCell, PodcastItem> { (cell, indexPath, podcastItem) in
            cell.thumbnailView.kf.setImage(with: URL(string: podcastItem.podcast.artworkUrl600!))
            cell.titleLabel.text = podcastItem.podcast.trackName
            cell.authorLabel.text = podcastItem.podcast.artistName
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, PodcastItem>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, podcastItem: PodcastItem) -> UICollectionViewCell? in
            let section = self.currentSnapshot.sectionIdentifiers[indexPath.section]
            switch section {
            case .recommendation:
                let cell = collectionView.dequeueConfiguredReusableCell(using: recommendationPodcastCellRegistration, for: indexPath, item: podcastItem)
                return cell
            case .recentSubscribed:
                let cell = collectionView.dequeueConfiguredReusableCell(using: recentlySubscribedPodcastCellRegistration, for: indexPath, item: podcastItem)
                return cell
            case .recentUpdeted:
                let cell = collectionView.dequeueConfiguredReusableCell(using: recentlySubscribedPodcastCellRegistration, for: indexPath, item: podcastItem)
                return cell
            }
        }
        
        // MARK: - Set `HomeSectionHeaderView`.
        
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration
        <HomeSectionHeaderView>(elementKind: HomeViewController.sectionHeaderElementKind) { (supplementaryView, string, indexPath) in
            if let snapshot = self.currentSnapshot {
                // Populate the view with our section's description.
                let section = snapshot.sectionIdentifiers[indexPath.section]
                supplementaryView.sectionTitleLabel.text = section.rawValue
                
                switch section {
                case .recentSubscribed:
                    supplementaryView.setRightButton(for: UIAction (handler: { action in
                        self.navigationController?.pushViewController(SubscribedPodcastsViewController(), animated: true)
                    }))
                default:
                    return
                }
            }
        }
        
        dataSource.supplementaryViewProvider = { (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            if kind == HomeViewController.sectionHeaderElementKind {
                let header = collectionView.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: indexPath)
                return header
            }
            
            return nil
        }
    }
    
    private func generateSnapshot() {
        currentSnapshot = NSDiffableDataSourceSnapshot
            <Section, PodcastItem>()
        currentSnapshot.appendSections([.recommendation, .recentSubscribed, .recentUpdeted])
        
        fetchRecommendations()
        fetchSubscribedPoscasts()
//        fetchRecentUpdatedEpisodes()
        
        dataSource.apply(currentSnapshot, animatingDifferences: false)
    }
    
    private func fetchRecommendations() {
        let podcast1 = Podcast(trackId: 1472032462, trackName: "Nice Try", artistName: "Nice Try Podcast", artworkUrl600: "https://is4-ssl.mzstatic.com/image/thumb/Podcasts124/v4/5a/c2/73/5ac2732b-39c1-7ca1-d8b4-f780aeaded23/mza_1074270643340895275.jpg/600x600bb.jpg", trackCount: 71, feedUrl: "https://nicetrypod.com/episodes/feed.xml")
        let podcast2 = Podcast(trackId: 1512341530, trackName: "郭德纲于谦助眠相声集", artistName: "酸奶酒鬼", artworkUrl600: "https://is2-ssl.mzstatic.com/image/thumb/Podcasts123/v4/0c/71/97/0c71972e-d8e6-aa1b-e2ba-da5fed83e013/mza_1869713097538247862.jpg/600x600bb.jpg", trackCount: 11, feedUrl: "http://www.ximalaya.com/album/37742509.xml")
        let podcast3 = Podcast(trackId: 1166949390, trackName: "日谈公园", artistName: "日谈公园", artworkUrl600: "https://is4-ssl.mzstatic.com/image/thumb/Podcasts124/v4/5e/b1/fd/5eb1fd90-509a-94ce-3e23-3f46c9e520da/mza_6791329813785612578.jpg/600x600bb.jpg", trackCount: 348, feedUrl: "http://www.ximalaya.com/album/5574153.xml")
        let podcast4 = Podcast(trackId: 1493503146, trackName: "忽左忽右", artistName: "JustPod", artworkUrl600: "https://is2-ssl.mzstatic.com/image/thumb/Podcasts123/v4/d1/89/29/d189297e-7498-54bb-5fc9-919d1dd4e702/mza_3939122817325515104.png/600x600bb.jpg", trackCount: 154, feedUrl: "https://justpodmedia.com/rss/left-right.xml")
        let podcast5 = Podcast(trackId: 1487143507, trackName: "不合时宜", artistName: "JustPod", artworkUrl600: "https://is5-ssl.mzstatic.com/image/thumb/Podcasts114/v4/12/9b/31/129b31cc-166a-1799-7085-9e1f0fe5c215/mza_4089001267238303775.png/600x600bb.jpg", trackCount: 73, feedUrl: "https://justpodmedia.com/rss/theweirdo.xml")
        let podcasts = [podcast1, podcast2, podcast3, podcast4, podcast5]
        
        currentSnapshot.appendItems(podcasts.map { PodcastItem(podcast: $0, section: .recommendation)}, toSection: .recommendation)
        dataSource.apply(currentSnapshot, animatingDifferences: false)
    }
    
    
    /// This method is called when: 1. generating initial data source.
    /// 2. `Notification.Name("PoscastSubscriptionUpdate")` happened.
    @objc
    private func fetchSubscribedPoscasts() {
        let podcasts = GRDBHelper.shared.fetchAll(Podcast.self)!
        let oldItems = currentSnapshot.itemIdentifiers(inSection: .recentSubscribed)
        currentSnapshot.deleteItems(oldItems)
        currentSnapshot.appendItems(podcasts.map { PodcastItem(podcast: $0, section: .recentSubscribed)}, toSection: .recentSubscribed)
        dataSource.apply(currentSnapshot)
    }
    
    private func fetchRecentUpdatedEpisodes() {
        // Not implemented yet...
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let podcstItem = dataSource.itemIdentifier(for: indexPath) {
            self.navigationController?.pushViewController(PodcastDetailViewController(podcast: podcstItem.podcast), animated: true)
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
}
