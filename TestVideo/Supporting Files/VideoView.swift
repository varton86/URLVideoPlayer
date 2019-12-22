//
//  VideoView.swift
//  TestVideo
//
//  Created by Oleg Soloviev on 21/12/2019.
//  Copyright © 2019 Oleg Soloviev. All rights reserved.
//

import UIKit
import AVFoundation

final class VideoView: UIView {
    
    private(set) lazy var playerView = VideoPlayerView()
    private(set) lazy var loadingIndicator = makeLoadingIndicator()

    override func layoutSubviews() {
        super.layoutSubviews()

        loadingIndicator.frame = bounds
        addSubview(loadingIndicator)

        playerView.frame = bounds
        addSubview(playerView)
    }
        
    func pause() {
        playerView.player?.pause()
    }
    
    func play() {
        playerView.player?.play()
    }
    
    private func makeLoadingIndicator() -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        view.color = .white
        view.hidesWhenStopped = true
        return view
    }

}
