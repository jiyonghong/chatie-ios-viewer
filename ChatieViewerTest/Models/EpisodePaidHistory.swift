//
//  EpisodePaidHistory.swift
//  ChatiePlus
//
//  Created by SeungHyeon Wang on 2018. 12. 6..
//  Copyright © 2018년 Eineblume. All rights reserved.
//

import Realm
import RealmSwift

// 탭 포인트 사용 히스토리
class EpisodePaidHistory: Object {
  @objc dynamic var episodeID: Int = 0
  @objc dynamic var sceneIndex: Int = 0
  @objc dynamic var chatIndex: Int = 0

  convenience init(episode: EpisodeDetail, sceneIndex: Int, chatIndex: Int) {
    self.init()
    self.episodeID = episode.id
    self.sceneIndex = sceneIndex
    self.chatIndex = chatIndex
  }

  class func save(episode: EpisodeDetail,
                  sceneIndex: Int,
                  chatIndex: Int) {
    let realm = try! Realm()

    let filteredPaidHistory = realm.objects(EpisodePaidHistory.self)
      .filter { $0.episodeID == episode.id }
      .first

    guard let paidHistory = filteredPaidHistory else {
      try! realm.write {
        let paidHistory = EpisodePaidHistory(
          episode: episode,
          sceneIndex: sceneIndex,
          chatIndex: chatIndex)
        realm.add(paidHistory)
      }
      return
    }

    try! realm.write {
      paidHistory.chatIndex = chatIndex
      paidHistory.sceneIndex = sceneIndex
    }
  }
}

