//
//  playSoundViewController.swift
//  Pitch Perfect
//
//  Created by Neel Bommisetty on 08/12/15.
//  Copyright © 2015 NeelBommisetty. All rights reserved.
//

import UIKit
import  AVFoundation

class PlaySoundViewController: UIViewController {
    
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
    
    func playAudio(speed:Float){
        stopAudioAndReset()
        audioPlayer.rate = speed
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }

    func playAudioWithEffect(effectNode :AVAudioNode!){
        stopAudioAndReset()
        let audioPlayerNode=AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(effectNode)
        audioEngine.connect(audioPlayerNode, to: effectNode, format: nil)
        audioEngine.connect(effectNode, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        audioPlayerNode.play()
    }

    func playAudioWithVariablePitch(pitch: Float){
        let changePitchEffect=AVAudioUnitTimePitch()
        changePitchEffect.pitch=pitch
        playAudioWithEffect(changePitchEffect)
    }
    
    func playAudioWithEcho(delayTime: NSTimeInterval!){
        let echoNode=AVAudioUnitDelay()
        echoNode.delayTime=delayTime
        playAudioWithEffect(echoNode)
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
    
    func stopAudioAndReset(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }

    @IBAction func stopAudio(sender: UIButton) {
        stopAudioAndReset()
    }
    
}
