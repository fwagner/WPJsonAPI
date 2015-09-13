//
//  WPJHttpRequest.swift
//  WordpressJSONApi
//
//  Created by Flo on 12.09.15.
//  Copyright (c) 2015 Florian Wagner. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public class WPJHttpRequest {
    internal struct RequestResult {
        var request : NSURLRequest;
        var response : NSHTTPURLResponse;
        var data : JSON?;
        var error : NSError?;
    }
    
    var httpRequest : Request
    var successHandlers : [(JSON) -> Void] = Array<(JSON) -> Void>();
    var errorHandlers : [(Int, NSError) -> Void] = Array<(Int, NSError) -> Void>();
    var result : RequestResult?;
    
    internal init(request : Request) {
        self.httpRequest = request;
    }
    
    internal func executeRequest() -> WPJHttpRequest {
        self.httpRequest.responseJSON(options: NSJSONReadingOptions.AllowFragments) { (request, response, data : AnyObject?, error : NSError?) -> Void in
            var json : JSON?;
            if(data != nil) {
                json = JSON(data!);
            }
            self.result = RequestResult(request: request, response: response!, data: json, error: error);
            self.executeHandlers();
        }
        self.httpRequest.responseString(encoding: NSUTF8StringEncoding) { (_, _, value: String?, _) -> Void in
            debugPrintln(value);
        }
        return self;
    }
    
    public func onSuccess(handler : (json : JSON) -> Void) -> WPJHttpRequest {
        if(self.responseReceived()) {
            if let json = self.result!.data {
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)) {
                    handler(json: json);
                }
            }
        } else {
            self.successHandlers.append(handler);
        }
        return self;
    }
    
    public func onError(handler : (httpStatus : Int, error : NSError) -> Void) -> WPJHttpRequest {
        if(self.responseReceived()) {
            if let error = self.result!.error {
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)) {
                    var status = self.result!.response.statusCode;
                    handler(httpStatus: status, error : error);
                }
            }
        } else {
            self.errorHandlers.append(handler);
        }
        return self;
    }
    
    private func responseReceived() -> Bool {
        return self.result != nil;
    }
    
    private func executeHandlers() {
        if let requestResult = self.result {
            if let json = self.result!.data {
                for successHandler in self.successHandlers {
                    dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)) {
                        successHandler(json);
                    }
                }
            }
            if let error = self.result!.error {
                for errorHandler in self.errorHandlers {
                    dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)) {
                        var status = self.result!.response.statusCode;
                        errorHandler(status, error);
                    }
                }
            }
        }
    }
}