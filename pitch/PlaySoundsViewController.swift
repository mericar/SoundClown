//
//  PlaySoundsViewController.swift
//  pitch
//
//  Created by M on 2016-02-23.
//  Copyright © 2016 mec. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    //Constants
    var speed: Float = 1.0
    var pitch: Float = 0.0
    
    @IBOutlet weak var speedSlider: UISlider!
    @IBOutlet weak var pitchSlider: UISlider!

    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var ratePlayButton: UIButton!
    @IBOutlet weak var pitchPlayButton: UIButton!
    
    
    var receivedAudio:RecordedAudio!
    var audioPlayer:AVAudioPlayer!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        pitchPlayButton.enabled = true
        ratePlayButton.enabled = true
        
            //Play a hardcoded Forrest Gump mp3 file:
//        if  let filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3"){
//            let filePathUrl = NSURL.fileURLWithPath(filePath)
//            audioPlayer = try!
//            AVAudioPlayer(contentsOfURL: filePathUrl)
//            audioPlayer.enableRate = true
//        }else{
//            print("nothing here??? error!")
//        }
        
        // Now, get the received data from the segue:
        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
    }
    
    //playback audio func with rate as parameter of type float
    func playbackAudio(rate: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.currentTime = 0
        audioPlayer.rate = rate
        audioPlayer.play()
    }

    // alters the pitch with pitch parameter of type float
    func playbackVariablePitch(pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    

 
    @IBAction func playSpeedSlider(sender: UISlider) {
        self.speed = sender.value/100
    }
    @IBAction func playPitchSlider(sender: UISlider) {
        self.pitch = sender.value
    }
    
    //Stopping playback
    @IBAction func stopAudio(sender: UIButton) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        pitchPlayButton.enabled = true
        ratePlayButton.enabled = true
        stopButton.enabled = false
    }
    
    @IBAction func playSpeedAudio(sender: UIButton) {
        ratePlayButton.enabled = false
        stopButton.enabled = true
        playbackAudio(self.speed)
    }
    @IBAction func playPitchAudio(sender: UIButton) {
        pitchPlayButton.enabled = false
        stopButton.enabled = true
        playbackVariablePitch(self.pitch)
    }
    
    //    @IBAction func playSlowAudio(sender: UIButton) {
    //        //play sound slowly
    //        playbackAudio(slow)
    //    }
    //    @IBAction func playFastAudio(sender: UIButton) {
    //        //play sound at a fast playback rate
    //        playbackAudio(fast)
    //    }
    //    @IBAction func playChipmunkAudio(sender: UIButton) {
    //        // TODO: add chipmunk voice
    //        playbackVariablePitch(1000)
    //    }
    //    @IBAction func playDeepAudio(sender: UIButton) {
    //        playbackVariablePitch(-750)
    //    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
