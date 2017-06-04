//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Jean-Yves Jacaria on 04/06/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSoundsViewController: UIViewController {

    @IBOutlet weak var recordButton: UIButton!
    private var audioRecorder: AVAudioRecorder!
    private var audioPlayer: AVAudioPlayer?
    private var fileUrl: URL?
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton.isHidden = true
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else { return }
        let fileName = "recordedAudio.wav"
        fileUrl = documentsUrl.appendingPathComponent(fileName)
        
        setupRecordButton()
        
        AVAudioSession.sharedInstance().requestRecordPermission { (granted: Bool) in
            return
        }

    }
    
    private func setupRecordButton() {
        recordingLabel.isHidden = true
        let width = recordButton.frame.width
        let layer = recordButton.layer
        layer.cornerRadius = width / 2
        layer.backgroundColor = UIColor.green.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 2, height: 2)
    }

    @IBAction func didTapRecordButton() {
        
        guard let fileUrl = self.fileUrl else { return }
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .allowBluetooth)
        recordingLabel.isHidden = false
        audioRecorder = try? AVAudioRecorder(url: fileUrl, settings: [:])
        audioRecorder.isMeteringEnabled = true
        audioRecorder.delegate = self
        recordButton.isEnabled = false
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    @IBAction func didTapStopButton() {
        recordingLabel.isHidden = true
        audioRecorder.stop()
    }
    
    @IBAction func didTapResume() {
        if audioPlayer == nil {
            audioPlayer = try? AVAudioPlayer(contentsOf: self.fileUrl!)
        }
        audioPlayer?.play()
    }
    

}


extension RecordSoundsViewController: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            recordButton.isEnabled = true
            playButton.isHidden = false
        }

    }
}
