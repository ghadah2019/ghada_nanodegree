//
//  RecordSoundsViewController.swift
//  pichperfect
//
//  Created by Ghada Al on 29/01/1440 AH.
//  Copyright © 1440 ghadaalone. All rights reserved.
//
//add navigation screen from editor embded and navigation

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    var audioRecorder : AVAudioRecorder!

    @IBOutlet weak var RecordingLabel: UILabel!
    
    @IBOutlet weak var recordingButton: UIButton!
    
    @IBOutlet weak var stopRecordingbutton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    stopRecordingbutton.imageView?.contentMode = .scaleAspectFit
        recordingButton.imageView?.contentMode = .scaleAspectFit
        
        stopRecordingbutton.isEnabled = false
        // Do any additional setup after loading the view, typically from a nib.
    }
   
    func configureUI(isRecording: Bool) {
        stopRecordingbutton.isEnabled = isRecording // to disable the button
        recordingButton.isEnabled = !isRecording // to enable the button
        RecordingLabel.text = !isRecording ? "Tap to Record" : "Recording in Progress"
        
    }
    @IBAction func recordbutton(_ sender: Any) {
        configureUI(isRecording: true)
        //RecordingLabel.text = "Recording in progress"
        //stopRecordingbutton.isEnabled = true
       // recordingButton.isEnabled = false
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) [0] as String
        let recorderingName = "recorderVoice.wav"
        let pathArray = [dirPath,recorderingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        print(filePath!)
        
        let session = AVAudioSession.sharedInstance()

        try! session.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        
    }
    
    @IBAction func stoprecording(_ sender: Any) {
        configureUI(isRecording: false)
        //RecordingLabel.text = "Tap to recording"
      // recordingButton.isEnabled = true
       // stopRecordingbutton.isEnabled = false
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
            
        }
        else {
            print("recording was not successful")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
            
        }
    }
}

/* func configureUI(_: Bool) {
 //RecordingLabel.text = "Tap to recording"
 // recordingButton.isEnabled = true
 // stopRecordingbutton.isEnabled = false
 //RecordingLabel.text = "Recording in progress"
 //stopRecordingbutton.isEnabled = true
 // recordingButton.isEnabled = false
 */
