//
//  ImageViewController.swift
//  test
//
//  Created by Kiet on 10/20/17.
//  Copyright © 2017 Kiet. All rights reserved.
//

import UIKit
import Hero
import AsyncDisplayKit

class ImageViewController: ASViewController<ASDisplayNode> {
    
    var image: UIImage!
    var imageNode : ASImageNode = {
        let node = ASImageNode()
        node.contentMode = .scaleAspectFill
        
        return node
    }()
    var panGesture = UIPanGestureRecognizer()
    var indexPath: Int!
    
    init() {
        super.init(node: ASDisplayNode())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isHeroEnabled = true
        self.navigationController?.heroNavigationAnimationType = .fade
        self.navigationController?.isNavigationBarHidden = true
        
        imageNode.image = self.image
        imageNode.frame.size = CGSize(width: view.bounds.width, height: view.bounds.width)
        imageNode.contentMode = .scaleAspectFill
        self.imageNode.view.center = self.node.view.center
        self.node.automaticallyManagesSubnodes = true
        self.node.addSubnode(self.imageNode)
        
        view.backgroundColor = .black
        imageNode.view.heroID = "image_\(indexPath!)"
        
        self.imageNode.view.heroModifiers = [.position(CGPoint(x:view.bounds.width/2, y:view.bounds.height+view.bounds.width/2)), .scale(0.6), .fade]
        self.imageNode.view.isOpaque = true
        preferredContentSize = CGSize(width: view.bounds.width, height: view.bounds.width)
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
    }
    
    func handlePanGesture() {
        let translation = panGesture.translation(in: nil)
        let progress = translation.y / 2 / view.bounds.height
        
        switch panGesture.state {
        case .began:
            hero_dismissViewController()
        case .changed:
            Hero.shared.update(progress)
            let positon = CGPoint(x: translation.x + view.center.x, y: translation.y + view.center.y)
            Hero.shared.apply(modifiers: [.position(positon)], to: imageNode.view)
        default:
            if progress + panGesture.velocity(in: nil).y / view.bounds.height > 0.3 {
                Hero.shared.finish()
            } else {
                Hero.shared.cancel(animate: true)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ImageViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let v = panGesture.velocity(in: nil)
        return v.y > abs(v.x)
    }
}
