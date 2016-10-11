//
//  MovingBox.swift
//  Spin the boxes
//
//  Created by Vladislav on 10.10.16.
//  Copyright © 2016 Vladislav. All rights reserved.
//

import Foundation

class MovingBox
{
    public var NextBox:MovingBox?;
    public var LastBox:MovingBox?;
    
    public var LastXReferenceCoord:Int?;
    public var LastYReferenceCoord:Int?;
    
    //public var NextXReferenceCoord:Int;
    //public var NextYReferenceCoord:Int;
    
    public var ThisPoint:MovingBoxMapPoint?;
    public var NextPoint:MovingBoxMapPoint?;
    
    public var LocalBox:Box;
    
    init(_box:Box)
    {
        LocalBox = _box;
    }
    
    init(_box:Box, _lastXRefCoord:Int, _lastYRefCoord:Int)
    {
        LocalBox = _box;
        LastXReferenceCoord = _lastXRefCoord;
        LastYReferenceCoord = _lastYRefCoord;
    }
    
    init(_box:Box, _lastXRefCoord:Int, _lastYRefCoord:Int,_lastBox:MovingBox,_nextBox:MovingBox)
    {
        LocalBox = _box;
        
        LastXReferenceCoord = _lastXRefCoord;
        LastYReferenceCoord = _lastYRefCoord;
        
        NextBox = _nextBox;
        LastBox = _lastBox;
    }
    
    public func setX(_x:Int)
    {
        LocalBox.setX(_x:_x);
    }
    public func setY(_y:Int)
    {
        LocalBox.setY(_y: _y);
    }
    
    public func getX() ->Int
    {
        return LocalBox.getX();
    }
    public func getY() ->Int
    {
        return LocalBox.getY();
    }
    
}
