//
//  VideoViewController.swift
//  MultiMediaApp
//
//  Created by Олеся on 20.12.2022.
//

import UIKit
import AVFoundation
import AVKit
import WebKit

class VideoViewController: UIViewController {
    
    private let movieArray = Movie.movieArray()
    private var streamMovieArray = Movie.streamMovieArray()
    private lazy var arrayAll = [movieArray, streamMovieArray]
    private var startEndVideo: String?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        streamVideoPlayer(videoCode: startEndVideo ?? streamMovieArray[0].name)
    }
    
    private func localVideoPlayer(movie: Movie) {
        let path = Bundle.main.path(forResource: movie.name, ofType: movie.format)!
        let localURL = URL(fileURLWithPath: path)
        let player = AVPlayer(url: localURL)
        let controller = AVPlayerViewController()
        controller.player = player
        present(controller, animated: true)
        player.play()
    }
    
    private func streamVideoPlayer(videoCode: String) {
        let videoURL = URL(string: "https://www.youtube.com/embed/\(videoCode)")!
        let myRequest = URLRequest(url: videoURL)
        webView.load(myRequest)
    }
}

extension VideoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 0:
                return "Library"
            case 1:
                return "YouTube"
            default:
                break
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }
}

extension VideoViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        tableView.separatorStyle = .singleLine
        return arrayAll.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return movieArray.count
        } else {
            return streamMovieArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        content.text = arrayAll[indexPath.section][indexPath.row].name
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            localVideoPlayer(movie: movieArray[indexPath.row])
        } else {
            startEndVideo = streamMovieArray[indexPath.row].name
            streamVideoPlayer(videoCode: streamMovieArray[indexPath.row].name)
        }
    }
}
