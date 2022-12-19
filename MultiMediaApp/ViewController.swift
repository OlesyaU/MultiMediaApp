//
//  ViewController.swift
//  MultiMediaApp
//
//  Created by Олеся on 17.12.2022.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var Player = AVAudioPlayer()
    private var tracks = Track.trackArray()
    private var isPlaying = false
    private let startTrack = Track.trackArray().first
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        useTrack(track: startTrack! )
    }
    
    private func useTrack(track: Track){
        do {
            Player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath:   Bundle.main.path(forResource:track.name, ofType: track.format)!))
            label.text = track.name
            Player.prepareToPlay()
        }
        catch {
            print(error)
        }
    }
    
    @IBAction func playButton(_ sender: UIButton) {
        if !isPlaying {
            Player.play()
            if Player.currentTime > 0 {
                view.backgroundColor = .systemYellow
                Player.play(atTime: Player.currentTime)
            }
            isPlaying = true
            sender.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            Player.pause()
            view.backgroundColor = .systemMint
            isPlaying = false
            sender.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
    
    @IBAction func stopButton(_ sender: Any) {
        if Player.isPlaying {
            isPlaying = false
            Player.stop()
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            Player.currentTime = 0.0
            view.backgroundColor = .systemOrange
        } else {
            Player.currentTime = 0.0
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
    
    
}


