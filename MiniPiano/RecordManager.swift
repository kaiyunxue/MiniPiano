//
//  File.swift
//  MiniPiano
//
//  Created by Xue Kaiyun on 2018/4/30.
//  Copyright © 2018年 Xue Kaiyun. All rights reserved.
//

import Foundation
import Foundation
import AVFoundation

class RecordManager {
    
    
    var recorder: AVAudioRecorder?
    var player: AVAudioPlayer?
    let file_path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first?.appending("/record.wav")
    
    func beginRecord() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch let err{
            print("Error:\(err.localizedDescription)")
        }
        do {
            try session.setActive(true)
        } catch let err {
            print("error:\(err.localizedDescription)")
        }
        let recordSetting: [String: Any] = [AVSampleRateKey: NSNumber(value: 16000),
            AVFormatIDKey: NSNumber(value: kAudioFormatLinearPCM),
            AVLinearPCMBitDepthKey: NSNumber(value: 16),
            AVNumberOfChannelsKey: NSNumber(value: 1),
            AVEncoderAudioQualityKey: NSNumber(value: AVAudioQuality.min.rawValue)
        ];
        do {
            let url = URL(fileURLWithPath: file_path!)
            recorder = try AVAudioRecorder(url: url, settings: recordSetting)
            recorder!.prepareToRecord()
            recorder!.record()
            print("record")
        } catch let err {
            print("error:\(err.localizedDescription)")
        }
    }
    
    func stopRecord() {
        if let recorder = self.recorder {
            recorder.stop()
            self.recorder = nil
        }else {
            print("error")
        }
    }
    
    func play() {
        do {
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: file_path!))
            player!.play()
              try! AVAudioSession.sharedInstance().overrideOutputAudioPort(.speaker)
        } catch let err {
            print("error:\(err.localizedDescription)")
        }
    }
    
}
