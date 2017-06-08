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
    
    
    override func viewWillAppear(_ animated: Bool) {
        configureUI(.notPlaying)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        audioPlayer = try? AVAudioPlayer(contentsOf: recordedAudioURL)
        setupAudio()
    }

    @IBAction func playAlteredSound(_ button: UIButton) {
        if button === snailButton {
            playSound(rate: 0.4)
        }
        if button === reverbButton {
            playSound(reverb: true)
        }
        if button === rabbitButton {
            playSound(rate: 2.0)
        }
        if button === vaderButton {
            playSound(pitch: -1200.0)
        }
        if button === chipmunkButton {
            playSound(pitch: 2400.0)
        }
        if button === echoButton {
            playSound(echo: true)
        }
    }
    
    
    @IBAction func didTapStopButton() {
        stopAudio()
    }



}
