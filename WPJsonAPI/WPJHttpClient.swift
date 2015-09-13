//
//  WPJHttpClient.swift
//  WordpressJSONApi
//
//  Created by Flo on 12.09.15.
//  Copyright (c) 2015 Florian Wagner. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public class WPJHttpClient {
    private var oAuthManager : WPJOAuth2Manager;
    
    public required init(oAuthManager : WPJOAuth2Manager) {
        self.oAuthManager = oAuthManager;
    }
    
    
    internal func getRequestWithJsonResult(url : String, parameters : [String : AnyObject]? = nil) -> WPJHttpRequest {
        let headers = ["Authorization": "Bearer " + self.oAuthManager.getCurrentToken()!.token];
        var request = WPJHttpRequest(request: Alamofire.request(.GET, url, parameters: parameters, headers: headers));
        return request.executeRequest();
    }
}