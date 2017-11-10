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

class ImageCell: ASCellNode, UIGestureRecognizerDelegate {
    
    let postImageNode : ASNetworkImageNode = {
        let imageNode = ASNetworkImageNode()
        imageNode.contentMode = .scaleAspectFill
        
        return imageNode
    }()
        
    init (model:Model) {
        super.init()
        
        postImageNode.url = URL(string: model.imageContent)
        automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASRatioLayoutSpec(ratio: 1.0, child: postImageNode)
    }
}







