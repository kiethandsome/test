//
//  hero.swift
//  test
//
//  Created by Kiet on 10/13/17.
//  Copyright © 2017 Kiet. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import Hero
import AVKit
import AVFoundation

//typealias MyClosure = () -> ()

protocol PresentedVideoDelegate : class {
    func sendBackVideo(video: ASVideoPlayerNode, index: Int)
}

class VideoViewController: ASViewController<ASDisplayNode> {

    var panGesture = UIPanGestureRecognizer()
    var currentTime: CGFloat?
    var currentTime2 = CGFloat()
    var videoLink: String?
    var index: Int?
    var videoPlayerNode = ASVideoPlayerNode()
    var parentNode = ASDisplayNode()
    var seekButton = ASButtonNode()
    var delegate: PresentedVideoDelegate?
    var closure = { (video: ASVideoPlayerNode, index: Int) -> () in
        let videoCell = VideoCell()
        videoCell.videoPlayerNode = video
    }
    var indexPath: IndexPath?
    
    init() {
        super.init(node: ASDisplayNode())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isHeroEnabled = true
        seekButton.frame = CGRect(x: 10, y: 10, width: 40, height: 20)
        seekButton.setTitle("Seek", with: UIFont.systemFont(ofSize: 12), with: .white, for: .normal)
        seekButton.addTarget(self, action: #selector(seek), forControlEvents: .allEvents)
        
        node.addSubnode(seekButton)
        node.addSubnode(parentNode)
        parentNode.addSubnode(videoPlayerNode)
        
        videoPlayerNode.muted = true
        videoPlayerNode.delegate = self
        if let _ = index {
            parentNode.view.heroID = "video_\(index!)"
            print("\n video_\(index!)")
        }
        parentNode.view.heroModifiers = [.useNoSnapshot, .useScaleBasedSizeChange, .backgroundColor(.red)]

        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        view.addGestureRecognizer(panGesture)
        node.automaticallyManagesSubnodes = true
    }
    
    func seek() {
        hero_dismissViewController()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        videoPlayerNode.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.width / 16 * 9)
        parentNode.frame = videoPlayerNode.frame
        parentNode.view.center = view.center
    }
    
    func handlePanGesture() {
        
        let translation = panGesture.translation(in: nil)
        let progress = translation.y / 2 / view.bounds.height

        switch panGesture.state {
            
        case .began:
            /// begin the transition as normal
            dismiss(animated: true, completion: {
                let appDelegate  = UIApplication.shared.delegate as! AppDelegate
                let mainVC = appDelegate.window!.rootViewController as! MainViewController
                mainVC.node.nodeForRow(at: self.indexPath!)
                mainVC.videoPlayerNode = self.videoPlayerNode
                mainVC.indexPath = self.indexPath!
            })
            
        case .changed:
            /// calculate the progress based on how far the user moved
            Hero.shared.update(progress)
            let currentPosition = CGPoint(x: translation.x + view.center.x, y: translation.y + view.center.y)
            Hero.shared.apply(modifiers: [.position(currentPosition)], to: parentNode.view)

        default:
            if progress + panGesture.velocity(in: nil).y / view.bounds.height > 0.3 {
                Hero.shared.finish()
                closure(videoPlayerNode, index!)
            } else {
                Hero.shared.cancel()
            }
            break
        }
    }
}

extension VideoViewController: ASVideoPlayerNodeDelegate {
    
    func videoPlayerNode(_ videoPlayer: ASVideoPlayerNode, willChangeVideoNodeState state: ASVideoNodePlayerState, toVideoNodeState toState: ASVideoNodePlayerState) {
        switch toState {
        case .unknown:
            break
        case .initialLoading:
            break
        case .loading:
            break
        case .playing:
            break
        case .readyToPlay:
            videoPlayer.seek(toTime: 50)
            break
        case .finished:
            break
        default:
            break
        }
    }
    
    func videoPlayerNode(_ videoPlayer: ASVideoPlayerNode, didPlayTo time: CMTime) {
        let seconds = CMTimeGetSeconds(time)
        let newTime = Float(seconds) * 100 / Float(CMTimeGetSeconds(videoPlayer.duration))
        currentTime2 = CGFloat(newTime)
    }
    
    func videoPlayerNodeScrubberThumbImage(_ videoPlayer: ASVideoPlayerNode) -> UIImage {
        return UIImage(named: "circle2")!
    }
    
    func videoPlayerNodeScrubberMinimumTrackTint(_ videoPlayer: ASVideoPlayerNode) -> UIColor {
        return .red
    }
}













