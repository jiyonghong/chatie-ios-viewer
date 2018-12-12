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
    let remainTap: Int
    
    init(data: JSON) {
        self.isSubscribed = data["isSubscribed"].boolValue
        self.remainTap = data["remainTap"].intValue
    }
}
