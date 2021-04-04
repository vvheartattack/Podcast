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
        
        let view: UIView
        view = setLayout()
        self.view = view
        
        let url = URL(string: episode.streamUrl)
        
        let playerItem = AVPlayerItem(url: url!)
        self.playerItem = playerItem
        
        let podcastPlayer = AVPlayer(playerItem: playerItem)
        self.podcastPlayer = podcastPlayer
        
        let duration = playerItem.asset.duration
        let seconds = CMTimeGetSeconds(duration)
        let secondsInt = Int(seconds)
        
        // Set playbackSlider
        playbackSlider.minimumValue = 0
        playbackSlider.maximumValue = Float(seconds)
        playbackSlider.isContinuous = true
        
        // 小时：分钟：秒，确保每个单位有两位数字
        overallTimeLabel.text = String(format: "%02d:%02d:%02d", secondsInt / 3600, secondsInt / 60 % 60, secondsInt % 60)
        currentTimeLabel.text = String(format: "%02d:%02d:%02d", 0, 0, 0)
        
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
        
        let view = UIView()
        
        
        // Set episodeImageView
        episodeImageView = UIImageView()
        episodeImageView.kf.setImage(with: URL(string: episode.imageUrl!))
        
        // Set playbackSlider
        playbackSlider = UISlider()
        playbackSlider.addAction(UIAction(handler: { (action) in
            if let sender = action.sender as? UISlider, let podcastPlayer = self.podcastPlayer {
                let sliderValue = sender.value
                let targetTime = CMTimeMake(value: Int64(sliderValue), timescale: 1)
                podcastPlayer.seek(to: targetTime)
            }
            
        }), for: .valueChanged)
        
        // Set overall time label
        overallTimeLabel = UILabel()
        overallTimeLabel.font = .monospacedDigitSystemFont(ofSize: 17, weight: .regular)  //字符等宽，便于显示动态的时间
        
        // Set current time label
        currentTimeLabel = UILabel()
        currentTimeLabel.font = .monospacedDigitSystemFont(ofSize: 17, weight: .regular)
        
        // Set slider stack
        let sliderStackView = UIStackView()
        sliderStackView.alignment = .center
        sliderStackView.distribution = .fill
        sliderStackView.spacing = 8
        sliderStackView.addArrangedSubview(currentTimeLabel)
        sliderStackView.addArrangedSubview(playbackSlider)
        sliderStackView.addArrangedSubview(overallTimeLabel)
        view.addSubview(sliderStackView)
        sliderStackView.snp.makeConstraints{ (make) -> Void in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
            make.leading.equalTo(view).offset(16)
            make.trailing.equalTo(view).offset(-16)
        }
        
        // Set play button
        playButton = UIButton(type: UIButton.ButtonType.custom)
        playButton.setImage(UIImage(systemName: "play"), for: .normal)
        playButton.addAction(UIAction(handler: { (action) in
            if let podcastPlayer = self.podcastPlayer {
                if podcastPlayer.rate == 0 {
                    podcastPlayer.play()
                    self.playButton.setImage(UIImage(systemName: "pause"), for: .normal)
                } else {
                    podcastPlayer.pause()
                    self.playButton.setImage(UIImage(systemName: "play"), for: .normal)
                }
            }
            
        }), for: .touchUpInside)
        
        // Set forward button
        forwardButton = UIButton()
        forwardButton.setImage(UIImage(systemName: "forward"), for: .normal)
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
        backwardButton.setImage(UIImage(systemName: "backward"), for: .normal)
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
        let controlStackView  = UIStackView()
        controlStackView.alignment = .center
        controlStackView.distribution = .equalCentering //分开分布
        controlStackView.addArrangedSubview(backwardButton)
        controlStackView.addArrangedSubview(playButton)
        controlStackView.addArrangedSubview(forwardButton)
//        view.addSubview(controlStackView)
        controlStackView.snp.makeConstraints{ (make) -> Void in
            make.centerX.equalTo(sliderStackView)
            make.top.equalTo(sliderStackView).offset(16)
            make.leading.equalTo(view).offset(16)
            make.trailing.equalTo(view).offset(-16)
            
        }
        
        // Set outer stack view
        let outerStackView = UIStackView()
        outerStackView.alignment = .center
        outerStackView.distribution = .fill
        outerStackView.addArrangedSubview(episodeImageView)
        outerStackView.addArrangedSubview(sliderStackView)
        outerStackView.addArrangedSubview(controlStackView)
        outerStackView.spacing = 16
        view.addSubview(outerStackView)
        outerStackView.snp.makeConstraints{ (make) in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            
        }
        
        return view
    }

}
