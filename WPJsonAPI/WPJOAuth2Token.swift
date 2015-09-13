//
//  WPJOAuth2Token.swift
//  WordpressJSONApi
//
//  Created by Flo on 10.09.15.
//  Copyright (c) 2015 Florian Wagner. All rights reserved.
//

import Foundation

public class WPJOAuth2Token {
    private static let kTokenKey : String = "kWPJOAuth2TokenKey";
    private static let kTokenExpiryDateKey : String = "kWPJOAuth2TokenExpiryDateKey"
    
    public var token : String;
    private var expiryDate : NSDate;
    
    public init(token : String, expiresIn : Int) {
        self.token = token;
        self.expiryDate = NSDate(timeIntervalSinceNow: Double(expiresIn));
    }
    
    public init(data : NSData) {
        var dict : [String : AnyObject] = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [String : AnyObject];
        self.token = dict[WPJOAuth2Token.kTokenKey] as! String;
        self.expiryDate = dict[WPJOAuth2Token.kTokenExpiryDateKey] as! NSDate;
    }
    
    public func isExpired() -> Bool {
        return NSDate().timeIntervalSinceDate(self.expiryDate) >= 0;
    }
    
    public func encodedData() -> NSData {
        var data = Dictionary<String, AnyObject>();
        data[WPJOAuth2Token.kTokenKey] = self.token;
        data[WPJOAuth2Token.kTokenExpiryDateKey] = self.expiryDate;
        return NSKeyedArchiver.archivedDataWithRootObject(data);
    }
}