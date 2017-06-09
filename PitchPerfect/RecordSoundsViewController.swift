//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Jean-Yves Jacaria on 04/06/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    //MARK: Outlets
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    
    //MARK: Audio
    private var audioRecorder: AVAudioRecorder!
    private var fileUrl: URL?
    
    //MARK: Convenience constants
    private let showPlaysVCSegueId = "ShowPlaySoundsViewControllerSegue"
    private let fileName = "recordedAudio.wav"
    private enum RecordingState { case recording, notRecording }
    //MARK:-
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGUI(recording: .notRecording)
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else { return }
        
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
            recordButton.isEnabled = true
        case .recording:
            recordingLabel.text = "Recording..."
            stopButton.isEnabled = true
            recordButton.isEnabled = false
        }

    }
    
    

    @IBAction func didTapRecordButton() {
        setupGUI(recording: .recording)
        guard let fileUrl = self.fileUrl else { return }
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            audioRecorder = try AVAudioRecorder(url: fileUrl, settings: [:])
            audioRecorder.isMeteringEnabled = true
            audioRecorder.delegate = self
            
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        }
        catch let error {
            setupGUI(recording: .notRecording)
            showAlert(title: "Recording error", message: error.localizedDescription)
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
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
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        setupGUI(recording: .notRecording)
        
        if flag {
            performSegue(withIdentifier: showPlaysVCSegueId, sender: nil)
        }
        
    }

    

}


