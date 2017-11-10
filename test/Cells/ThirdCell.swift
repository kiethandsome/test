//
//  thirdCell.swift
//  test
//
//  Created by Kiet on 10/12/17.
//  Copyright © 2017 Kiet. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class ThirdCell: ASCellNode {
    
    var likeImageNode = ASImageNode()
    var likeNumberNode = ASTextNode()
    var commentImageNode = ASImageNode()
    var commentNumberNode = ASTextNode()
    var sharedImageNode = ASImageNode()
    var sharedNumberNode = ASTextNode()
    
    init(model:Model) {
        super.init()
        
        self.likeImageNode.image = UIImage(named: "003-like")
        self.commentImageNode.image = UIImage(named: "comment-white-oval-bubble")
        self.sharedImageNode.image = UIImage(named: "001-photo-symbol-to-share-with-right-arrow")
        
        let fontSizeAttribute = [NSFontAttributeName: UIFont(name: "Avenir Book", size: 12.0)]
        
        self.likeNumberNode.attributedText = NSAttributedString(string: "\(model.likes!) lượt thích", attributes: fontSizeAttribute as Any as? [String : Any])
        self.commentNumberNode.attributedText = NSAttributedString(string: "\(model.comments!) bình luận",attributes: fontSizeAttribute as Any as? [String : Any])
        self.sharedNumberNode.attributedText = NSAttributedString(string: "\(model.shareds!) lượt chia sẻ", attributes: fontSizeAttribute as Any as? [String : Any])
        
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let size = CGSize(width: 15, height: 15)
        likeImageNode.style.preferredSize = size
        commentImageNode.style.preferredSize = size
        sharedImageNode.style.preferredSize = size
        
        let likeStackSpec = ASStackLayoutSpec(direction: .horizontal,
                                     spacing: 2,
                                     justifyContent: .start,
                                     alignItems: .start,
                                     children: [likeImageNode, likeNumberNode])
        
        let commentStackSpec = ASStackLayoutSpec(direction: .horizontal,
                                              spacing: 2,
                                              justifyContent: .start,
                                              alignItems: .start,
                                              children: [commentImageNode, commentNumberNode])
        
        let sharedStackSpec = ASStackLayoutSpec(direction: .horizontal,
                                              spacing: 2,
                                              justifyContent: .start,
                                              alignItems: .start,
                                              children: [sharedImageNode,sharedNumberNode])
        
        let allStackSpec = ASStackLayoutSpec(direction: .horizontal,
                                                spacing: 10,
                                                justifyContent: .start,
                                                alignItems: .start,
                                                children: [likeStackSpec, commentStackSpec,sharedStackSpec])
        
        
        let finalStackSpec = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(5, 10, 30, 10),
                                               child: allStackSpec)
        
        
        return finalStackSpec
    }
    
}














