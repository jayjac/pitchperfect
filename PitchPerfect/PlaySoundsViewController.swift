//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Jean-Yves Jacaria on 04/06/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    enum ButtonType: Int {
        case slow = 0, fast, chipmunk, vader, echo, reverb
    }
    
    var recordedAudioURL: URL!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer?
    private var audioPlayer: AVAudioPlayer!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioPlayer = try? AVAudioPlayer(contentsOf: recordedAudioURL)
        setupAudio()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        configureUI(.notPlaying)
        stopAudio()
    }
    





    @IBAction func playAlteredSound(_ button: UIButton) {
        guard let type = ButtonType(rawValue: button.tag) else { return }
        
        switch type {
        case .slow:
            playSound(rate: 0.4)
            
        case .fast:
            playSound(rate: 2.0)
            
        case .chipmunk:
            playSound(pitch: 2400.0)
            
        case .vader:
            playSound(pitch: -1200.0)
            
        case .echo:
            playSound(echo: true)
            
        case .reverb:
            playSound(reverb: true)
            
        }
    }
    
    
    @IBAction func didTapStopButton() {
        stopAudio()
    }



}
