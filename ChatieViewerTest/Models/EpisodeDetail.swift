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
    let storyTitle: String
    let episodeCount: Int
    let order: Int
    let url: String
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.title = json["title"].stringValue
        self.storyTitle = json["storyTitle"].stringValue
        self.episodeCount = json["episodeCount"].intValue
        self.order = json["order"].intValue
        self.url = json["url"].stringValue
    }
}
