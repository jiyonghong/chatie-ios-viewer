//
//  LastEpisode.swift
//  ChatiePlus
//
//  Created by SeungHyeon Wang on 2018. 12. 6..
//  Copyright © 2018년 Eineblume. All rights reserved.
//

import Foundation

class LastEpisode {
  var id: Int
  var title: String
  var chatIndex: Int
  var sceneIndex: Int

  init(id: Int, title: String, sceneIndex: Int, chatIndex: Int) {
    self.id = id
    self.title = title
    self.sceneIndex = sceneIndex
    self.chatIndex = chatIndex
  }
}
