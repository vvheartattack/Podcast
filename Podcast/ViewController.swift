//
//  ViewController.swift
//  Podcast
//
//  Created by Mika on 2021/2/25.
//

import UIKit

class ViewController: UIViewController {

    var podcasts: [Podcast] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.shared.fetchPodcasts(withSearchKeywords: "nice try") { (podcasts) in
            self.podcasts = podcasts
            print(self.podcasts)
        }
        
        // Do any additional setup after loading the view.
    }


}

