//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Alex on 2/21/15.
//  Copyright (c) 2015 xaelaex. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile:AVAudioFile!
    var audioPlayerNode = AVAudioPlayerNode()
    var reverb = AVAudioUnitReverb()

    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var reverbSlider: UISlider!
 
        override func viewDidLoad() {
        super.viewDidLoad()

        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        reverbSlider.enabled = true
    }
    
    @IBAction func PlaySlowAudio(sender: UIButton) {
        // play audio slowly here
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        audioPlayer.rate = 0.5
        audioPlayer.play()
    }
    
    @IBAction func PlayFastAudio(sender: UIButton) {
        // play audio fast here
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        audioPlayer.rate = 2
        audioPlayer.play()
    }
  
    func playAudioWithVariablePitch(pitch: Float) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
   
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch 
        audioEngine.attachNode(changePitchEffect)

        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
       
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        
        playAudioWithVariablePitch(500)
    }
    
    func playAudioWithReverb(reverbv: Float) {
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        let url = audioRecorder.url
        audioEngine = AVAudioEngine()
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        let file = AVAudioFile(forReading: url, error: nil)
        var reverb = AVAudioUnitReverb()
        reverb.wetDryMix = reverbv
        audioEngine.attachNode(reverb)
        let mainMixer = audioEngine.mainMixerNode
        audioEngine.connect(audioPlayerNode, to: reverb, format: nil)
        audioEngine.connect(reverb, to: audioEngine.outputNode, format: file.processingFormat)
        audioPlayerNode.scheduleFile(file, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
    @IBAction func reverbSliderChange(sender: UISlider) {
        
        // reverberation slidefication
        playAudioWithReverb(sender.value)
        // line below is useful for testing the button
//      println("value--\(sender.value)")
    }
    
    @IBAction func stopButton(sender: UIButton) {
        
        audioPlayer.stop()
        audioEngine.stop()
        audioPlayerNode.stop()
        reverbSlider.enabled = true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
