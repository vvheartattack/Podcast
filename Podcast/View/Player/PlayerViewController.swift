//
//  PlayerViewController.swift
//  Podcast
//
//  Created by Mika on 2021/4/4.
//

import UIKit
import AVFoundation
import SnapKit
import Kingfisher

class PlayerViewController: UIViewController {
    let episode: Episode
    var podcastPlayer: AVPlayer?
    var playerItem: AVPlayerItem?
    
    var episodeImageView: UIImageView!
    var playbackSlider: UISlider!
    var overallTimeLabel: UILabel!
    var currentTimeLabel: UILabel!
    var playButton: UIButton!
    var forwardButton: UIButton!
    var backwardButton: UIButton!
    
    
    init(episode: Episode) {
        self.episode = episode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.largeTitleDisplayMode = .never
        
        let view: UIView
        view = setLayout()
        self.view = view
        
        DispatchQueue.main.async {
            let url = URL(string: self.episode.streamUrl)
            
            let playerItem = AVPlayerItem(url: url!)
            self.playerItem = playerItem
            
            let podcastPlayer = AVPlayer(playerItem: playerItem)
            self.podcastPlayer = podcastPlayer
            
            let duration = playerItem.asset.duration
            let seconds = CMTimeGetSeconds(duration)
            let secondsInt = Int(seconds)
            
            // Set playbackSlider
            self.playbackSlider.minimumValue = 0
            self.playbackSlider.maximumValue = Float(seconds)
            self.playbackSlider.isContinuous = true
            
            // 小时：分钟：秒，确保每个单位有两位数字
            self.overallTimeLabel.text = String(format: "%02d:%02d:%02d", secondsInt / 3600, secondsInt / 60 % 60, secondsInt % 60)
            self.currentTimeLabel.text = String(format: "%02d:%02d:%02d", 0, 0, 0)
            
            // 播放器每播放 1 秒钟调用一次
            podcastPlayer.addPeriodicTimeObserver(forInterval: .init(seconds: 1, preferredTimescale: 1), queue: .main) { (cmTime) in
                if podcastPlayer.currentItem?.status == .readyToPlay {
                    let time = CMTimeGetSeconds(podcastPlayer.currentTime())
                    let timeInt = Int(time)
                    self.playbackSlider.value = Float(time)
                    self.currentTimeLabel.text = String(format: "%02d:%02d:%02d", timeInt / 3600, timeInt / 60 % 60, timeInt % 60)
                }
                
                let playbackLikelyToKeepUP = podcastPlayer.currentItem?.isPlaybackLikelyToKeepUp
                if playbackLikelyToKeepUP == false {
                    // 等待加载中
                } else {
                    // 可以正常播放
                }
            }
            
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    private func setLayout() -> UIView {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .medium)
        let playButtonConfig = UIImage.SymbolConfiguration(pointSize: 35, weight: .medium)
        
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let imageContainerView = UIView()
        view.addSubview(imageContainerView)
        imageContainerView.snp.makeConstraints { make in
            make.height.equalTo(320)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        let rightBarButtonItemShare = UIBarButtonItem()
        rightBarButtonItemShare.image = UIImage(systemName: "square.and.arrow.up")
        rightBarButtonItemShare.action = #selector(shareEpisode)
        rightBarButtonItemShare.target = self
        
        let rightBarButtonItemComment = UIBarButtonItem()
        rightBarButtonItemComment.image = UIImage(systemName: "ellipsis.bubble")
        rightBarButtonItemComment.action = #selector(showCommentView)
        rightBarButtonItemComment.target = self
        
        // Set episodeImageView
        episodeImageView = UIImageView()
        episodeImageView.layer.cornerRadius = 35
        episodeImageView.clipsToBounds = true
        imageContainerView.addSubview(episodeImageView)
        episodeImageView.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(300)
            make.width.equalTo(episodeImageView.snp.height)
        }
        episodeImageView.transform = .identity.scaledBy(x: 0.9, y: 0.9)
        episodeImageView.contentMode = .scaleAspectFit
        episodeImageView.kf.setImage(with: URL(string: episode.imageUrl!))
        
        // Podcast title
        let podcastNameLabel = UILabel()
        
        // Episode title
        let episodeNameLabel = UILabel()
        episodeNameLabel.text = episode.title
        episodeNameLabel.font = .systemFont(ofSize: 20, weight: .bold)
        episodeNameLabel.textAlignment = .center
        episodeNameLabel.numberOfLines = 0
        view.addSubview(episodeNameLabel)
        episodeNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageContainerView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        // Episode subtitle label
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let episodeSubtitleLabel = UILabel()
        view.addSubview(episodeSubtitleLabel)
        episodeSubtitleLabel.text = episode.author + "\(episode.author == "" ? "" : " · ")" + dateFormatter.string(from: episode.pubDate)
        episodeSubtitleLabel.font = .systemFont(ofSize: 17, weight: .medium)
        episodeSubtitleLabel.textColor = #colorLiteral(red: 0.6999999881, green: 0.6999999881, blue: 0.6999999881, alpha: 1)
        episodeSubtitleLabel.textAlignment = .center
        episodeSubtitleLabel.numberOfLines = 0
        episodeSubtitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(episodeNameLabel.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        // Set playbackSlider
        playbackSlider = UISlider()
        view.addSubview(playbackSlider)
        playbackSlider.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(episodeSubtitleLabel.snp.bottom).offset(16)
        }
        playbackSlider.addAction(UIAction(handler: { (action) in
            if let sender = action.sender as? UISlider, let podcastPlayer = self.podcastPlayer {
                let sliderValue = sender.value
                let targetTime = CMTimeMake(value: Int64(sliderValue), timescale: 1)
                podcastPlayer.seek(to: targetTime)
            }
            
        }), for: .valueChanged)
        
        playbackSlider.addAction(UIAction(handler: { (action) in
            if let sender = action.sender as? UISlider, let podcastPlayer = self.podcastPlayer {
                let sliderValue = sender.value
                let targetTime = CMTimeMake(value: Int64(sliderValue), timescale: 1)
                podcastPlayer.seek(to: targetTime)
                podcastPlayer.pause()
                self.playButton.setImage(UIImage(systemName: "play")?.withConfiguration(playButtonConfig), for: .normal)
                UIView.animate(withDuration: 0.3) {
                    self.episodeImageView.transform = .identity.scaledBy(x: 0.9, y: 0.9)
                }
            }
            
        }), for: .valueChanged)
        
        // Set overall time label
        overallTimeLabel = UILabel()
        overallTimeLabel.text = String(format: "%02d:%02d:%02d", 0, 0, 0)
        overallTimeLabel.font = .monospacedDigitSystemFont(ofSize: 17, weight: .regular)  //字符等宽，便于显示动态的时间
        view.addSubview(overallTimeLabel)
        overallTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(playbackSlider.snp.bottom).offset(4)
            make.trailing.equalToSuperview().inset(16)
        }
        
        // Set current time label
        currentTimeLabel = UILabel()
        currentTimeLabel.text = String(format: "%02d:%02d:%02d", 0, 0, 0)
        currentTimeLabel.font = .monospacedDigitSystemFont(ofSize: 17, weight: .regular)
        view.addSubview(currentTimeLabel)
        currentTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(playbackSlider.snp.bottom).offset(4)
            make.leading.equalToSuperview().inset(16)
        }
        
        // Set play button
        playButton = UIButton(type: UIButton.ButtonType.custom)
        playButton.snp.makeConstraints { make in
            make.width.height.equalTo(60)
        }
        playButton.setImage(UIImage(systemName: "play")?.withConfiguration(playButtonConfig), for: .normal)
        playButton.addAction(UIAction(handler: { (action) in
            if let podcastPlayer = self.podcastPlayer {
                if podcastPlayer.rate == 0 {
                    podcastPlayer.play()
                    self.playButton.setImage(UIImage(systemName: "pause")?.withConfiguration(playButtonConfig), for: .normal)
                    UIView.animate(withDuration: 0.3) {
                        self.episodeImageView.transform = .identity.scaledBy(x: 1.0, y: 1.0)
                    }
                } else {
                    podcastPlayer.pause()
                    self.playButton.setImage(UIImage(systemName: "play")?.withConfiguration(playButtonConfig), for: .normal)
                    UIView.animate(withDuration: 0.3) {
                        self.episodeImageView.transform = .identity.scaledBy(x: 0.9, y: 0.9)
                    }
                }
            }
            
        }), for: .touchUpInside)
        
        // Set forward button
        forwardButton = UIButton()
        forwardButton.snp.makeConstraints { make in
            make.width.height.equalTo(60)
        }
        forwardButton.setImage(UIImage(systemName: "forward")?.withConfiguration(largeConfig), for: .normal)
        forwardButton.addAction(UIAction(handler: { (action) in
            if let podcastPlayer = self.podcastPlayer, let duration = podcastPlayer.currentItem?.duration {
                let currentTime = CMTimeGetSeconds(podcastPlayer.currentTime())
                let newTime = min(CMTimeGetSeconds(duration), currentTime + 15.0)
                podcastPlayer.pause()
                let selectedTime: CMTime = CMTimeMake(value: Int64(newTime * 1000), timescale: 1000)
                podcastPlayer.seek(to: selectedTime)
                podcastPlayer.play()
            }
            
        }), for: .touchUpInside)
        
        // Set backward button
        backwardButton = UIButton()
        backwardButton.snp.makeConstraints { make in
            make.width.height.equalTo(60)
        }
        backwardButton.setImage(UIImage(systemName: "backward")?.withConfiguration(largeConfig), for: .normal)
        backwardButton.addAction(UIAction(handler: { (action) in
            if let podcastPlayer = self.podcastPlayer {
                let currentTime = CMTimeGetSeconds(podcastPlayer.currentTime())
                let newTime = max(0, currentTime - 15.0)
                podcastPlayer.pause()
                let selectedTime: CMTime = CMTimeMake(value: Int64(newTime * 1000), timescale: 1000)
                podcastPlayer.seek(to: selectedTime)
                podcastPlayer.play()
            }
            
        }), for: .touchUpInside)
        
        // Set control stack view
        let controlStackViewContainer  = UIView()
        view.addSubview(controlStackViewContainer)
        controlStackViewContainer.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(currentTimeLabel.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        let controlStackView  = UIStackView()
        controlStackView.alignment = .center
        controlStackView.axis = .horizontal
        controlStackView.distribution = .equalCentering //分开分布
        controlStackView.addArrangedSubview(backwardButton)
        controlStackView.addArrangedSubview(playButton)
        controlStackView.addArrangedSubview(forwardButton)
        controlStackViewContainer.addSubview(controlStackView)
        controlStackView.snp.makeConstraints { make in
            make.width.equalTo(250)
            make.centerX.centerY.equalToSuperview()
        }
        
        

        self.navigationItem.rightBarButtonItems = [rightBarButtonItemShare, rightBarButtonItemComment]
        
        return view
    }

    @objc func showCommentView() {
        self.present(UIStoryboard(name: "CommentView", bundle: nil).instantiateInitialViewController()!, animated: true, completion: nil)
    }
    
    @objc func shareEpisode() {
        let episodeStreamItem = URL(string: episode.streamUrl)!
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [episodeStreamItem], applicationActivities: nil)
        activityViewController.isModalInPresentation = true
        self.present(activityViewController, animated: true, completion: nil)
    }
}
