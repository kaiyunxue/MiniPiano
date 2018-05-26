//
//  ViewController.swift
//  MiniPiano
//
//  Created by Xue Kaiyun on 2018/4/5.
//  Copyright © 2018年 Xue Kaiyun. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    var button_n = 0;
    let serviceController = ServiceManager();
    let recordManager = RecordManager();
    var whiteKeys = [PianoKey]()
    var blackKeys = [PianoKey]()
    var touchView = UIView()
    var recordBut = UIButton()
    var playBut = UIButton()
    var screenWidth : Float = 0// = Float(floor(UIScreen.main.bounds.maxY))
    var screenHeight : Float = 0// = Float(floor(UIScreen.main.bounds.maxX))
    var side : Int?
    var whiteKeyWidth : Int?
    var blackKeyWidth : Int?
    
    var y : Int?
//    @IBAction func acd(_ sender: Any) {
//    }
    override func viewDidLoad() {
        screenWidth = Float(UIScreen.main.bounds.maxY);
        screenHeight = Float(UIScreen.main.bounds.maxX);
        if(screenHeight < screenWidth){
            let a = screenHeight;
            screenHeight = screenWidth;
            screenWidth = a;
        }
        side = Int(floor(0.05 * screenHeight))
        whiteKeyWidth = Int(floor(0.9 * screenHeight / 15))
        blackKeyWidth = Int(floor(Double(whiteKeyWidth! / 9 * 7)))
        y = side! + whiteKeyWidth! - blackKeyWidth! / 2 - whiteKeyWidth! * 2
        super.viewDidLoad()
        serviceController.delegate = self;
        for i in 0...14{
            whiteKeys.append(PianoKey.init(frame: CGRect.init(x: 1, y: side! + whiteKeyWidth! * i, width: 360, height: whiteKeyWidth!), isBlack: false, id: UInt32(i), serviceManager: serviceController))
             view.addSubview(whiteKeys[i])
        }
        for i in 0...9{
            if i % 5 == 3 || i % 5 == 0{
                y = y! + whiteKeyWidth! * 2
                blackKeys.append(PianoKey.init(frame: CGRect.init(x: 100, y: y!, width: 260, height: blackKeyWidth!), isBlack: true, id: UInt32(i + 15), serviceManager: serviceController));
            }else{
                y = y! + whiteKeyWidth!
                blackKeys.append(PianoKey.init(frame: CGRect.init(x: 100, y: y!, width: 260, height: blackKeyWidth!), isBlack: true, id: UInt32(i + 15), serviceManager: serviceController));
            }
            blackKeys[i].backgroundColor = UIColor.black
            //blackKeys[i].addTarget(self, action: Selector(("btnBlackClickFun")), for:UIControlEvents.touchDown)
            view.addSubview(blackKeys[i])
        }
        
        touchView.frame = CGRect.init(x: 0, y: 0, width: Int(screenWidth), height: Int(screenHeight))
        touchView.isMultipleTouchEnabled = true;
        
        playBut.frame = CGRect.init(x: Int(9*screenWidth/10), y: Int(screenHeight - screenWidth/10), width: Int(screenWidth/10), height: Int(screenWidth/10))
        recordBut.layer.contents = UIImage(named: "record.jpg")?.cgImage
        recordBut.layer.borderWidth = 2;
        
        recordBut.frame = CGRect.init(x: Int(9*screenWidth/10), y: Int(screenHeight - 2*screenWidth/10 + 1), width: Int(screenWidth/10), height: Int(screenWidth/10))
        playBut.layer.contents = UIImage(named: "play.jpg")?.cgImage
        playBut.layer.borderWidth = 2;
        
        recordBut.addTarget(self, action: #selector(Record), for: UIControlEvents.touchUpInside)
        playBut.addTarget(self, action: #selector(Play), for: UIControlEvents.touchUpInside)
        view.addSubview(touchView);
        view.addSubview(playBut);
        view.addSubview(recordBut)
        
    }
     @IBAction func Play(_ sender: Any) {
        recordManager.play()
    }
    @IBAction func Record(_ sender: Any) {
        switch button_n {
        case 0:
            recordManager.beginRecord()
            recordBut.layer.contents = UIImage(named: "stop.jpg")?.cgImage
            button_n = 1;
        default:
            button_n = 0;
            recordManager.stopRecord();
             recordBut.layer.contents = UIImage(named: "record.jpg")?.cgImage
        }
    }
    func btnWhiteClickFun(sender:UIButton){
        sender.backgroundColor = UIColor.lightGray
    }
    func btnBlackClickFun(sender:UIButton){
        sender.backgroundColor = UIColor.darkGray
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(touches)
        for i in 0...9{
            blackKeys[i].KeyUpdate(touches: touches, view: touchView)
        }
        for i in 0...14{
            whiteKeys[i].KeyUpdate(touches: touches, view: touchView)
        }

    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for i in 0...9{
            blackKeys[i].KeyUpdate(touches: touches, view: touchView)
        }
        for i in 0...14{
            whiteKeys[i].KeyUpdate(touches: touches, view: touchView)
        }

    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for i in 0...9{
            blackKeys[i].btnReleased(touches: touches, view: touchView)
        }
        for i in 0...14{
            whiteKeys[i].btnReleased(touches: touches, view: touchView)
        }
    }
    
}
extension ViewController : ServiceManagerDelegate{
    func KeyReleased(keyId: Int) {
        if(keyId < 15){
            whiteKeys[keyId].btnReleasedLocal()
        }
        else{
            blackKeys[keyId - 15].btnReleasedLocal()
        }
    }
    
    func KeyPressed(keyId: Int) {
        if(keyId < 15){
            whiteKeys[keyId].btnPressedDownLocal()
        }
        else{
            blackKeys[keyId - 15].btnPressedDownLocal()
        }
    }
    
    
}

