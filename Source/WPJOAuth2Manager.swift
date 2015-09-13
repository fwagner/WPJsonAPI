//
//  WPJOAuth2Manager.swift
//  WordpressJSONApi
//
//  Created by Flo on 08.09.15.
//  Copyright (c) 2015 Florian Wagner. All rights reserved.
//

import Foundation

public class WPJOAuth2Manager {
    public var configuration : WPJOAuth2Configuration;
    public var tokenStore : WPJOAuth2TokenStore;
    
    public convenience init()
    {
        self.init(configuration: WPJOAuth2Configuration());
    }
    
    public convenience init(configuration : WPJOAuth2Configuration) {
        self.init(configuration: configuration, tokenStore : WPJOAuth2TokenStore());
    }
    
    public init(configuration : WPJOAuth2Configuration, tokenStore : WPJOAuth2TokenStore)
    {
        self.configuration = configuration;
        self.tokenStore = tokenStore;
    }
    
    public func buildAuthenticationURL() -> NSURL
    {
        var authorizationURL : NSURLComponents = NSURLComponents(string: self.configuration.authorizationEndpoint)!;
        authorizationURL.queryItems = [
            NSURLQueryItem(name: "client_id", value: self.configuration.clientId),
            NSURLQueryItem(name: "redirect_uri", value: self.configuration.redirectURL),
            NSURLQueryItem(name: "response_type", value: "token"),
            NSURLQueryItem(name: "scope", value: "global")
        ];
        return authorizationURL.URL!;
    }
    
    public func isAuthenticationRedirect(url : NSURL) -> Bool {
        let urlAsString = url.scheme! + "://" + url.host! + url.path!;
        debugPrintln(urlAsString + " == " + self.configuration.redirectURL);
        return urlAsString == self.configuration.redirectURL;
    }
    
    public func handleRedirectWithToken(url : NSURL) -> WPJOAuth2Token? {
        if let token = self.extractTokenFromFragment(url.fragmentComponents()) {
            self.tokenStore.saveToken(token);
            return token;
        } else {
            return nil;
        }
    }
    
    public func hasSession() -> Bool {
        return self.tokenStore.hasValidToken();
    }
    
    public func getCurrentToken() -> WPJOAuth2Token? {
        return self.tokenStore.retrieveToken();
    }
    
    private func extractTokenFromFragment(fragmentComponents : [String : String]) -> WPJOAuth2Token? {
        if let token = fragmentComponents["access_token"], expiryInterval = fragmentComponents["expires_in"]?.toInt() {
            return WPJOAuth2Token(token: token.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!, expiresIn: expiryInterval);
        }
        return nil;
    }
    
}

