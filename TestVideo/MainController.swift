//
//  MainController.swift
//  TestVideo
//
//  Created by Oleg Soloviev on 21/12/2019.
//  Copyright © 2019 Oleg Soloviev. All rights reserved.
//

import AVKit

final class MainController: BaseController<MainView> {
    
    private var reachability: Reachability!
    private var player: AVPlayer?
    private var urlText: String?
    private var videoPlayed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupNotifications()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        root.setupSubviews()
    }
    
}

private extension MainController {
    
    func setupUI() {
        title = "Video Show"
        playButtonEnabled(false)
        downloadButtonEnabled(false)
        root.urlTextField.delegate = self
        root.playButton.addTarget(self, action: #selector(playButtonPressed), for: .touchUpInside)
        root.downloadButton.addTarget(self, action: #selector(downloadButtonPressed), for: .touchUpInside)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnView)))
    }
        
    func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerItemDidReachEnd),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: root.videoView.playerView.player?.currentItem)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationWillResignActive),
            name: NSNotification.Name.UIApplicationWillResignActive,
            object: root.videoView.playerView.player?.currentItem)
        reachability = try! Reachability()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reachabilityChanged(note:)),
            name: .reachabilityChanged,
            object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            debugPrint("Could not start reachability notifier")
        }
    }
    
    @objc
    func playButtonPressed() {
        root.urlTextField.resignFirstResponder()
        if videoPlayed {
            videoOnPause()
        } else {
            videoOnPlay()
        }
    }
    
    @objc
    func tapOnView() {
        root.urlTextField.resignFirstResponder()
    }
    
    @objc
    func downloadButtonPressed() {
        root.urlTextField.resignFirstResponder()
        downloadWithProgress()
    }
    
    func downloadWithProgress() {
        if let text = root.urlTextField.text, !text.contains("m3u8"), text.isValidURL, let videoURL = URL(string: text), UIApplication.shared.canOpenURL(videoURL) {
            downloadStarted()
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
            let downloadTask = session.downloadTask(with: videoURL)
            root.progressDownloadIndicator.progress = 0
            root.progressDownloadIndicator.isHidden = false
            downloadTask.resume()
        } else {
            showError("Incorrect URL")
        }
    }
    
    func storeFileLocally(remoteFileUrl: URL, data: NSData?) {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileName = remoteFileUrl.lastPathComponent
        
        if let destinationUrl = documentsUrl?.appendingPathComponent(fileName), let data = data, data.write(to: destinationUrl, atomically: true) {
            debugPrint("File saved at \(destinationUrl)")
            videoOnPlay()
        } else {
            showError("Unable to write file")
        }
    }

    func getFileLocalPathByUrl(fileUrl: URL) -> URL? {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileName = fileUrl.lastPathComponent
        let destinationUrl = documentsUrl?.appendingPathComponent(fileName)
        
        if let filePath = destinationUrl?.path, FileManager().fileExists(atPath: filePath) {
            return destinationUrl
        }
        
        return nil
    }

    func downloadStarted() {
        root.videoView.loadingIndicator.startAnimating()
        playButtonEnabled(false)
        urlTextFieldEnabled(false)
        downloadButtonEnabled(false)
        player = nil
        root.videoView.playerView.player = nil
    }
    
    func downloadStopped() {
        root.videoView.loadingIndicator.stopAnimating()
        playButtonEnabled(true)
        urlTextFieldEnabled(true)
        downloadButtonEnabled(true)
    }
    
    func videoOnPause() {
        root.videoView.loadingIndicator.stopAnimating()
        root.videoView.pause()
        
        root.playButton.setTitle("Play", for: .normal)
        root.playButton.setTitleColor(.white, for: .normal)
        
        urlTextFieldEnabled(true)
        downloadButtonEnabled(true)
        videoPlayed = false
    }

    func videoOnPlay() {
        if let text = root.urlTextField.text, text.isValidURL, let videoURL = URL(string: text), UIApplication.shared.canOpenURL(videoURL) {
            root.videoView.loadingIndicator.startAnimating()
            if player == nil || urlText != text {
                urlText = text
                var url = videoURL
                if let filePath = getFileLocalPathByUrl(fileUrl: videoURL) {
                    url = filePath
                }
                player = AVPlayer(url: url)
                root.videoView.playerView.player = player
            }
            root.videoView.play()
            
            root.playButton.setTitle("Pause", for: .normal)
            root.playButton.setTitleColor(.red, for: .normal)
            
            urlTextFieldEnabled(false)
            downloadButtonEnabled(false)
            videoPlayed = true
        } else {
            root.videoView.loadingIndicator.stopAnimating()
            showError("Incorrect URL")
        }
    }
    
    func urlTextFieldEnabled(_ value: Bool) {
        if value {
            root.urlTextField.isEnabled = true
            root.urlTextField.textColor = .black
        } else {
            root.urlTextField.isEnabled = false
            root.urlTextField.textColor = .gray
        }
    }
    
    func playButtonEnabled(_ value: Bool) {
        if value {
            root.playButton.isEnabled = true
            root.playButton.setTitleColor(.white, for: .normal)
        } else {
            root.playButton.isEnabled = false
            root.playButton.setTitleColor(.gray, for: .normal)
        }
    }
    
    func downloadButtonEnabled(_ value: Bool) {
        if value {
            root.downloadButton.isEnabled = true
            root.downloadButton.setTitleColor(.white, for: .normal)
        } else {
            root.downloadButton.isEnabled = false
            root.downloadButton.setTitleColor(.gray, for: .normal)
        }
    }
    
    @objc
    func playerItemDidReachEnd(notification: NSNotification) {
        if let playerItem: AVPlayerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: kCMTimeZero, completionHandler: {[weak self] _ in self?.videoOnPause()})
        }
    }
    
    @objc
    func applicationWillResignActive(notification: NSNotification) {
        if videoPlayed {
            videoOnPause()
        }
    }
    
    @objc
    func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .unavailable:
            if videoPlayed {
                videoOnPause()
            }
            showError("Network not reachable")
        default: break
        }
    }
    
}

extension MainController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        guard let text = textField.text else { return false }
        let newLength = text.count + string.count - range.length
        if newLength > 0 {
            playButtonEnabled(true)
            downloadButtonEnabled(true)
        } else {
            playButtonEnabled(false)
            downloadButtonEnabled(false)
        }
        return true
    }
}

extension MainController: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        debugPrint("Download task did resume")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        
        DispatchQueue.main.async { [weak self] in
            self?.root.progressDownloadIndicator.progress = progress
        }
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        debugPrint("Download task did finish")
        
        weak var weakSelf = self
        if let videoUrl = downloadTask.originalRequest?.url, let data = NSData(contentsOf: location) {
            DispatchQueue.main.async {
                weakSelf?.downloadStopped()
                weakSelf?.storeFileLocally(remoteFileUrl: videoUrl, data: data)
                weakSelf?.root.progressDownloadIndicator.isHidden = true
            }
        } else {
            DispatchQueue.main.async {
                weakSelf?.downloadStopped()
                weakSelf?.showError("Incorrect URL")
            }
        }
    }

}
