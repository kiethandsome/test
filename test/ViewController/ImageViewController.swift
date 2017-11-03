//
//  ImageViewController.swift
//  test
//
//  Created by Kiet on 10/20/17.
//  Copyright © 2017 Kiet. All rights reserved.
//

import UIKit
import SDWebImage
import Hero

class ImageViewController: UIViewController {
    
    var imageLink: String!
    var imageView = UIImageView()
    var panGesture = UIPanGestureRecognizer()
    var indexPath: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isHeroEnabled = true
        imageView.sd_setImage(with: URL(string: imageLink), completed: nil)
        view.addSubview(imageView)
        view.backgroundColor = .black
        imageView.heroID = "image_\(indexPath!)"
        imageView.heroModifiers = [.zPosition(4)]
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
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
            Hero.shared.apply(modifiers: [.position(positon)], to: imageView)
        default:
            if progress + panGesture.velocity(in: nil).y / view.bounds.height > 0.3 {
                Hero.shared.finish()
            } else {
                Hero.shared.cancel()
            }
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame.size = CGSize(width: view.bounds.width, height: view.bounds.height / 3)
        imageView.contentMode = .scaleAspectFill
        imageView.center = view.center
    }

}
