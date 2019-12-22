//
//  AppDelegate.swift
//  TestVideo
//
//  Created by Oleg Soloviev on 21/12/2019.
//  Copyright © 2019 Oleg Soloviev. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient,
                                                         mode: AVAudioSessionModeMoviePlayback,
                                                         options: [.mixWithOthers])
        let vc = MainController()
        let nav = UINavigationController(rootViewController: vc)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        return true
    }
    
}

