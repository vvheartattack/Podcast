//
//  SearchViewTableViewCell.swift
//  Podcast
//
//  Created by Mika on 2021/3/28.
//

import UIKit

class SearchViewTableViewCell: UITableViewCell {
    let cellIamgeView: UIImageView
    let titleLabel: UILabel
    let descriptionLabel: UILabel
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        cellIamgeView = UIImageView()
        titleLabel = UILabel()
        descriptionLabel = UILabel()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Setup titleLabel
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        
        // Setup descriptionLabel
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = UIColor.gray
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .callout)
            
        // Setup cellIamgeView
        cellIamgeView.layer.cornerRadius = 20
        cellIamgeView.clipsToBounds = true
        NSLayoutConstraint.activate([
            cellIamgeView.widthAnchor.constraint(equalToConstant: 120),
            cellIamgeView.heightAnchor.constraint(equalToConstant: 120),
        ])
        
        let innerStackView: UIStackView = UIStackView()
        innerStackView.distribution = .fill
        innerStackView.addArrangedSubview(titleLabel)
        innerStackView.addArrangedSubview(descriptionLabel)
        innerStackView.axis = .vertical
        
        let outerStackView: UIStackView = UIStackView()
        outerStackView.alignment = .top
        outerStackView.addArrangedSubview(cellIamgeView)
        outerStackView.addArrangedSubview(innerStackView)
        outerStackView.axis = .horizontal
        outerStackView.spacing = 16
        
        self.contentView.addSubview(outerStackView)
        outerStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            outerStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            outerStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            outerStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
            outerStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
