//
//  WPJOAuth2Configuration.swift
//  WordpressJSONApi
//
//  Created by Flo on 08.09.15.
//  Copyright (c) 2015 Florian Wagner. All rights reserved.
//

import Foundation

public class WPJOAuth2Configuration {
    public var clientId : String = "";
    public var clientSecret: String = "";
    public var authorizationEndpoint: String = "https://public-api.wordpress.com/oauth2/authorize";
    public var tokenEndpoint: String = "https://public-api.wordpress.com/oauth2/token";
    public var redirectURL: String = "";

    public init() {}
    
}