//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Sajjad Patel on 2017-10-29.
//  Copyright © 2017 Sajjad Patel. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    //MARK: - Properties
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    //MARK: - Config UI
    func configUI(recordLabelState: Bool? = nil, isRecording: Bool? = nil) {
        //Checks if the recordLabelState is nil
        if let recordLabelState = recordLabelState {
            if recordLabelState {
                recordingLabel.text = "Recording in Progress"
            }else{
                recordingLabel.text = "Tap to Record"
            }
        }
        //Checks if the isRecording is nil
        if let isRecording = isRecording {
            if isRecording {
                recordButton.isEnabled = false
                stopRecordingButton.isEnabled = true
            }else{
                recordButton.isEnabled = true
                stopRecordingButton.isEnabled = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configUI(isRecording: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK: - Audio Record Function
    @IBAction func recordAudio(_ sender: Any) {
        configUI(recordLabelState: true, isRecording: true)
        
        //Set the file path where the recording is stored
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        //Start a shared audio instance
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord,with: AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        //Get the audio recording from the file path and set delegate to self
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        
        //Start recording
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        configUI(recordLabelState: false, isRecording: false)
        audioRecorder.stop()
        
        //Deactivate the sharedInstance
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    // MARK: - Audio Recorder Delegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            // Send the file path to the PlaySoundsViewController when stopRecording is pressed
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }else{
            print("recording not successful")
        }
    }
    
    // MARK: - Prepare For Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            
            //Setting up the properties inside PlaySoundsViewController with values in the RecordSoundsViewController
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}
