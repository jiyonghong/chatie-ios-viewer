//
//  ReadHistory.swift
//  ChatiePlus
//
//  Created by SeungHyeon Wang on 2018. 12. 5..
//  Copyright © 2018년 Eineblume. All rights reserved.
//

import Realm
import RealmSwift
import RxSwift

// 읽은 작품 히스토리
class ReadHistory: Object {
  @objc dynamic var storyID: Int = 0
  @objc dynamic var lastEpisodeID: Int = 0
  @objc dynamic var lastEpisodeTitle: String = ""
  @objc dynamic var lastEpisodeChatIndex: Int = 0
  @objc dynamic var lastEpisodeSceneIndex: Int = 0
  var episodeIds = List<Int>()

  convenience init(storyID: Int,
                   episode: Episode,
                   sceneIndex: Int,
                   chatIndex: Int) {
    self.init()
    self.storyID = storyID
    self.lastEpisodeID = episode.id
    self.lastEpisodeTitle = episode.title
    self.lastEpisodeChatIndex = chatIndex
    self.lastEpisodeSceneIndex = sceneIndex
    self.episodeIds.append(episode.id)
  }

  class func save(storyID: Int,
                  episode: Episode,
                  sceneIndex: Int,
                  chatIndex: Int) {
    let realm = try! Realm()
    let historyObject = realm.objects(ReadHistory.self)
      .filter { $0.storyID == storyID }

    if historyObject.isEmpty {
      try! realm.write {
        let readHistory = ReadHistory(
          storyID: storyID,
          episode: episode,
          sceneIndex: sceneIndex,
          chatIndex: chatIndex
        )
        realm.add(readHistory)
      }
      return
    }

    guard let history = historyObject.first else { return }
    try! realm.write {
      if !history.episodeIds.contains(episode.id) {
        history.episodeIds.append(episode.id)
      }
      history.lastEpisodeID = episode.id
      history.lastEpisodeTitle = episode.title
      history.lastEpisodeSceneIndex = sceneIndex
      history.lastEpisodeChatIndex = chatIndex
    }
  }

  class func currentEpisode(storyId: Int) -> LastEpisode? {
    let realm = try! Realm()
    let filteredHistory = realm.objects(ReadHistory.self)
      .filter { $0.storyID == storyId }

    guard let currentHistory = filteredHistory.first else {
      return nil
    }

    return LastEpisode(id: currentHistory.lastEpisodeID,
                       title: currentHistory.lastEpisodeTitle,
                       sceneIndex: currentHistory.lastEpisodeSceneIndex,
                       chatIndex: currentHistory.lastEpisodeChatIndex)
  }
}
