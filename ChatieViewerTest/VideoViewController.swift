//
//  VideoViewController.swift
//  ChatieViewerTest
//
//  Created by redice on 05/12/2018.
//  Copyright © 2018 Jiyong Hong. All rights reserved.
//

import UIKit
import AVKit
import Hero


class PlayerViewController: UIViewController, AVPlayerViewControllerDelegate {
    var videoURL: URL
    
    var initialY: CGFloat?
    
    var playerView: UIView!
    var playerViewController: AVPlayerViewController!
    var panGestureRecognizer: UIPanGestureRecognizer!
    
    var closeButton: UIButton!
    
    init(videoURL url: URL) {
        self.videoURL = url
        
        super.init(nibName: nil, bundle: nil)
        
        self.hero.isEnabled = true
        self.hero.modalAnimationType = .fade
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(_:)))
        view.addGestureRecognizer(panGestureRecognizer!)
        
        let player = AVPlayer(url: self.videoURL)

        self.playerViewController = AVPlayerViewController()
        self.playerViewController.player = player
        self.playerViewController.delegate = self
        self.playerViewController.allowsPictureInPicturePlayback = false
        self.playerViewController.showsPlaybackControls = false
        
        self.addChild(self.playerViewController)
        
        self.playerView = self.playerViewController.view!
        self.playerView.frame = self.view.bounds
        
        self.view.addSubview(playerView!)
        self.playerViewController.didMove(toParent: self)
        
        self.closeButton = UIButton()
        self.closeButton.setTitle("닫기", for: .normal)
        self.closeButton.setTitleColor(.white, for: .normal)
        self.closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        self.closeButton.addTarget(self, action: #selector(self.close), for: .touchUpInside)
        self.closeButton.layer.zPosition = 9;
        self.closeButton.contentMode = .scaleToFill
        self.view.addSubview(self.closeButton)
        
        player.play()
        
        self.view.setNeedsUpdateConstraints()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        self.closeButton.snp.makeConstraints() { make in
            make.top.equalTo(self.view.safeAreaInsets.top)
            make.right.equalTo(-16)
        }
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
        let progress = abs(translation.y) / 2 / view.bounds.height
        
        switch self.panGestureRecognizer.state {
        case .began:
            self.initialY = self.playerView.center.y
            self.dismiss(animated: true, completion: nil)
        case .changed:
            Hero.shared.update(progress)
            
            self.playerView.isOpaque = false
            
            self.playerView.center = CGPoint(
                x: self.playerView.center.x,
                y: translation.y + self.initialY!
            )
        default:
            if abs(translation.y) / view.bounds.height > 0.3 {
                Hero.shared.finish(animate: true)
            } else {
                UIView.animate(withDuration: 0.2) {
                    self.playerView.frame.origin = CGPoint(x: 0, y: 0)
                }
                Hero.shared.cancel()
            }
        }
    }
}
