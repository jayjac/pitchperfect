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
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    private var audioRecorder: AVAudioRecorder!
    private var fileUrl: URL?
    
    fileprivate let showPlaysVCSegueId = "ShowPlaySoundsViewControllerSegue"
    
    enum RecordingState { case recording, notRecording }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGUI(recording: .notRecording)
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else { return }
        let fileName = "recordedAudio.wav"
        fileUrl = documentsUrl.appendingPathComponent(fileName)
        AVAudioSession.sharedInstance().requestRecordPermission { (granted: Bool) in
            return
        }
    }
    
    private func setupGUI(recording state: RecordingState) {
        switch state {
        case .notRecording:
            recordingLabel.text = "Tap to record"
            stopButton.isEnabled = false
        case .recording:
            recordingLabel.text = "Recording..."
            stopButton.isEnabled = true
        }

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //navigationController?.isNavigationBarHidden = true
       // navigationController?.navigationBar.barTintColor = UIColor.yellow
        
    }
    

    @IBAction func didTapRecordButton() {
        setupGUI(recording: .recording)
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
        setupGUI(recording: .notRecording)
        audioRecorder.stop()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showPlaysVCSegueId {
            let playSoundsViewController = segue.destination as! PlaySoundsViewController
            playSoundsViewController.recordedAudioURL = fileUrl
        }
    }

    

}


extension RecordSoundsViewController: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        recordButton.isEnabled = true
        
        if flag {
            performSegue(withIdentifier: showPlaysVCSegueId, sender: nil)
        }

    }
}
