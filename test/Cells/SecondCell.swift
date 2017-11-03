//
//  secondCell.swift
//  test
//
//  Created by Kiet on 10/12/17.
//  Copyright © 2017 Kiet. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import Hero

protocol SecondCellDelegate: class {
    func didTapImageCell(imageLink: String, indexPath: Int)
}

class SecondCell: ASCellNode, UIGestureRecognizerDelegate {
    
    var postImageNode = ASNetworkImageNode()
    var imageLink = String()
    var tapGesture = UITapGestureRecognizer()
    weak var delegate: SecondCellDelegate!
    
    init (model:Model) {
        super.init()
        imageLink = model.imageContent
        postImageNode.url = URL(string: imageLink)
        postImageNode.contentMode = .scaleAspectFill
        postImageNode.shouldRenderProgressImages = true
        automaticallyManagesSubnodes = true
        DispatchQueue.main.sync {
            postImageNode.view.heroModifiers = [.zPosition(4)]
            postImageNode.view.addGestureRecognizer(tapGesture)
            tapGesture.addTarget(view, action: #selector((showImageViewCOntroller)))
            tapGesture.delegate = self.view as? UIGestureRecognizerDelegate
            postImageNode.view.isUserInteractionEnabled = true
        }
    }
    
    @objc func showImageViewCOntroller() {
        self.delegate.didTapImageCell(imageLink: imageLink, indexPath: (indexPath?.section)!)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        postImageNode.style.maxSize = CGSize(width: 100, height: 250)
        let finalSpec = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(10, 0, 0, 0),
                                          child: postImageNode)
        
        return finalSpec
    }

}







