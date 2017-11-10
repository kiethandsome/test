//
//  MainViewController.swift
//  test
//
//  Created by Kiet on 10/11/17.
//  Copyright © 2017 Kiet. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import Alamofire
import AlamofireSwiftyJSON
import Hero
import MBProgressHUD


class MainViewController: ASViewController<ASTableNode>{
    
    var models = [Model]() {
        didSet {
            self.node.reloadData()
        }
    }
    var videoPlayerNode: ASVideoPlayerNode?
    var indexPath: IndexPath?
    
    init() {
        super.init(node: ASTableNode())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isHeroEnabled = true
        self.navigationController?.heroNavigationAnimationType = .fade
        self.navigationController?.isNavigationBarHidden = true
        
        self.node.view.separatorStyle = .none
        self.node.dataSource = self
        self.node.delegate = self
        
        self.getDataFormServer(completion: { (models) in
            if let models = models {
                self.models = models
            }
        })
    }
}

extension MainViewController: ASTableDelegate, ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return models.count
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        let cell = tableNode.nodeForRow(at: indexPath) as? ImageCell
        
        switch indexPath.row {
        case 0:
            break
        case 1:
            if indexPath.section % 2 == 0 {
                //
            } else {
                let imageVc = ImageViewController()
                imageVc.image = cell?.postImageNode.image
                imageVc.indexPath = indexPath.section
                self.navigationController?.pushViewController(imageVc, animated: true)
            }
        case 2:
            break
        case 3:
            break
        default:
            break
        }
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let model = models[indexPath.section]
        
        switch indexPath.row {
        case 0:
            let firstCell: ASCellNodeBlock = {
                return FirstCell.init(withModel: model)
            }
            return firstCell
        case 1:
            if indexPath.section % 2 == 0 {
                let videoCell: ASCellNodeBlock = {
                    
                    let cell = VideoCell.init(model: model)
                    
                    if (self.videoPlayerNode != nil) {
                        cell.videoPlayerNode = self.videoPlayerNode!
                    } else {
                        cell.delegate = self
                        DispatchQueue.main.async {
                            cell.parentNode.view.heroID = "video_\(indexPath.section)"
                            print("video_\(indexPath.section)")
                        }
                    }
                    return cell
                }
                return videoCell
            } else {
                let secondCell: ASCellNodeBlock = {
                    let cell = ImageCell.init(model: model)
                    cell.selectionStyle = .none
                    DispatchQueue.main.sync {
                        cell.postImageNode.view.heroID = "image_\(indexPath.section)"
                        cell.view.heroModifiers = [.fade]
                        cell.postImageNode.view.heroModifiers = [.arc]
                        cell.postImageNode.view.isOpaque = true
                    }
                    return cell
                }
                return secondCell
            }
        case 2:
            let tittleCell: ASCellNodeBlock = {
                return TittleCell.init(model: model)
            }
            return tittleCell
        case 3:
            let finalCell: ASCellNodeBlock = {
                return ThirdCell.init(model: model)
            }
            return finalCell
        default:
            let nodeBlock : ASCellNodeBlock = {
                return ASCellNode()
            }
            return nodeBlock
        }
    }
}

// Mark: Video Cell Delegate
extension MainViewController: VideoCellDelegate {
    func didTapVideo(video: ASVideoPlayerNode, index: Int?, indexPath: IndexPath) {
        let heroVc = VideoViewController()
        heroVc.index = index
        heroVc.videoPlayerNode = video
        heroVc.indexPath = indexPath
        heroVc.delegate = self as? PresentedVideoDelegate
        show(heroVc, sender: nil)
    }
    
    func didTapVideoCell(currentTime: CGFloat, index: Int, link: String) {

    }
}

extension MainViewController {
    func getDataFormServer(completion: @escaping ([Model]?) -> Void) {
        let URL = "http://www.json-generator.com/api/json/get/cpIYkghIEi?indent=2"
        MBProgressHUD.showAdded(to: node.view, animated: true)
        Alamofire.request(URL, method: .get).responseSwiftyJSON { response in
            MBProgressHUD.hide(for: self.node.view, animated: true)
            
            if (response.result.isSuccess == false || (response.error != nil)) {
                print("Fail to request!")
                let alert = UIAlertController(title: "Lỗi!", message: "Ko thể thực hiện request lên server. Thoát?", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                completion(nil)
            } else {
                var models = [Model]()
                response.value?.arrayValue.forEach({ (json) in
                    let newModel = Model()
                    newModel.initWithData(data: json.dictionaryObject!)
                    print("\n my video link: \(newModel.videoLink!)")
                    models.append(newModel)
                })
                completion(models)
            }
        }
    }
}

extension MainViewController: HeroViewControllerDelegate {
    func heroWillStartAnimatingTo(viewController: UIViewController) {
        if viewController is ImageViewController {
        } else {
            self.node.view.heroModifiers = [.cascade]
        }
    }
    func heroWillStartAnimatingFrom(viewController: UIViewController) {
        self.node.view.heroModifiers = [.cascade]
    }
}















