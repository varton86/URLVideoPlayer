//
//  MainView.swift
//  TestVideo
//
//  Created by Oleg Soloviev on 22/12/2019.
//  Copyright © 2019 Oleg Soloviev. All rights reserved.
//

import UIKit

final class MainView: UIView {
    
    private(set) lazy var videoView = VideoView()
    private(set) lazy var urlTextField = makeTextField()
    private(set) lazy var playButton = makePlayButton()
    private(set) lazy var downloadButton = makeDownloadButton()
    private(set) lazy var progressDownloadIndicator = UIProgressView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        viewConfigure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        let padding: CGFloat = 16
        let topOffset: CGFloat = safeAreaInsets.top + padding
        let widthWithPadding = bounds.width - (padding*2)
        
        let urlTextFieldHeight = urlTextField.sizeThatFits(CGSize(width: widthWithPadding, height: .infinity)).height
        urlTextField.frame = CGRect(x: padding, y: topOffset, width: widthWithPadding, height: urlTextFieldHeight)
        
        let videoViewHeght = (widthWithPadding*9/16) + padding*4
        let yVideoView = topOffset + urlTextFieldHeight + padding
        videoView.frame = CGRect(x: padding, y: yVideoView, width: widthWithPadding, height: videoViewHeght)

        let progressDownloadIndicatorHeight = progressDownloadIndicator.sizeThatFits(CGSize(width: widthWithPadding, height: .infinity)).height
        let yProgressDownloadIndicator = yVideoView + videoViewHeght - padding
        progressDownloadIndicator.frame = CGRect(x: padding, y: yProgressDownloadIndicator, width: widthWithPadding, height: progressDownloadIndicatorHeight)

        let buttonWidth = (widthWithPadding - padding)/2
        let yPlayButton = yVideoView + videoView.frame.height + padding
        let playButtonHeight = playButton.sizeThatFits(CGSize(width: widthWithPadding, height: .infinity)).height
        playButton.frame = CGRect(x: padding, y: yPlayButton, width: buttonWidth, height: playButtonHeight)
        downloadButton.frame = CGRect(x: bounds.width - padding - buttonWidth, y: yPlayButton, width: buttonWidth, height: playButtonHeight)
    }

}

private extension MainView {
    
    func viewConfigure() {
        backgroundColor = .white

        addSubview(urlTextField)
        addSubview(playButton)
        addSubview(downloadButton)

        videoView.layer.cornerRadius = 12
        videoView.backgroundColor = .black
        addSubview(videoView)

        progressDownloadIndicator.isHidden = true
        addSubview(progressDownloadIndicator)
    }
    
    func makeTextField() -> UITextField {
        let textField = UITextField()
        textField.textContentType = .URL
        textField.placeholder = "Enter video URL"
        return textField
    }
    
    func makePlayButton() -> UIButton {
        let button = makeButton()
        button.setTitle("Play", for: .normal)
        return button
    }
    
    func makeDownloadButton() -> UIButton {
        let button = makeButton()
        button.setTitle("Download", for: .normal)
        return button
    }
    
    func makeButton() -> UIButton {
        let button = UIButton()
        button.layer.cornerRadius = 6
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        return button
    }    
    
}

