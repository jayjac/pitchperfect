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
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordingLabel.text = "Tap to record"
        stopButton.isEnabled = false
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else { return }
        let fileName = "recordedAudio.wav"
        fileUrl = documentsUrl.appendingPathComponent(fileName)
        AVAudioSession.sharedInstance().requestRecordPermission { (granted: Bool) in
            return
        }
    }
    

    @IBAction func didTapRecordButton() {
        recordingLabel.text = "Recording..."
        stopButton.isEnabled = true
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
