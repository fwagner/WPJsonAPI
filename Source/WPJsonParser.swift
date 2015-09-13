//
//  WPJsonParser.swift
//  WordpressJSONApi
//
//  Created by Flo on 10.09.15.
//  Copyright (c) 2015 Florian Wagner. All rights reserved.
//

import Foundation
import SwiftyJSON

public class WPJEntity {
    required public init() {
    }
}

public protocol WPJEntityParser {
    typealias EntityType : WPJEntity
    static var parser : WPJsonParser<EntityType> { get };
    static func parse(json : JSON) -> EntityType;
    static func parseList(json: JSON) -> Array<EntityType>;
}

public class WPJsonParser<EntityType : WPJEntity> {
    var mapping : ((entity : EntityType, json : WPJsonParser) -> Void)?;
    private var json : JSON?;
    
    public init() {
        self.mapping = { (entity, parser) in return };
    }
    
    public init(mapping : (entity : EntityType, json : WPJsonParser) -> Void) {
        self.mapping = mapping;
    }
    
    public func entityFromJSON(json : JSON) -> EntityType {
        self.json = json;
        var entity : EntityType = EntityType();
        if self.mapping != nil {
            self.mapping!(entity: entity, json: self);
        }
        return entity;
    }
    
    public func entityListFromJSON(json : JSON) -> Array<EntityType> {
        var list = Array<EntityType>();
        if(json.type == .Array) {
            for (index : String, entityJSON : JSON) in json {
                list.append(self.entityFromJSON(entityJSON));
            }
        }
        return list;
    }
    
    public subscript(index : Int) -> (WPJsonParser<EntityType>, JSON) {
        return (self, self.json![index]);
    }
    
    public subscript(key : String) -> (WPJsonParser<EntityType>, JSON) {
        return (self, self.json![key]);
    }
}

infix operator --> {};
func --><T> (left: (parser: WPJsonParser<T>, json: JSON), inout right: Bool) {
    right = left.json.boolValue;
}

func --><T> (left: (parser: WPJsonParser<T>, json: JSON), inout right: Bool?) {
    right = left.json.bool;
}

func --><T> (left: (parser: WPJsonParser<T>, json: JSON), inout right: Int) {
    right = left.json.intValue;
}

func --><T> (left: (parser: WPJsonParser<T>, json: JSON), inout right: Int?) {
    right = left.json.int;
}

func --><T> (left: (parser: WPJsonParser<T>, json: JSON), inout right: String) {
    right = left.json.stringValue;
}

func --><T> (left: (parser: WPJsonParser<T>, json: JSON), inout right: String?) {
    right = left.json.string;
}

func --><T> (left: (parser: WPJsonParser<T>, json: JSON), inout right: NSURL?) {
    right = NSURL(string: left.json.stringValue);
}




