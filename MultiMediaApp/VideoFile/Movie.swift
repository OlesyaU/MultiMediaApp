//
//  Movie.swift
//  MultiMediaApp
//
//  Created by Олеся on 21.12.2022.
//

import Foundation

struct Movie {
    var name: String
    let format = "mp4"
    
    static func movieArray() -> [Movie] {
        var array = [Movie]()
        array.append(Movie(name: "клип1"))
        array.append(Movie(name: "клип2"))
        array.append(Movie(name: "клип3"))
        array.append(Movie(name: "клип4"))
        array.append(Movie(name: "клип5"))
        return array
    }
    
    static func streamMovieArray() -> [Movie] {
        var array = [Movie]()
        array.append(Movie(name: "GEKIWp7vqOY"))
        array.append(Movie(name: "sI5sm72eLkw"))
        array.append(Movie(name: "FXQKw9LgDRU"))
        array.append(Movie(name: "7kFAAvtOTi8"))
        array.append(Movie(name: "USK1VjV-nO8"))
        return array
    }
}
