//
//  BMPlayerCustomControlView2.swift
//  BMPlayer
//
//  Created by BrikerMan on 2017/4/6.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import Foundation
import BMPlayer

class BMPlayerCustomControlView3: BMPlayerControlView {
    
    open var isCaptionOn   = true
    open var isLandscapeMood = false
    open var captionButton = UIButton(type: UIButtonType.custom)
    open var fullScreenButtonPressed = false
   
    /**
     Override if need to customize UI components
     */
    override func customizeUIComponents() {
        BMPlayerConf.allowLog = false
        BMPlayerConf.shouldAutoPlay = false
        chooseDefitionView.isHidden = true
        
        
        topMaskView.addSubview(captionButton)
        
        captionButton.layer.cornerRadius = 2
        captionButton.layer.borderWidth  = 1
        captionButton.layer.borderColor  = UIColor ( red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8 ).cgColor
        captionButton.setTitleColor(UIColor ( red: 1.0, green: 1.0, blue: 1.0, alpha: 0.9 ), for: .normal)
        captionButton.setTitle("Caption", for: .normal)
        captionButton.addTarget(self, action: #selector(onCaptionButtonPressed), for: .touchUpInside)
        captionButton.titleLabel?.font   = UIFont.systemFont(ofSize: 12)
        captionButton.snp.makeConstraints {
            $0.right.equalTo(chooseDefitionView.snp.left).offset(-5)
            $0.centerY.equalTo(chooseDefitionView)
        }
        
        fullscreenButton.removeTarget(self, action: #selector(onButtonPressed(_:)), for: .touchUpInside)
        fullscreenButton.addTarget(self, action: #selector(onFullScreenButtonPressed), for: .touchUpInside)
        
        
        //        bottomMaskView.addSubview(captionButton)
        //
        //        captionButton.setImage(#imageLiteral(resourceName: "caption_not_selected"), for: .normal)
        //        captionButton.setImage(#imageLiteral(resourceName: "caption_selected"), for: .selected)
        //        captionButton.addTarget(self, action: #selector(onCaptionButtonPressed), for: .touchUpInside)
        //        captionButton.isSelected = isCaptionOn
        //
        //        captionButton.snp.makeConstraints { (make) in
        //            make.width.equalTo(25)
        //            make.height.equalTo(50)
        //            make.centerY.equalTo(currentTimeLabel)
        //            make.left.equalTo(fullscreenButton.snp.right)
        //            make.right.equalTo(bottomMaskView.snp.right)
        //        }
    }
    
    
    override func updateUI(_ isForFullScreen: Bool) {
        super.updateUI(isForFullScreen)
        captionButton.isSelected = isCaptionOn
    }
    
    
    override func playTimeDidChange(currentTime: TimeInterval, totalTime: TimeInterval) {
        currentTimeLabel.text = formatSecondsToString(currentTime)
        totalTimeLabel.text   = formatSecondsToString(totalTime)
        timeSlider.value      = Float(currentTime) / Float(totalTime)
        if let subtitle = resource?.subtitle {
            if(isCaptionOn){
                if let group = subtitle.search(for: currentTime) {
                    let description = group.description
                    let subtitleText = description.components(separatedBy: "\ntext  :")[1]
                    let str = subtitleText.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                    let attributedString = NSMutableAttributedString(string:str,attributes: nil)
                    subtitleBackView.isHidden = false
                    subtitleLabel.attributedText = attributedString
                } else {
                    subtitleBackView.isHidden = true
                }
            }
        }
    }
    
    
    @objc func onCaptionButtonPressed() {
        if(isCaptionOn){
            isCaptionOn = false
            subtitleBackView.isHidden = true
        }else{
            isCaptionOn = true
            subtitleBackView.isHidden = false
        }
    }
    
    
    @objc func onFullScreenButtonPressed() {
        fullScreenButtonPressed = true
        print("=======>Full Screen button Pressed")
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        if isIPhone(){
            //do nothing
        }else{
            if(isLandscapeMood){
                if isFullscreen{
                    appDelegate.fullScreenVideo = false
                    UIApplication.shared.statusBarOrientation = .portrait
                    UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                }else{
                    if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft {
                        print("====>UIDeviceOrientation.landscapeLeft")
                    } else if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight {
                        print("====>UIDeviceOrientation.landscapeRight")
                    } else if UIDevice.current.orientation == UIDeviceOrientation.portrait {
                        print("====>UIDeviceOrientation.portrait")
                    } else if UIDevice.current.orientation == UIDeviceOrientation.portraitUpsideDown {
                        print("====>UIDeviceOrientation.portraitUpsideDown")
                    }
                    
                    appDelegate.fullScreenVideo = true
                    UIApplication.shared.statusBarOrientation = .landscapeLeft
                    UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
                    
                }
            }else{
                appDelegate.fullScreenVideo = false
                UIApplication.shared.statusBarOrientation = .portrait
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            }
        }
        fullScreenButtonPressed = false
    }
    
    
    func handleDeviceRotation(){
        //updateUI(UIApplication.shared.statusBarOrientation.isLandscape
        if isIPhone(){
            //do nothing
        }else{
            if(UIDevice.current.orientation.isLandscape){
                isLandscapeMood = false
                if fullScreenButtonPressed{
                    //do nothing
                }else{
                    let playerRect = player?.layer.bounds
                    if playerRect?.size == UIScreen.main.bounds.size {
                        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
                        appDelegate.fullScreenVideo = true
                    } else {
                        let value = UIInterfaceOrientation.portrait.rawValue
                        UIDevice.current.setValue(value, forKey: "orientation")
                        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
                        appDelegate.fullScreenVideo = false
                    }
                }
            }else{
                isLandscapeMood = true
            }
        }
    }
    
    
    
    func formatSecondsToString(_ secounds: TimeInterval) -> String {
        let Min = Int(secounds / 60)
        let Sec = Int(secounds.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", Min, Sec)
    }
    
    func isIPhone() -> Bool{
        let model = UIDevice.current.model
        if model == "iPhone" {
            return true
        }else{
            return false
        }
    }
}
