//
//  WPJSite.swift
//  WordpressJSONApi
//
//  Created by Flo on 10.09.15.
//  Copyright (c) 2015 Florian Wagner. All rights reserved.
//

import Foundation
import UIKit

public class WPJSite : WPJEntity {
    public var id : Int?;
    public var name : String?;
    public var url : NSURL?;
    public var jetpack : Bool = false;
    public var logo : UIImage?;
    public var logoUrl : NSURL?;
    public var capabilites : WPJSiteCapabilites = WPJSiteCapabilites();
}

public enum WPJSiteCapability {
    case EditPages, EditPosts, EditOtherPosts, EditOtherPages, EditThemeOptions, EditUsers, ListUsers, ManageOptions, PromoteUsers, PublishPosts, UploadFiles, ViewStats;
}

public struct WPJSiteCapabilites {
    private var capabilities : Set<WPJSiteCapability> = Set();
    
    public mutating func addCapability(capability : WPJSiteCapability) {
        self.capabilities.insert(capability);
    }
    
    public mutating func removeCapability(capability : WPJSiteCapability) {
        self.capabilities.remove(capability);
    }
    
    public func hasCapability(capability : WPJSiteCapability) -> Bool {
        return self.capabilities.contains(capability);
    }
    
}
