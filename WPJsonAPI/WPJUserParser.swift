//
//  WPJUserParser.swift
//  WordpressJSONApi
//
//  Created by Flo on 10.09.15.
//  Copyright (c) 2015 Florian Wagner. All rights reserved.
//

import Foundation
import SwiftyJSON

class WPJUserParser : WPJEntityParser {
    static let parser = WPJsonParser<WPJUser>(mapping: { (entity, json) -> Void in
        json["ID"] --> entity.id;
        json["displayName"] --> entity.displayName;
        json["username"] --> entity.username;
        json["email"] --> entity.email;
        json["avatar_url"] --> entity.avatarURL;
        json["email_verified"] --> entity.emailVerified;
        json["accountVerified"] --> entity.accountVerified;
        json["site_count"] --> entity.siteCount;
        json["logout_url"] --> entity.logoutUrl;
    });
    
    class func parse(json : JSON) -> WPJUser {
        return parser.entityFromJSON(json);
    }
    
    class func parseList(json: JSON) -> Array<WPJUser> {
        return parser.entityListFromJSON(json);
    }
    
}