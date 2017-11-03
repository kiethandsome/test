//
//  TittleCell.swift
//  test
//
//  Created by Kiet on 11/1/17.
//  Copyright © 2017 Kiet. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class TittleCell: ASCellNode {
    var postTitleNode = ASTextNode()
    var captionNode = ASTextNode()
    
    init(model: Model) {
        super.init()
        
        postTitleNode.attributedText = NSAttributedString(string:"Con chim non")
        captionNode.attributedText = NSAttributedString(string: model.caption)
        
        automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let verSpec = ASStackLayoutSpec(direction: .vertical,
                                        spacing: 5.0,
                                        justifyContent: .start,
                                        alignItems: .start,
                                        children: [postTitleNode, captionNode])
        
        return ASInsetLayoutSpec(insets: UIEdgeInsets.init(top: 10, left: 10, bottom: 0, right: 10), child: verSpec)
    }
}
