//
//  RecordingViewController.swift
//  Wandertale
//
//  Created by Jason Kleuskens on 05-11-17.
//  Copyright © 2017 Jason Kleuskens. All rights reserved.
//

import UIKit
import AVFoundation

class RecordingViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {

    @IBOutlet weak var ButtonPlay: UIButton!
    @IBOutlet weak var ButtonRecord: UIButton!
    
    var soundRecorder : AVAudioRecorder!
    var SoundPlayer : AVAudioPlayer!
    
    var AudioFileName = "sound.m4a"
    
    
    let recordSettings = [AVSampleRateKey : NSNumber(value: Float(44100.0)),
                          AVFormatIDKey : NSNumber(value: Int32(kAudioFormatMPEG4AAC)),
                          AVNumberOfChannelsKey : NSNumber(value: 1),
                          AVEncoderAudioQualityKey : NSNumber(value: Int32(AVAudioQuality.medium.rawValue))]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRecorder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ActionRecord(sender: AnyObject) {
        if sender.titleLabel?!.text == "Record"{
            
            soundRecorder.record()
            sender.setTitle("Stop", for: .normal)
            ButtonPlay.isEnabled = false
            
        }
        else{
            
            soundRecorder.stop()
            sender.setTitle("Record", for: .normal)
            ButtonPlay.isEnabled = true
        }
        
    }
    @IBAction func ActionPlay(sender: AnyObject) {
        
        if sender.titleLabel?!.text == "Play" {
            
            ButtonRecord.isEnabled = false
            sender.setTitle("Stop", for: .normal)
            
            preparePlayer()
            SoundPlayer.play()
            
        }
        else{
            
            SoundPlayer.stop()
            sender.setTitle("Play", for: .normal)
            
        }
        
    }
    
    //HELPERS
    
    func preparePlayer(){
        
        do {
            try SoundPlayer = AVAudioPlayer(contentsOf: directoryURL()! as URL)
            SoundPlayer.delegate = self
            SoundPlayer.prepareToPlay()
            SoundPlayer.volume = 1.0
        } catch {
            print("Error playing")
        }
        
    }
    
    func setupRecorder(){
        let audioSession:AVAudioSession = AVAudioSession.sharedInstance()
        
        //ask for permission
        if (audioSession.responds(to: #selector(AVAudioSession.requestRecordPermission(_:)))){
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                if granted {
                    print("granted")
                    
                    //set category and activate recorder session
                    do {
                        
                        try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
                        try self.soundRecorder = AVAudioRecorder(url: self.directoryURL()! as URL, settings: self.recordSettings)
                        self.soundRecorder.prepareToRecord()
                        
                    } catch {
                        
                        print("Error Recording");
                        
                    }
                    
                }
            })
        }
        
    }
    
    func directoryURL() -> NSURL? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.appendingPathComponent("sound.m4a")
        return soundURL as NSURL?
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        ButtonPlay.isEnabled = true
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        ButtonRecord.isEnabled = true
        ButtonPlay.setTitle("Play", for: .normal)
    }

}
