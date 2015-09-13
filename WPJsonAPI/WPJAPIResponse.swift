//
//  WPJAPIResponse.swift
//  WordpressJSONApi
//
//  Created by Flo on 13.09.15.
//  Copyright (c) 2015 Florian Wagner. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct APIError {
    var httpCode : Int;
    var error : NSError?;
}

public class WPJAPIResponse<EntityType : WPJEntity> {
    let httpRequest : WPJHttpRequest;
    let parser : (json : JSON) -> Array<EntityType>;
    
    init(httpRequest : WPJHttpRequest, parser: (json : JSON) -> Array<EntityType>) {
        self.httpRequest = httpRequest;
        self.parser = parser;
    }
    
    public func onSuccess(handler : (first : EntityType) -> Void) -> WPJAPIResponse {
        httpRequest.onSuccess { (json : JSON) -> Void in
            var result = self.parser(json: json);
            handler(first: result[0]);
        }
        return self;
    }
    
    public func onSuccess(handler : (list : Array<EntityType>) -> Void ) -> WPJAPIResponse {
        httpRequest.onSuccess { (json : JSON) -> Void in
            handler(list: self.parser(json: json));
        }
        return self;
    }
    
    public func onError(handler : (error : APIError) -> Void) -> WPJAPIResponse {
        httpRequest.onError { (httpStatus, error) -> Void in
            handler(error: APIError(httpCode: httpStatus, error: error));
        }
        return self;
    }
    
}