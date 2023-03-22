//
//  MUsers.swift
//  Boardnote
//
//  Created by Julapong on 3/6/18.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//
import Foundation
import UIKit
import JWTDecode

class MUser: CTModel {
    var userId: String?
    var token: String?
    var email: String?
    var nicename: String?
    var displayName: String?
    var avatar: String?
    var checkedIn: Bool?
    
    override var debugDescription: String {
        return "id: \(id ?? "")\ndisplayName - \(displayName ?? "")\nroles: \(roles ?? [])\nemail: \(email ?? "")\navatar: \(avatar ?? "")"
    }
    
    lazy var allowCheckin: Bool = { [weak self] in
        var result: Bool = true
        guard let roles = self?.roles else { return result }
        roles.forEach({ (role) in
            if role == "administrator" || role == "editor" {
                result = false
            }
        })
        return result
    }()
    
    
    // JWTDecode token
    lazy var id: String? = { [weak self] in
        if let token = self?.token {
            let jwt = try? JWTDecode.decode(jwt: token)
            if let body = jwt?.body,
                let data = body["data"] as? [String:Any],
                let usr = data["user"] as? [String:Any] {
                return usr["id"] as? String
            }
        }
        return nil
    }()
    lazy var roles: [String]? = { [weak self] in
        if let token = self?.token {
            let jwt = try? JWTDecode.decode(jwt: token)
            if let body = jwt?.body,
                let data = body["data"] as? [String:Any],
                let usr = data["user"] as? [String:Any] {
                return usr["roles"] as? [String]
            }
        }
        return nil
    }()

    // MARK: - Mapping
    open override func mapping(map: Map) {
        userId      <- map["user_id"]
        token       <- map["token"]
        email       <- map["user_email"]
        nicename    <- map["user_nicename"]
        displayName <- map["user_display_name"]
        avatar      <- map["user_avatar"]
        displayName <- map["display_name"]
        nicename    <- map["nicename"]
        checkedIn   <- map["checked_in"]
    }
}
