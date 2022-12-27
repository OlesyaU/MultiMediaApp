//
//  ViewController.swift
//  MultiMediaApp
//
//  Created by Олеся on 17.12.2022.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    private var player = AVAudioPlayer()
    private var playerRecord = AVAudioPlayer()
    private var audioRecorder = AVAudioRecorder()
    private let tracks = Track.trackArray()
    private var isPlaying = false
    private var isRecording = false
    private var isAudioRecordingGranted: Bool!
    private let startTrack = Track.trackArray().first
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        useTrack(track: startTrack!)
        checkRecordPermission()
    }
    
//     Recorder
    
    private func checkRecordPermission(){
        switch AVAudioSession.sharedInstance().recordPermission {
            case AVAudioSession.RecordPermission.granted:
                isAudioRecordingGranted = true
                break
            case AVAudioSession.RecordPermission.denied:
                isAudioRecordingGranted = false
                break
            case AVAudioSession.RecordPermission.undetermined:
                AVAudioSession.sharedInstance().requestRecordPermission() { [unowned self] allowed in
                    DispatchQueue.main.async {
                        if allowed {
                            self.isAudioRecordingGranted = true
                        } else {
                            self.isAudioRecordingGranted = false
                        }
                    }
                }
                break
            default:
                break
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    private func getFileUrl() -> URL {
        let filename = "myRecording.m4a"
        let filePath = getDocumentsDirectory().appendingPathComponent(filename)
        return filePath
    }
    
    private func setup_recorder() {
        if isAudioRecordingGranted {
            let session = AVAudioSession.sharedInstance()
            do { try session.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
                try session.setActive(true)
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 2,
                    AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
                ]
                audioRecorder = try AVAudioRecorder(url: getFileUrl(), settings: settings)
                audioRecorder.isMeteringEnabled = true
                audioRecorder.prepareToRecord()
            }
            catch let error {
                aleartAction(msg_title: "Error", msg_desc: error.localizedDescription, action_title: "OK")
            }
        } else {
            aleartAction(msg_title: "Error", msg_desc: "Don't have access to use your microphone.", action_title: "OK")
        }
    }
    
    private  func finishAudioRecording(success: Bool) {
        if success {
            audioRecorder.stop()
            print("recorded successfully.")
        } else {
            aleartAction(msg_title: "Error", msg_desc: "Recording failed.", action_title: "OK")
        }
    }
    
    private func prepare_play() {
        do {
            playerRecord = try AVAudioPlayer(contentsOf: getFileUrl())
            playerRecord.prepareToPlay()
        }
        catch{
            print("Error")
        }
    }
    
    private func aleartAction(msg_title : String , msg_desc : String ,action_title : String) {
        let ac = UIAlertController(title: msg_title, message: msg_desc, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: action_title, style: .default)
                     {
            (result : UIAlertAction) -> Void in
            _ = self.navigationController?.popViewController(animated: true)
        })
        present(ac, animated: true)
    }
    
    
    //    Player
    private func useTrack(track: Track){
        do {
            player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath:   Bundle.main.path(forResource:track.name, ofType: track.format)!))
            label.text = track.name
            player.prepareToPlay()
        }
        catch {
            print(error)
        }
    }
    
    // Actions player
    
    @IBAction func playButton(_ sender: UIButton) {
        if !isPlaying {
            player.play()
            if player.currentTime > 0 {
                view.backgroundColor = .systemYellow
                player.play(atTime: player.currentTime)
            }
            isPlaying = true
            sender.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            player.pause()
            view.backgroundColor = .systemMint
            isPlaying = false
            sender.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
    
    @IBAction func stopButton(_ sender: Any) {
        if player.isPlaying {
            isPlaying = false
            player.stop()
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            player.currentTime = 0.0
            view.backgroundColor = .systemOrange
        } else {
            player.currentTime = 0.0
            print("Already stopped!")
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        view.backgroundColor = .systemPink
        stopButton(self)
        let indexNow = tracks.firstIndex(where: {$0.name == label.text})
        let beforeTrackIndex = tracks.index(before: indexNow!)
        if beforeTrackIndex <= 0 {
            let trackLast = tracks.last!
            useTrack(track: trackLast)
        } else {
            useTrack(track: tracks[beforeTrackIndex])
        }
    }
    
    @IBAction func forwardButtonAction(_ sender: Any) {
        view.backgroundColor = .systemIndigo
        stopButton(self)
        let indexNow = tracks.firstIndex(where: {$0.name == label.text})
        let forwardTrackIndex = tracks.index(after: indexNow!)
        if forwardTrackIndex > tracks.count - 1 {
            useTrack(track: tracks.first!)
        } else {
            useTrack(track: tracks[forwardTrackIndex])
        }
    }
    
    //    Actions recorder
    
    @IBAction func recordButtonAction(_ sender: Any) {
        print("record button pushed")
        if isRecording {
            finishAudioRecording(success: true)
            isRecording = false
        } else {
            setup_recorder()
            audioRecorder.record()
            isRecording = true
        }
    }
    
    @IBAction func playRecordButtonAction(_ sender: Any) {
        print("Play record button pushed")
        if isPlaying {
            playerRecord.stop()
            isPlaying = false
        } else {
            if FileManager.default.fileExists(atPath: getFileUrl().path) {
                prepare_play()
                playerRecord.play()
                isPlaying = true
            } else {
                aleartAction(msg_title: "Error", msg_desc: "Audio file is missing.", action_title: "OK")
            }
        }
    }
}


