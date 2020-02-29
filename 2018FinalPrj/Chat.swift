//
//  Chat.swift
//  Firebase.170501
//
//  Created by gnsJhenJie on 2018/6/8.
//  Copyright © 2018年 gnsJhenJie.me. All rights reserved.
//

import Foundation
class Chat {
    var nickname: String?
    var content: String?
    var datePost: String?
    
    init(nickname: String, content: String, datePost: String) {
        self.nickname = nickname
        self.content = content
        self.datePost = datePost
    }
}
