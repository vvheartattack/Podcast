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
        setMyPageLayout()
        
        // Do any additional setup after loading the view.
    }
    
    private func setMyPageLayout() {
        let avatarImageView: UIImageView
        
        // Set avatarImageView
        avatarImageView = UIImageView()
        avatarImageView.image = UIImage.init(imageLiteralResourceName: "Avatar.JPG")
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
        avatarImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(150)
        }
        avatarImageView.contentMode = .scaleAspectFit
        
        let outerStackView: UIStackView
        
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
        outerStackView.addArrangedSubview(avatarImageView)
        
    }
    
}
