//
//  AppDelegate.swift
//  MultiMediaApp
//
//  Created by Олеся on 17.12.2022.
//

import UIKit
import AVFoundation
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DispatchQueue.global().async {

            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(.playback, mode: .moviePlayback)
            }
            catch {
                print("Setting category to AVAudioSessionCategoryPlayback failed.")
            }
        }

        return true

    }
}
    
