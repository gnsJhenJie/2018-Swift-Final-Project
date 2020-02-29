//
//  SignUp.swift
//  2018FinalPrj
//
//  Created by gnsJhenJie on 2018/6/22.
//  Copyright © 2018年 gnsJhenJie.me. All rights reserved.
//

import Foundation
class SignUp {
    var email: String?
    var nickname: String?
    var dateCreate: String?
    
    init(email: String, nickname: String, dateCreate: String) {
        self.email = email
        self.nickname = nickname
        self.dateCreate = dateCreate
    }
}
