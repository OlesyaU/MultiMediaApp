//
//  Track.swift
//  MultiMediaApp
//
//  Created by Олеся on 17.12.2022.
//

import Foundation
struct Track {
    let name: String
    let format = "mp3"
    
    
    static func trackArray() -> [Track] {
        var array = [Track]()
        array.append(Track(name: "Experience"))
        array.append(Track(name: "Roc"))
        array.append(Track(name: "Night"))
        array.append(Track(name: "FLY"))
        array.append(Track(name: "Walk"))
        array.append(Track(name: "Primavera"))
        
        return array
    }
}
