//
//  VideoPlayViewController.swift
//  BMPlayer
//
//  Created by BrikerMan on 16/4/28.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit
import BMPlayer
import NVActivityIndicatorView

class VideoPlayViewController: UIViewController {
        
    var player: BMPlayer!
    
    var index: IndexPath!
    
    var controller: BMPlayerControlView!
    
    var changeButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayerManager()
        preparePlayer()
        setupPlayerResource()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidEnterBackground),
                                               name: NSNotification.Name.UIApplicationDidEnterBackground,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillEnterForeground),
                                               name: NSNotification.Name.UIApplicationWillEnterForeground,
                                               object: nil)
    }
    
    func applicationWillEnterForeground() {
        
    }
    
    func applicationDidEnterBackground() {
        player.pause(allowAutoPlay: false)
    }
    
    /**
     prepare playerView
     */
    func preparePlayer() {
        if index.row == 0 && index.section == 2 {
            controller = BMPlayerCustomControlView()
        }
        
        if index.row == 1 && index.section == 2 {
            controller = BMPlayerCustomControlView2()
        }
        
        if index.row == 3 && index.section == 2 {
            controller = BMPlayerCustomControlView3()
        }
        
        player = BMPlayer(customControlView: controller)
        view.addSubview(player)
        player.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.height.equalTo(view.snp.width).multipliedBy(9.0/16.0)
        }
        player.delegate = self
        player.backBlock = { [unowned self] (isFullScreen) in
            if isFullScreen == true {
                return
            }
            let _ = self.navigationController?.popViewController(animated: true)
        }
    
        changeButton.setTitle("Change Video", for: .normal)
        changeButton.addTarget(self, action: #selector(onChangeVideoButtonPressed), for: .touchUpInside)
        changeButton.backgroundColor = UIColor.red.withAlphaComponent(0.7)
        view.addSubview(changeButton)
        
        changeButton.snp.makeConstraints { (make) in
            make.top.equalTo(player.snp.bottom).offset(30)
            make.left.equalTo(view.snp.left).offset(10)
        }
        changeButton.isHidden = true
        self.view.layoutIfNeeded()
    }
    
    
    @objc fileprivate func onChangeVideoButtonPressed() {
        let urls = ["http://wvideo.spriteapp.cn/video/2016/0328/56f8ec01d9bfe_wpd.mp4",
                    "http://baobab.wdjcdn.com/1456117847747a_x264.mp4",
                    "http://baobab.wdjcdn.com/14525705791193.mp4",
                    "http://baobab.wdjcdn.com/1456459181808howtoloseweight_x264.mp4",
                    "http://baobab.wdjcdn.com/1455968234865481297704.mp4",
                    "http://baobab.wdjcdn.com/1455782903700jy.mp4",
                    "http://baobab.wdjcdn.com/14564977406580.mp4",
                    "http://baobab.wdjcdn.com/1456316686552The.mp4",
                    "http://baobab.wdjcdn.com/1456480115661mtl.mp4",
                    "http://baobab.wdjcdn.com/1456665467509qingshu.mp4",
                    "http://baobab.wdjcdn.com/1455614108256t(2).mp4",
                    "http://baobab.wdjcdn.com/1456317490140jiyiyuetai_x264.mp4",
                    "http://baobab.wdjcdn.com/1455888619273255747085_x264.mp4",
                    "http://baobab.wdjcdn.com/1456734464766B(13).mp4",
                    "http://baobab.wdjcdn.com/1456653443902B.mp4",
                    "http://baobab.wdjcdn.com/1456231710844S(24).mp4"]
        let random = Int(arc4random_uniform(UInt32(urls.count)))
        let asset = BMPlayerResource(url: URL(string: urls[random])!, name: "Video @\(random)")
        player.setVideo(resource: asset)
    }
    
    
    func setupPlayerResource() {
        switch (index.section,index.row) {
    
        case (0,0):
            let str = Bundle.main.url(forResource: "SubtitleDemo", withExtension: "srt")!
            let url =  URL(string: "http://baobab.wdjcdn.com/1456117847747a_x264.mp4")!
           
            let subtitle = BMSubtitles(url: str)
            
            let asset = BMPlayerResource(name: "Video Name Here",
                                         definitions: [BMPlayerResourceDefinition(url: url, definition: "480p")],
                                         cover: nil,
                                         subtitles: subtitle)
            player.seek(30)
            player.setVideo(resource: asset)
            changeButton.isHidden = false
            
        case (0,1):
            let asset = self.preparePlayerItem()
            player.setVideo(resource: asset)
            
        case (0,2):
            let asset = self.preparePlayerItem()
            player.setVideo(resource: asset)
            
        case (2,0):
            player.panGesture.isEnabled = false
            let asset = self.preparePlayerItem()
            player.setVideo(resource: asset)
            
        case (2,1):
            player.videoGravity = "AVLayerVideoGravityResizeAspect"
            let asset = BMPlayerResource(url: URL(string: "http://baobab.wdjcdn.com/14525705791193.mp4")!, name: "风格互换：原来你我相爱")
            player.setVideo(resource: asset)
            
        case (2,2):
            let asset = self.preparePlayerItem()
            player.setVideo(resource: asset)
            
        default:
            let asset = self.preparePlayerItem()
            player.setVideo(resource: asset)
        }
    }
    
    func setupPlayerManager() {
        resetPlayerManager()
        switch (index.section,index.row) {
        case (0,0):
            break
        case (0,1):
            break
        case (0,2):
            BMPlayerConf.shouldAutoPlay = false
            
        case (1,0):
            BMPlayerConf.topBarShowInCase = .always
            
        case (1,1):
            BMPlayerConf.topBarShowInCase = .horizantalOnly
            
        case (1,2):
            BMPlayerConf.topBarShowInCase = .none
            
        case (1,3):
            BMPlayerConf.tintColor = UIColor.red
            
        default:
            break
        }
    }
    
    
    func preparePlayerItem() -> BMPlayerResource {
        let url =  URL(string: "http://content.bitsontherun.com/videos/bkaovAYt-52qL9xLP.mp4")!
        let str = URL(string: "https://www.iandevlin.com/html5test/webvtt/upc-video-subtitles-en.vtt")!
        let cover = URL(string:"http://content.bitsontherun.com/thumbs/bkaovAYt-480.jpg")!
        let subtitle = BMSubtitles(url: str)
        
        let asset = BMPlayerResource(name: "",definitions: [BMPlayerResourceDefinition(url: url, definition: "")],cover: cover,subtitles: subtitle)
        return asset
    }
    
    
    func resetPlayerManager() {
        BMPlayerConf.allowLog = false
        BMPlayerConf.shouldAutoPlay = true
        BMPlayerConf.tintColor = UIColor.white
        BMPlayerConf.topBarShowInCase = .always
        BMPlayerConf.loaderType  = NVActivityIndicatorType.ballRotateChase
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: false)
        // If use the slide to back, remember to call this method
        player.pause(allowAutoPlay: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: false)
        // If use the slide to back, remember to call this method
        player.autoPlay()
        
    }
        
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        //super.viewWillTransition(to: size, with: coordinator)
        //the code in the VideoDocumentController should be added here
        
        if ((controller as? BMPlayerCustomControlView3) != nil) {
            print("Call orintation customization method")
            (controller as? BMPlayerCustomControlView3)?.handleDeviceRotation()
        }else{
            print(" CustomePlayer is nill : Call orintation customization method")
        }
    }
    
    deinit {
        // If use the slide to back, remember to call this method
        player.prepareToDealloc()
        print("VideoPlayViewController Deinit")
    }

    
}

// MARK:- BMPlayerDelegate example
extension VideoPlayViewController: BMPlayerDelegate {
    // Call back when playing state changed, use to detect is playing or not
    func bmPlayer(player: BMPlayer, playerIsPlaying playing: Bool) {
        if(playing){
            print("=======>Video Started")
        }else{
            print("=======>Video Paused")
        }
    }
    
    // Call back when playing state changed, use to detect specefic state like buffering, bufferfinished
    func bmPlayer(player: BMPlayer, playerStateDidChange state: BMPlayerState) {
        print("| BMPlayerDelegate | playerStateDidChange | state - \(state)")
    }
    
    // Call back when play time change
    func bmPlayer(player: BMPlayer, playTimeDidChange currentTime: TimeInterval, totalTime: TimeInterval) {
//        print("| BMPlayerDelegate | playTimeDidChange | \(currentTime) of \(totalTime)")
    }
    
    // Call back when the video loaded duration changed
    func bmPlayer(player: BMPlayer, loadedTimeDidChange loadedDuration: TimeInterval, totalDuration: TimeInterval) {
//        print("| BMPlayerDelegate | loadedTimeDidChange | \(loadedDuration) of \(totalDuration)")
    }
}
