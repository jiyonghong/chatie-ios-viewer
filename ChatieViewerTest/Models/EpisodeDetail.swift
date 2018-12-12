//
//  EpisodeDetail.swift
//  ChatieViewerTest
//
//  Created by redice on 07/12/2018.
//  Copyright © 2018 Jiyong Hong. All rights reserved.
//

import SwiftyJSON


struct EpisodeDetail: Encodable {
    typealias Event = Never
    
    let id: Int
    let title: String
    let storyId: Int
    let storyTitle: String
    let episodeCount: Int
    let position: Int
    let url: String
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.title = json["title"].stringValue
        self.storyId = json["story"]["id"].intValue
        self.storyTitle = json["story"]["title"].stringValue
        self.episodeCount = json["episodeCount"].intValue
        self.position = json["position"].intValue
        self.url = json["content"]["attachment"]["url"].stringValue
    }
}
