//
//  MyPageViewController.swift
//  Podcast
//
//  Created by Mika on 2021/3/20.
//

import UIKit
import SnapKit

class MyPageViewController: UIViewController {
    var loginResult: ResultEntity<Bool>?
    var userID: String?
    var password: String?
    @IBOutlet weak var userIDTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginBtn(_ sender: UIButton) {
        userID = userIDTextField.text
        password = passwordTextField.text
        NetworkManager.shared.login(withUserID: userID!, andPassword: password!, completionHandler: { result in
            self.loginResult = result
            if self.loginResult!.data == true {
                print("login succeeded")
            } else {
                print("login failed")
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
//        setMyPageLayout()
        
        // Do any additional setup after loading the view.
    }
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
