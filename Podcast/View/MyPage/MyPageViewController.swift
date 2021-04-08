//
//  MyPageViewController.swift
//  Podcast
//
//  Created by Mika on 2021/3/20.
//

import UIKit
import SnapKit

class MyPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
//        setMyPageLayout()
        
        // Do any additional setup after loading the view.
    }
    
    private func setMyPageLayout() {
        let avatarImageView: UIImageView
        let avatarLabel: UILabel
        
        //Set avatarLabel
        avatarLabel = UILabel()
        avatarLabel.text = "Mika"
        avatarLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        avatarLabel.textColor = .black
        
        // Set avatarImageView
        avatarImageView = UIImageView()
        avatarImageView.image = UIImage.init(imageLiteralResourceName: "Avatar.JPG")
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 75
        avatarImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(150)
        }
        avatarImageView.contentMode = .scaleAspectFit
        
        let outerStackView: UIStackView
        let avatarStackView: UIStackView
        
        // Set avatarStackView
        avatarStackView = UIStackView()
        avatarStackView.distribution = .fill
        avatarStackView.alignment = .center
        avatarStackView.axis = .vertical
        avatarStackView.addArrangedSubview(avatarImageView)
        avatarStackView.addArrangedSubview(avatarLabel)
        avatarStackView.spacing = 8
        
        // Set outerStackView
        outerStackView = UIStackView()
        outerStackView.distribution = .fill
        outerStackView.axis = .vertical
        outerStackView.alignment = .center
        self.view.addSubview(outerStackView)
        outerStackView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view)
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
        }
        outerStackView.addArrangedSubview(avatarStackView)
        
    }
    
}
