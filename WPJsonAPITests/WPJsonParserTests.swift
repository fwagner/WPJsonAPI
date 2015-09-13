//
//  WPJsonParserTests.swift
//  WordpressJSONApi
//
//  Created by Flo on 11.09.15.
//  Copyright (c) 2015 Florian Wagner. All rights reserved.
//

import Foundation
import XCTest
import SwiftyJSON

class WPJUserJsonParserTest : XCTestCase {
    static let jsonInput : String = "{\"ID\": 99119911,\"display_name\": \"jondoe123\",\"username\": \"jondoe 123\",\"email\": \"jondoe@example.net\",\"primary_blog\": 22332233,\"language\": \"en\",\"token_site_id\": false,\"token_scope\": [\"global\"],\"avatar_URL\": \"https://2.gravatar.com/avatar/abcdefghiksdkfsdf?s=96&d=identicon\",\"profile_URL\": \"http://en.gravatar.com/jondoe\",\"verified\": true,\"email_verified\": true,\"date\": \"2011-04-20T13:34:00+00:00\",\"site_count\": 2,\"visible_site_count\": 2,\"has_unseen_notes\": false,\"newest_note_type\": \"\",\"phone_account\": false,\"meta\": {\"links\": {\"self\": \"https://public-api.wordpress.com/rest/v1.1/me\",\"help\": \"https://public-api.wordpress.com/rest/v1.1/me/help\",\"site\": \"https://public-api.wordpress.com/rest/v1.1/sites/1122110\",\"flags\": \"https://public-api.wordpress.com/rest/v1.1/me/flags\"}},\"is_valid_google_apps_country\": true,\"logout_URL\": \"https://wordpress.com/wp-login.php?action=logout&_wpnonce=abcdefghij&redirect_to=https%3A%2F%2F.wordpress.com\",\"_headers\": {\"Date\": \"Thu, 10 Sep 2015 10:49:35 GMT\",\"Content-Type\": \"application/json\"}}";
    
    func testParsing() {
        if let data = WPJUserJsonParserTest.jsonInput.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true) {
            let json = JSON(data: data);
            let user = WPJUserParser.parse(json);
            XCTAssertEqual(user.id!, 99119911);
            XCTAssertEqual(user.username!, "jondoe 123");
        }
        
    }
}