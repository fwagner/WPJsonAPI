//
//  NSURL+QueryParser.swift
//  WordpressJSONApi
//
//  Created by Flo on 10.09.15.
//  Copyright (c) 2015 Florian Wagner. All rights reserved.
//

import Foundation

extension NSURL {
    public func fragmentComponents() -> [String : String] {
        var fragmentDict = Dictionary<String, String>();
        if(self.fragment != nil) {
            let fragmentComponents = self.fragment!.componentsSeparatedByString("&");
            for fragmentComponent in fragmentComponents {
                let keyValueComponents = fragmentComponent.componentsSeparatedByString("=");
                if(keyValueComponents.count >= 2) {
                    fragmentDict[keyValueComponents[0]] = keyValueComponents[1];
                }
            }
        }
        return fragmentDict;
    }
}