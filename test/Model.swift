//
//  Model.swift
//  test
//
//  Created by Kiet on 10/11/17.
//  Copyright © 2017 Kiet. All rights reserved.
//

import UIKit
import SwiftyJSON

class Model: NSObject{
    
    var name:String!
    var time:Int!
    var imageContent: String!
    var likes: Int!
    var comments: Int!
    var caption:String!
    var avatar:String!
    var shareds:Int!
    var videoLink:String!
    
    func initWithData(data:[String:Any?]) {
        let nameC = data["name"]
        if let _ = nameC {
            self.name = nameC as! String
        } else {
            self.name = ""
        }
        
        let timeC = data["time"]
        if let _ = timeC {
            self.time = timeC as! Int
        } else {
            self.time = 0
        }
        
        let likesC = data["like"]
        if let _ = likesC {
            self.likes = likesC as! Int
        } else {
            self.likes = 0
        }
        
        let captionC = data["caption"]
        if let _ = captionC {
            self.caption = captionC as! String
        } else {
            self.caption = ""
        }
        
        let imageContentC = data["picture"]
        if let _ = imageContentC {
            self.imageContent = imageContentC as! String
        } else {
            self.imageContent = "Con chim non"
        }
        
        let avatarC = data["avatar"]
        if let _ = avatarC {
            self.avatar = avatarC as! String
        } else {
            self.avatar = "Con chim non"
        }
        
        let commentsC = data["comment"]
        if let _ = commentsC {
            self.comments = commentsC as! Int
        } else {
            self.comments = 0
        }
        
        let sharedC = data["shared"]
        if let _ = sharedC {
            self.shareds = sharedC as! Int
        } else {
            self.shareds = 0
        }
        
        let video = data["video"]
        if let _ = video {
            self.videoLink = video as! String
        } else {
            self.videoLink = "Link does not exsist"
        }
    }
}











