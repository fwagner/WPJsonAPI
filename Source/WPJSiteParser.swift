//
//  WPJSiteParser.swift
//  WordpressJSONApi
//
//  Created by Flo on 11.09.15.
//  Copyright (c) 2015 Florian Wagner. All rights reserved.
//

import Foundation
import SwiftyJSON

public class WPJSiteParser : WPJEntityParser {
    public static let parser = WPJsonParser<WPJSite> { (entity, json) -> Void in
        json["ID"] --> entity.id;
        json["name"] --> entity.name;
        json["url"] --> entity.url;
        json["jetpack"] --> entity.jetpack;
        json["logo"] --> entity.logoUrl;
        //public var capabilites : WPJSiteCapabilites = WPJSiteCapabilites();
    };
    
    public static func parse(json: JSON) -> WPJSite {
        return parser.entityFromJSON(json);
    }
    
    public static func parseList(json: JSON) -> Array<WPJSite> {
        return parser.entityListFromJSON(json);
    }
}