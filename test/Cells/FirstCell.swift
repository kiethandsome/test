//
//  FirstCell.swift
//  test
//
//  Created by Kiet on 10/11/17.
//  Copyright © 2017 Kiet. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class FirstCell: ASCellNode {
    
    var userName = ASTextNode()
    var postTime = ASTextNode()
    var settingButton = ASImageNode()
    var avatar = ASNetworkImageNode()
    var checkedIcon = ASImageNode()
    
    init(withModel:Model) {
      super.init()
        
        let fontSizeAttribute = [NSFontAttributeName: UIFont(name: "Copperplate", size: 16.0)]
        self.userName.attributedText = NSAttributedString(string: withModel.name, attributes: fontSizeAttribute)

        
        self.postTime.attributedText = NSAttributedString(string: "\(withModel.time.description) minutes ago.")
        self.postTime.tintColor = UIColor.lightGray
        
        self.avatar.url = URL(string: withModel.avatar)
        
        self.checkedIcon.image = UIImage(named: "checked")
        
        DispatchQueue.main.sync {
            self.avatar.layer.cornerRadius = 17.5
            self.avatar.clipsToBounds = true
        }
        
        
        self.settingButton.image = UIImage.init(named: "options")
        self.settingButton.contentMode = .scaleAspectFit 
        
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        avatar.style.preferredSize = CGSize(width: 35, height: 35)
        avatar.style.spacingAfter = 8
        checkedIcon.style.preferredSize = CGSize(width: 15, height: 15)
        
        let NameAndCheckedStack = ASStackLayoutSpec(direction: .horizontal,
                                                    spacing: 5.0,
                                                    justifyContent: .start,
                                                    alignItems: .center,
                                                    children: [userName,checkedIcon])
        

        let nameAndPosttimeStack = ASStackLayoutSpec(direction: .vertical,
                                                     spacing: 5.0,
                                                     justifyContent: .center,
                                                     alignItems: .stretch,
                                                     children: [NameAndCheckedStack, postTime])
        nameAndPosttimeStack.style.flexGrow = 2.0
        
        settingButton.style.preferredSize = CGSize(width: 20, height: 20)
        settingButton.style.spacingAfter = 5


        let bigWrapperStack = ASStackLayoutSpec.horizontal()
        bigWrapperStack.alignItems = .center
        bigWrapperStack.alignContent = .center
        bigWrapperStack.children = [avatar, nameAndPosttimeStack, settingButton]
        
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10),
                                 child: bigWrapperStack)
    }
}






















