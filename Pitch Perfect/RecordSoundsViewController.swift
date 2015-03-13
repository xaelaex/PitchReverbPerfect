//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Alex on 2/14/15.
//  Copyright (c) 2015 xaelaex. All rights reserved.
//

import UIKit
import AVFoundation

var audioRecorder:AVAudioRecorder!
var recordedAudio:RecordedAudio!

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var multiLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var continueRecording: UIButton!
    
    
   
    
// using viewWillAppear as opposed to viewDidLoad because viewWillAppear will load every time this page is loaded and not just when the app starts
    override func viewWillAppear(animated: Bool) {
        recordButton.enabled = true
        stopButton.enabled = false
        pauseButton.enabled = false
        continueRecording.enabled = false
        multiLabel.hidden = true
    }
    
    //create a file using the current date and time for the filename to avoid naming conflict
    @IBAction func recordAudio(sender: UIButton) {
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()

        
        recordButton.enabled = false
        stopButton.enabled = true
        pauseButton.enabled = true
        continueRecording.enabled = false
        
        multiLabel.text = "recording"
        multiLabel.hidden = false
    }
   


    @IBAction func pauseButton(sender: UIButton) {
        audioRecorder.pause()

        recordButton.enabled = false
        stopButton.enabled = true
        pauseButton.enabled = false
        continueRecording.enabled = true
        
        multiLabel.text = "recording paused"
        multiLabel.hidden = false
    }
    
    @IBAction func continueRecording(sender: UIButton) {
        
        audioRecorder.record()
        recordButton.enabled = false
        stopButton.enabled = true
        pauseButton.enabled = true
        continueRecording.enabled = false
        
        multiLabel.text = "recording"
        multiLabel.hidden = false
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        recordButton.enabled = false
        stopButton.enabled = false
        pauseButton.enabled = false
        
        multiLabel.text = "recording complete"
        multiLabel.hidden = false
    }
    
    
    
    // audioRecorderDidFinishRecording if true triggers segue
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag){
            recordedAudio = RecordedAudio(filePathUrlI: audioRecorder.url!, titleI: audioRecorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
            //            recordButton.enabled = false
            //            stopButton.enabled = true
            //            multiLabel.text = "recording successful"
        }else {
            println("Recording was not successful")
            recordButton.enabled = true
            stopButton.enabled = false
            multiLabel.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
        
        
    }

}

