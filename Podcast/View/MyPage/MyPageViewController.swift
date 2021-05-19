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
    var loginStatus: Bool = false
    @IBOutlet weak var userIDTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginBtn(_ sender: UIBarButtonItem) {
        userID = userIDTextField.text
        password = passwordTextField.text
        NetworkManager.shared.login(withUserID: userID!, andPassword: password!, completionHandler: { result in
            self.loginResult = result
            if self.loginResult!.data == true {
                print("login succeeded")
                self.loginStatus = true
                self.dismiss(animated: true, completion: nil)
            } else {
                print("login failed")
                print(result.message)
                let alertView = UIAlertController.init(title: "提示", message: "该用户名已存在，您输入的密码错误！\n请重新输入！", preferredStyle: .alert)

                let alert = UIAlertAction.init(title: "确定", style: .destructive){(UIAlertAction) in
                    print("确定按钮点击")
                    self.userIDTextField.text = ""
                    self.passwordTextField.text = ""
                }
//                let cancleAlert = UIAlertAction.init(title: "取消", style: .cancel){(UIAlertAction) in
//                        print("点击取消按钮")
//                }
//                alertView.addAction(cancleAlert)
                alertView.addAction(alert);
                self.present(alertView, animated: true, completion: nil)
                self.loginStatus = false
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
//        setMyPageLayout()
        
        // Do any additional setup after loading the view.
    }
    
}
