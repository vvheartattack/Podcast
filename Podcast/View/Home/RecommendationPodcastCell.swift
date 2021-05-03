//
//  RecommendationPodcastCell.swift
//  Podcast
//
//  Created by Mika on 2021/5/3.
//

import UIKit

class RecommendationPodcastCell: UICollectionViewCell {
    static let reuseIdentifer = "recommendation-podcast-cell"
    let thumbnailView = UIImageView()
    let titleLabel = UILabel()
    let authorLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure() {
        contentView.addSubview(thumbnailView)
        thumbnailView.layer.masksToBounds = true
        thumbnailView.layer.cornerRadius = 8
        thumbnailView.layer.borderWidth = 1
        thumbnailView.layer.borderColor = #colorLiteral(red: 0.9198423028, green: 0.9198423028, blue: 0.9198423028, alpha: 1)
        thumbnailView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalTo(thumbnailView.snp.height)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.numberOfLines = 1
        titleLabel.font = .systemFont(ofSize: 17, weight: .medium)
        titleLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.leading.equalTo(thumbnailView.snp.trailing).offset(5)
        }
        
        contentView.addSubview(authorLabel)
        authorLabel.numberOfLines = 1
        authorLabel.font = .systemFont(ofSize: 15, weight: .regular)
        authorLabel.textColor = #colorLiteral(red: 0.5771534443, green: 0.5771534443, blue: 0.5771534443, alpha: 1)
        authorLabel.snp.makeConstraints { make in
            make.leading.equalTo(thumbnailView.snp.trailing).offset(5)
            make.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
    }
}
