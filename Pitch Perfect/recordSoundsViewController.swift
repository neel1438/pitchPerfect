//
//  recordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Neel Bommisetty on 07/12/15.
//  Copyright © 2015 NeelBommisetty. All rights reserved.
//

import UIKit
import AVFoundation

class recordSoundsViewController: UIViewController,AVAudioRecorderDelegate{

    @IBOutlet weak var recordingTextLabel: UILabel!
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden=true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        recordingTextLabel.hidden = false
        recordingTextLabel.text="Tap To Record"
    }

    @IBAction func recordAudio(sender: UIButton) {
        recordingTextLabel.text="Recording in Progress"
        stopButton.hidden = false
        recordButton.enabled=false
       
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
//        let currentDateTime = NSDate()
//        let formatter = NSDateFormatter()
//        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = "myRecording.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate=self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag){
            print("recording done")
            recordedAudio=RecordedAudio(filePathUrl: recorder.url,title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender :recordedAudio)
        }else{
            recordButton.enabled=true
            stopButton.hidden=true
            print("recording Failed")
        }
   
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording"){
            let playSoundVC:playSoundViewController = segue.destinationViewController as! playSoundViewController
            let data = sender as! RecordedAudio
            playSoundVC.receivedAudio=data
        }
    }
    @IBAction func stopRecording(sender: UIButton) {
       
        recordingTextLabel.hidden = true
        recordButton.enabled=true
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
}

