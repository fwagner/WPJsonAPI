//
//  WPJUser.swift
//  WordpressJSONApi
//
//  Created by Flo on 10.09.15.
//  Copyright (c) 2015 Florian Wagner. All rights reserved.
//

import Foundation
import UIKit

public class WPJUser : WPJEntity {
    public var id : Int?;
    public var displayName : String?;
    public var username : String?;
    public var email : String?;
    public var avatar : UIImage?;
    public var avatarURL : NSURL?;
    public var siteCount : Int = 0;
    public var accountVerified : Bool = false;
    public var emailVerified : Bool = false;
    public var logoutUrl : String?;
    
    public var sites : [AnyObject]?;
    
    public required init() {
        super.init();
        // do nothing
    }
}