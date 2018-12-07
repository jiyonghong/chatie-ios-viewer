//
//  Episode.swift
//  ChatiePlus
//
//  Created by 왕승현 on 05/12/2018.
//  Copyright © 2018 Eineblume. All rights reserved.
//

import SwiftyJSON
//import DateToolsSwift

struct Episode {
  
  typealias Event = Never
  
  let id: Int
  let title: String
  let commentCount: Int
  let viewCount: Int
  let tapCount: Int
//  let rentalCoin: Int
//  let isOwned: Bool
//  let expired: Date?
//  let published: Date
//  let created: Date
  
  init(json: JSON) {
    self.id = json["id"].intValue
    self.title = json["title"].stringValue
    self.commentCount = json["comment_count"].intValue
    self.viewCount = json["view_count"].intValue
    self.tapCount = json["tap_count"].intValue
//    self.rentalCoin = json["rental_coin"].intValue
//    self.isOwned = json["is_owned"].boolValue
//    self.expired = json["expired"].date
//    self.published = json["published"].dateValue
//    self.created = json["created"].dateValue
  }
}
