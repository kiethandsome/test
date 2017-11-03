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
    
    var models = [Model]()
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
        self.node.allowsSelection = false
        self.node.view.separatorStyle = .none
        self.node.dataSource = self
        self.node.delegate = self
        self.node.leadingScreensForBatching = 1.0
        DispatchQueue.main.async {
            self.getDataFormServer()
        }
        self.isHeroEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let _ = indexPath {
            node.nodeForRow(at: indexPath!)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.node.view.contentInset.top = 20
    }
    
    /// mark: Read json file.
    
    func readFile() {
        let file = Bundle.main.path(forResource: "generated", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: file!))
        let jsonData = try? JSONSerialization.jsonObject(with: data!, options: [])
        if (jsonData as? [[String:String]]) != nil {
            print(jsonData!)
        }
        print(jsonData!)
    }
}

extension MainViewController: ASTableDelegate, ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return models.count
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 4
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
                    let cell = SecondCell.init(model: model)
                    cell.delegate = self as SecondCellDelegate
                    DispatchQueue.main.sync {
                        cell.postImageNode.view.heroID = "image_\(indexPath.section)"
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
        present(heroVc, animated: true, completion: nil)
    }
    
    func didTapVideoCell(currentTime: CGFloat, index: Int, link: String) {

    }
}

// Mark: Image Cell Delegate

extension MainViewController: SecondCellDelegate {
    func didTapImageCell(imageLink: String, indexPath: Int) {
        let imageVc = ImageViewController()
        imageVc.imageLink = imageLink
        imageVc.indexPath = indexPath
        self.present(imageVc, animated: true, completion: nil)
    }
}

extension MainViewController {
    
    func getDataFormServer() {
        let URL = "http://www.json-generator.com/api/json/get/cpIYkghIEi?indent=2"
        MBProgressHUD.showAdded(to: node.view, animated: true)
        Alamofire.request(URL, method: .get).responseSwiftyJSON { response in
            MBProgressHUD.hide(for: self.node.view, animated: true)
            print("###Success: \(response.result.isSuccess)")
            
            ///now response.result.value is SwiftyJSON.JSON type
            ///print("Value:\(response.result.value!)")
            
            if (response.result.isSuccess == false || (response.error != nil)) {
                print("Fail to request!")
                let alert = UIAlertController(title: "Lỗi!", message: "Ko thể thực hiện request lên server. Thoát?", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (self) in
                    /// UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
                    exit(0)
                }))
                self .present(alert, animated: true, completion: nil)
            } else {
                for jsonDict in (response.result.value?.arrayValue)! {
                    let newModel = Model()
                    newModel.initWithData(data: jsonDict.dictionaryObject!)
                    print("\n my video link: \(newModel.videoLink!)")
                    self.models.append(newModel)
                }
            }
            self.node.reloadData()
        }
    }
}















