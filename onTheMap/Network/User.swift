//
//  User.swift
//  onTheMap
//
//  Created by Huda  on 02/04/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

import Foundation

struct User: Codable {
    let name: String?

}

struct StudentUser: Codable {
    let user: User?
}


struct Session: Codable {
    let id: String?
    let expiration: String?
}


struct UserSession: Codable {
    let account: Account?
    let session: Session?
}


struct Account: Codable {
    let registered: Bool?
    let key: String?
}
