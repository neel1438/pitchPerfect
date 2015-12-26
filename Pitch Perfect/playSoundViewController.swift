//
//  playSoundViewController.swift
//  Pitch Perfect
//
//  Created by Neel Bommisetty on 08/12/15.
//  Copyright © 2015 NeelBommisetty. All rights reserved.
//

import UIKit
import  AVFoundation

class playSoundViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        audioPlayer =  try? AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.enableRate = true
        
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try? AVAudioSession.sharedInstance().setActive(true)
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)

        
    }
    override func viewWillAppear(animated: Bool) {
        
    }
    override func viewDidAppear(animated: Bool) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playAudio(speed:Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.rate = speed
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    func playAudioWithVariablePitch(pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        let audioPlayerNode=AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect=AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        audioPlayerNode.play()
    }
    func playAudioWithEcho(delayTime: NSTimeInterval!){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        let audioPlayerNode=AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        let echoNode=AVAudioUnitDelay()
        echoNode.delayTime=delayTime
        audioEngine.attachNode(echoNode)
        audioEngine.connect(audioPlayerNode, to: echoNode, format: nil)
        audioEngine.connect(echoNode, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        audioPlayerNode.play()
    }

    @IBAction func playSlowAudio(sender: UIButton) {
        playAudio(0.5)
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        playAudio(2.0)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
        
    }
    @IBAction func playDarthAudio(sender: UIButton) {
         playAudioWithVariablePitch(-1000)
    }
    @IBAction func playEchoAudio(sender: UIButton) {
        playAudioWithEcho(NSTimeInterval(0.3))
    }

    @IBAction func stopAudio(sender: UIButton) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
}
