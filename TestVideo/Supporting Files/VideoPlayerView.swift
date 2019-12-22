//
//  VideoPlayerView.swift
//  TestVideo
//
//  Created by Oleg Soloviev on 21/12/2019.
//  Copyright © 2019 Oleg Soloviev. All rights reserved.
//

import UIKit
import AVFoundation

final class VideoPlayerView: UIView {

    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set (value) {
            playerLayer.player = value
        }
    }

    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    private var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }

}
