//
//  STVoiceViewController.swift
//  iOS_Audio
//
//  Created by Apple on 2018/1/12.
//  Copyright © 2018年 zxl. All rights reserved.
//

import UIKit


class STVoiceViewController: UIViewController {
    
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 添加按钮
        view.addSubview(self.startButton)
        view.addSubview(self.endButton)
        view.addSubview(self.listButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let recorder = AudioManager.manager
    
    
    /**
     * 0 开始录音 没有录音
     * 1 录音中 暂停录音
     */
    var _type: UInt8 = 0
    var type : UInt8 {
        get {
            return _type
        }
        set {
            _type = newValue
            if _type == 0 {
                self.startButton.setTitle("开始录音", for: .normal)
            }
            else if _type == 1 {
                self.startButton.setTitle("暂停录音", for: .normal)
            }
        }
    }
    
    let screenBounds = UIScreen.main.bounds
    lazy var startButton: UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("开始录音", for: UIControlState.normal)
        btn.backgroundColor = UIColor.red
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.addTarget(self, action: #selector(startAction), for: UIControlEvents.touchUpInside)
        btn.frame = CGRect(x: screenBounds.width * 0.4, y: screenBounds.height - screenBounds.width * 0.2 - kTabBarH, width: screenBounds.width * 0.2, height: screenBounds.width * 0.2)
        btn.layer.cornerRadius = screenBounds.width * 0.1
        return btn
    }()
    
    lazy var endButton: UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("结束录音", for: UIControlState.normal)
        btn.backgroundColor = UIColor.red
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.addTarget(self, action: #selector(endAction), for: UIControlEvents.touchUpInside)
        btn.frame = CGRect(x: screenBounds.width * 0.7, y: screenBounds.height - screenBounds.width * 0.2 - kTabBarH, width: screenBounds.width * 0.2, height: screenBounds.width * 0.2)
        btn.layer.cornerRadius = screenBounds.width * 0.1
        return btn
    }()
    
    lazy var listButton: UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("录音列表", for: UIControlState.normal)
        btn.backgroundColor = UIColor.red
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.addTarget(self, action: #selector(listAction), for: UIControlEvents.touchUpInside)
        btn.frame = CGRect(x: screenBounds.width * 0.1, y: screenBounds.height - screenBounds.width * 0.2 - kTabBarH, width: screenBounds.width * 0.2, height: screenBounds.width * 0.2)
        btn.layer.cornerRadius = screenBounds.width * 0.1
        return btn
    }()
    
    @objc func startAction() {
        print("\(#function)")
        if type == 0 {
            let url = URL.getAudioTimePath()
            recorder.start(url: url, delegate: self)
        } else if type == 1 {
            recorder.pause()
        }
        
        //SystemSound.playSystemTipAudioIsBegin(true)
    }
    
    @objc func endAction() {
        recorder.finish()
        //SystemSound.playSystemTipAudioIsBegin(false)
    }
    
    @objc func listAction() {
        let listVC = STListsViewController(style: .grouped)
        self.navigationController?.pushViewController(listVC, animated: true)
    }
}

extension STVoiceViewController : AudioRecorderDelegate{
    func recorderDidStart() {
        print("录制开始")
        self.type = 1
    }
    func recorderPause() {
        print("录制暂停")
        self.type = 0
    }
    func recorder(currentTime: TimeInterval) {
        //print("录制时间 \(currentTime)")
    }
    func recorder(min: Int, sec: Int) {
        let s = String(format: "%02d:%02d", min, sec)
        self.timeLabel.text = s
        print("录制时间 \(s)")
    }
    func recorderDidFinish() {
        print("录制完成")
        self.type = 0
    }
}
