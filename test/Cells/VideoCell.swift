//
//  videoCell.swift
//  test
//
//  Created by Kiet on 10/13/17.
//  Copyright © 2017 Kiet. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import AVFoundation
import Hero
import MBProgressHUD

protocol VideoCellDelegate : class {
    
    func didTapVideo(video: ASVideoPlayerNode, index: Int?, indexPath: IndexPath)
    
    func didTapVideoCell(currentTime: CGFloat, index: Int, link: String)
}

class VideoCell: ASCellNode {
    
    weak var delegate : VideoCellDelegate?
    
    var videoPlayerNode = ASVideoPlayerNode()

    var videoLink: String!
    var currentTime = CMTime()
    var currentTimeValue: CGFloat?
    var parentNode = ASDisplayNode()
    
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
    }
    
    init (model:Model) {
        super.init()
        
        parentNode.backgroundColor = .black
        videoLink = model.videoLink!
        
        DispatchQueue.main.sync {
            parentNode.view.heroModifiers = [.useNoSnapshot, .useScaleBasedSizeChange]
            let asset = AVAsset(url: URL(string: model.videoLink)!)
            videoPlayerNode.asset = asset
        }
        videoPlayerNode.play()
        videoPlayerNode.backgroundColor = .black
        videoPlayerNode.muted = true
        videoPlayerNode.delegate = self
        automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        parentNode.style.preferredSize = CGSize(width: 100, height: 250)
        videoPlayerNode.style.preferredSize = CGSize(width: 100, height: 200)
        
        let overlayLayoutSpec = ASOverlayLayoutSpec(child: parentNode, overlay: videoPlayerNode)
        
        let finalSpec = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(10, 0, 0, 0),
                                          child: overlayLayoutSpec)
        
        return finalSpec
    }
}

extension VideoCell: ASVideoPlayerNodeDelegate {
    
    func didTap(_ videoPlayer: ASVideoPlayerNode) {
        delegate?.didTapVideo(video: videoPlayerNode, index: indexPath?.section, indexPath: indexPath!)
        if let _ = currentTimeValue {
            delegate?.didTapVideoCell(currentTime: currentTimeValue!, index: (indexPath?.section)!, link: videoLink)
        }
    }
    
    func videoPlayerNode(_ videoPlayer: ASVideoPlayerNode, didPlayTo time: CMTime) {
        let duration = videoPlayer.duration
        let durationValue = CMTimeGetSeconds(duration)
        let playingTimeValue = CMTimeGetSeconds(time)
        currentTimeValue = CGFloat(playingTimeValue * 100 / durationValue)
    }
    
    func videoPlayerNodeScrubberThumbImage(_ videoPlayer: ASVideoPlayerNode) -> UIImage {
        return UIImage(named: "circle2")!
    }
    
    func videoPlayerNodeScrubberMinimumTrackTint(_ videoPlayer: ASVideoPlayerNode) -> UIColor {
        return .red
    }

}

extension VideoCell: PresentedVideoDelegate {
    
    func sendBackVideo(video: ASVideoPlayerNode, index: Int) {
        videoPlayerNode = video
    }
}













