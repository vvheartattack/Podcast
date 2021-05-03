//
//  RecentlySubscribedPodcastCell.swift
//  Podcast
//
//  Created by Mika on 2021/5/3.
//

import UIKit

class RecentlySubscribedPodcastCell: UICollectionViewCell {
    static let reuseIdentifer = "recently-subscribed-podcast-cell"
    let thumbnailView = UIImageView()
    let tagLabel = UILabel()
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
            make.top.leading.trailing.equalToSuperview()
            make.width.equalTo(thumbnailView.snp.height)
        }
        
        contentView.addSubview(tagLabel)
        tagLabel.text = "新订阅"
        tagLabel.font = .systemFont(ofSize: 14, weight: .bold)
        tagLabel.textColor = #colorLiteral(red: 0.5723067522, green: 0.5723067522, blue: 0.5723067522, alpha: 1)
        tagLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(thumbnailView.snp.bottom).offset(8)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.numberOfLines = 1
        titleLabel.font = .systemFont(ofSize: 17, weight: .medium)
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(tagLabel.snp.bottom).offset(4)
        }
        
        contentView.addSubview(authorLabel)
        authorLabel.numberOfLines = 1
        authorLabel.font = .systemFont(ofSize: 15, weight: .regular)
        authorLabel.textColor = #colorLiteral(red: 0.5771534443, green: 0.5771534443, blue: 0.5771534443, alpha: 1)
        authorLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
    }
}
