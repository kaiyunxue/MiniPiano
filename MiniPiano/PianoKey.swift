//
//  PianoKey.swift
//  MiniPiano
//
//  Created by Xue Kaiyun on 2018/4/5.
//  Copyright © 2018年 Xue Kaiyun. All rights reserved.
//

import UIKit
import AVFoundation

class PianoKey: UIButton {
    
    var serviceManager: ServiceManager
    var soundID: SystemSoundID
    var isBlack: Bool
    var id: UInt32
    var isPressed = true;
    var player: AVAudioPlayer!
    init(frame: CGRect, isBlack: Bool, id: UInt32, serviceManager: ServiceManager) {
        
        self.isBlack = isBlack;
        self.isPressed = false;
        self.soundID = id + 10;
        self.id = id
        self.serviceManager = serviceManager;
        let path = Bundle.main.path(forResource: String(10 +
            id), ofType: "wav");
        let baseURL = NSURL(fileURLWithPath: path!)
        player = try! AVAudioPlayer(contentsOf: baseURL as URL)
        super.init(frame: frame);
        layer.borderColor = UIColor.black.cgColor;
        layer.borderWidth = 1;
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func KeyUpdate(touches: Set<UITouch>, view: UIView){
        for touch in touches{
            let point = touch.location(in: view)
            if(self.frame.contains(point) && !isPressed){
                btnPressedDown()
            }
            else if(!self.frame.contains(point) && self.frame.contains(touch.previousLocation(in: view)) && isPressed){
                btnReleased()
            }
        }
    }
    func btnPressedDown(){
        serviceManager.Send(keyId: UInt8(self.id), Action: 0)
        if(isBlack){
            self.backgroundColor = UIColor.init(white: 0.3, alpha: 1);
        }
        else{
            self.backgroundColor = UIColor.init(white: 0.7, alpha: 1)
        }
                //AudioServicesPlaySystemSound(soundID)
        if(player!.isPlaying){
            player!.stop()
            player!.currentTime = 0;
        }
//
        player!.play();
        isPressed = true;
    }
    func btnPressedDownLocal(){
        if(isBlack){
            OperationQueue.main.addOperation{
                self.backgroundColor = UIColor.init(white: 0.3, alpha: 1);
            }
        }
        else{
            OperationQueue.main.addOperation{
                self.backgroundColor = UIColor.init(white: 0.7, alpha: 1);
            }
        }
        AudioServicesPlaySystemSound(soundID)
        if(player!.isPlaying){
            player!.stop()
            player!.currentTime = 0;
        }
//        try! AVAudioSession.sharedInstance().overrideOutputAudioPort(.speaker)
        player!.play();
        isPressed = true;
    }
    override func setNeedsFocusUpdate() {
        print("update")
    }
    func btnReleasedLocal(){
        if(isBlack){
            print("black key released")
            OperationQueue.main.addOperation {
                self.backgroundColor = UIColor.init(white: 0, alpha: 1);
            }
        }
        else{
            OperationQueue.main.addOperation {
                self.backgroundColor = UIColor.init(white: 1, alpha: 1)
            }
        }
        isPressed = false;
    }
    func btnReleased(){
        serviceManager.Send(keyId: UInt8(self.id), Action: 1)
        if(isBlack){
            self.backgroundColor = UIColor.init(white: 0, alpha: 1);
        }
        else{
            self.backgroundColor = UIColor.init(white: 1, alpha: 1)
        }
        isPressed = false;
    }
    func btnReleased(touches: Set<UITouch>, view: UIView) {
        for touch in touches{
            if(!self.frame.contains(touch.location(in: view))){
                return;
            }
            if(!isPressed){
                return;
            }
            if(isBlack){
                serviceManager.Send(keyId: UInt8(self.id), Action: 1)
                self.backgroundColor = UIColor.init(white: 0, alpha: 1);
            }
            else{
                serviceManager.Send(keyId: UInt8(self.id), Action: 1)
                self.backgroundColor = UIColor.init(white: 1, alpha: 1)
            }
            isPressed = false;
        }
    }
}

