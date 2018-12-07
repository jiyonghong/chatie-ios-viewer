//
//  UserStatus.swift
//  ChatieViewerTest
//
//  Created by redice on 07/12/2018.
//  Copyright © 2018 Jiyong Hong. All rights reserved.
//

import SwiftyJSON

struct UserStatus {
    let isSubscribed: Bool
    let lastSceneIndex: Int
    let lastChatIndex: Int
    let remainTap: Int
    
    init(data: JSON) {
        self.isSubscribed = data["isSubscribed"].boolValue
        self.lastSceneIndex = data["lastSceneIndex"].intValue
        self.lastChatIndex = data["lastChatIndex"].intValue
        self.remainTap = data["remainTap"].intValue
    }
}
