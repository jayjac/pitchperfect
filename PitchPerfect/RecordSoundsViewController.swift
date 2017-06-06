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
    private var fileUrl: URL?
    @IBOutlet weak var recordingLabel: UILabel!
    fileprivate let showPlaysVCSeugueIdentifier = "ShowPlaySoundsViewControllerSegue"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else { return }
        let fileName = "recordedAudio.wav"
        fileUrl = documentsUrl.appendingPathComponent(fileName)
        
        setupRecordButton()
        
        AVAudioSession.sharedInstance().requestRecordPermission { (granted: Bool) in
            return
        }

    }
    
    private func setupRecordButton() {
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
        recordingLabel.text = "Recording..."
        guard let fileUrl = self.fileUrl else { return }
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .allowBluetooth)
        
        audioRecorder = try? AVAudioRecorder(url: fileUrl, settings: [:])
        audioRecorder.isMeteringEnabled = true
        audioRecorder.delegate = self
        recordButton.isEnabled = false
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    @IBAction func didTapStopButton() {
        recordingLabel.text = "Tap to record"
        audioRecorder.stop()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showPlaysVCSeugueIdentifier {
            let playSoundsViewController = segue.destination as! PlaySoundsViewController
            playSoundsViewController.recordedAudioURL = fileUrl
        }
    }

    

}


extension RecordSoundsViewController: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        recordButton.isEnabled = true
        
        if flag {
            
            performSegue(withIdentifier: showPlaysVCSeugueIdentifier, sender: nil)
        }

    }
}
