//
//  CommentViewController.swift
//  Podcast
//
//  Created by jjaychen on 2021/5/20.
//

import UIKit

class CommentViewController: UIViewController {
    @IBOutlet var inputTextField: UITextField!
    @IBOutlet weak var inputFieldView: UIView!
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var outerStackView: UIStackView!
    @IBOutlet var templateStackView: UIStackView!
    
    var podcast: Podcast?
    var episode: Episode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let inputText = inputTextField.text!
        outerStackView.removeArrangedSubview(templateStackView)
        
        podcast = Podcast(trackId: 1234)
        episode = Episode(guid: "alsdj", title: "", pubDate: Date(), description: "", author: "", streamUrl: "")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotificationHandler), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotificationHandler), name: UIResponder.keyboardWillHideNotification, object: nil)
        NetworkManager.shared.postComment(withPodcastTrackID: podcast!.trackId, andEpisodeID: episode!.guid, andUserName: "GlobalCache.shared.loginResult!.name", andCommentContent: inputText, completionHandler: { result in
            print(result)
            
        })
        
        NetworkManager.shared.fetchComment(withPodcastTrackID: podcast!.trackId, andEpisodeID: episode!.guid) { result in
            result.data.forEach { comment in
                self.outerStackView.addArrangedSubview(self.generateViewFor(comment: comment))
            }
        }
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
    
    func generateViewFor(comment: Comment) -> UIView {
        let outerVStack = UIStackView()
        outerVStack.axis = .vertical
        outerVStack.distribution = .fill
        outerVStack.alignment = .fill
        outerVStack.spacing = 8
        
        let innerHStack = UIStackView()
        innerHStack.axis = .horizontal
        innerHStack.distribution = .fill
        innerHStack.alignment = .top
        innerHStack.spacing = 10
        outerVStack.addArrangedSubview(innerHStack)
        
        let avatar = UIImageView()
        avatar.layer.masksToBounds = true
        avatar.layer.cornerRadius = 20
        avatar.image = UIImage(named: "Avatar")
        avatar.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
        innerHStack.addArrangedSubview(avatar)
        
        let innterVStack = UIStackView()
        innterVStack.axis = .vertical
        innterVStack.distribution = .fill
        innterVStack.alignment = .top
        innterVStack.spacing = 10
        innerHStack.addArrangedSubview(innterVStack)
        
        let nameLabel = UILabel()
        nameLabel.text = comment.userName
        nameLabel.textColor = .black
        nameLabel.font = .systemFont(ofSize: 20, weight: .medium)
        nameLabel.textAlignment = .left
        innterVStack.addArrangedSubview(nameLabel)
        
        let contentLabel = UILabel()
        contentLabel.text = comment.commentContent
        contentLabel.textColor = .black
        contentLabel.font = .systemFont(ofSize: 17, weight: .regular)
        contentLabel.textAlignment = .left
        innterVStack.addArrangedSubview(contentLabel)
        
        let timeLabel = UILabel()
        timeLabel.text = comment.commentContent
        timeLabel.textColor = .gray
        timeLabel.font = .systemFont(ofSize: 15, weight: .medium)
        timeLabel.textAlignment = .right
        outerVStack.addArrangedSubview(timeLabel)
        
        return outerVStack
    }

}
