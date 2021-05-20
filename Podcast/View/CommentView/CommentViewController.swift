//
//  CommentViewController.swift
//  Podcast
//
//  Created by jjaychen on 2021/5/20.
//

import UIKit

class CommentViewController: UIViewController {
    @IBOutlet var inputFieldView: UIView!
    @IBOutlet var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotificationHandler), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotificationHandler), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShowNotificationHandler(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
           let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double) {
            UIView.animate(withDuration: duration) {
                self.inputFieldView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -keyboardSize.size.height)
            }
        }
    }
    
    @objc func keyboardWillHideNotificationHandler(notification: NSNotification) {
        if let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double) {
            UIView.animate(withDuration: duration) {
                self.inputFieldView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: 0)
            }
        }
    }

    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

}