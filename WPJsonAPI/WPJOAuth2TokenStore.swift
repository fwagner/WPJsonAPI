//
//  WPJOAuth2TokenStore.swift
//  WordpressJSONApi
//
//  Created by Flo on 10.09.15.
//  Copyright (c) 2015 Florian Wagner. All rights reserved.
//

import Foundation
import SimpleKeychain

public class WPJOAuth2TokenStore {
    private static let kTokenKey : String = "kWPJOAuth2TokenStoreTokenKey";
    private var keychain : A0SimpleKeychain;
    
    convenience public init() {
        self.init(group: nil);
    }
    
    convenience public init(group : String?) {
        let service = NSBundle.mainBundle().bundleIdentifier;
        self.init(group: group, service: service!);
    }
    
    public init(group: String?, service : String) {
        if(group != nil) {
            self.keychain = A0SimpleKeychain(service: service, accessGroup: group);
        } else {
            self.keychain = A0SimpleKeychain(service: service);
        }
    }
    
    public func hasValidToken() -> Bool {
        if let token = self.retrieveToken() {
            return !token.isExpired();
        }
        return false;
    }
    
    public func saveToken(token : WPJOAuth2Token) {
        self.keychain.setData(token.encodedData(), forKey: WPJOAuth2TokenStore.kTokenKey);
    }
    
    public func retrieveToken() -> WPJOAuth2Token? {
        if let data : NSData = self.keychain.dataForKey(WPJOAuth2TokenStore.kTokenKey) {
            return WPJOAuth2Token(data: data);
        } else {
            return nil;
        }
        
    }
}