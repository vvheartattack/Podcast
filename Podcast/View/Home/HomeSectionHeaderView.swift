//
//  HomeSectionHeaderView.swift
//  Podcast
//
//  Created by Mika on 2021/5/3.
//

import UIKit

class HomeSectionHeaderView: UICollectionReusableView {
    
    let sectionTitleLabel = UILabel()
    var rightButton = UIButton()
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      configure()
    }

    required init?(coder: NSCoder) {
      fatalError()
    }
    
    func configure() {
        addSubview(sectionTitleLabel)
        sectionTitleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        sectionTitleLabel.font = .systemFont(ofSize: 24, weight: .bold)
    }
    
    func setRightButton(for action: UIAction?) {
        rightButton.removeFromSuperview()
        
        if let action = action {
            rightButton = UIButton()
            addSubview(rightButton)
            sectionTitleLabel.snp.remakeConstraints { make in
                make.leading.top.bottom.equalToSuperview()
            }
            rightButton.snp.makeConstraints { make in
                make.top.trailing.bottom.equalToSuperview()
                make.leading.equalTo(sectionTitleLabel.snp.trailing)
            }
            rightButton.setTitleColor(.systemBlue, for: .normal)
            rightButton.setTitleColor(UIColor.systemBlue.withAlphaComponent(0.5), for: .highlighted)
            rightButton.setTitle("查看全部", for: .normal)
            rightButton.titleLabel?.font = .systemFont(ofSize: 17)
            rightButton.addAction(action, for: .touchUpInside)
        }
    }
}
