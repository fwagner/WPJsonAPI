//
//  WPJWordpressAPI.swift
//  WordpressJSONApi
//
//  Created by Flo on 11.09.15.
//  Copyright (c) 2015 Florian Wagner. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

public class WPJWordpressAPI {
    private let WP_URL_CURRENT_USER = "https://public-api.wordpress.com/rest/v1.1/me";
    private let WP_URL_SITES = "https://public-api.wordpress.com/rest/v1.1/me/sites";
    
    private let httpClient : WPJHttpClient;
    
    public init(oAuthManager : WPJOAuth2Manager)
    {
        self.httpClient = WPJHttpClient(oAuthManager: oAuthManager);
    }
    
    public func getCurrentUser() -> WPJAPIResponse<WPJUser> {
        return WPJAPIResponse<WPJUser>(httpRequest: self.httpClient.getRequestWithJsonResult(WP_URL_CURRENT_USER), parser: { (json) -> Array<WPJUser> in
            return [WPJUserParser.parse(json)];
        });
    }
    
    public func getSitesForCurrentUser() -> WPJAPIResponse<WPJSite>
    {
        return WPJAPIResponse<WPJSite>(httpRequest: self.httpClient.getRequestWithJsonResult(WP_URL_SITES), parser: { (json) -> Array<WPJSite> in
            return WPJSiteParser.parseList(json);
        })
    }

}
