//
//  MovingBoxMapPoint.swift
//  Spin the boxes
//
//  Created by Vladislav on 10.10.16.
//  Copyright © 2016 Vladislav. All rights reserved.
//

import Foundation

class MovingBoxMapPoint
{
    public var x:Int;
    public var y:Int;
    
    public var NextPoint:MovingBoxMapPoint?;
    public var LastPoint:MovingBoxMapPoint?;
    
    init(_x:Int,_y:Int,_nextPoint:MovingBoxMapPoint?,_lastPoint:MovingBoxMapPoint?)
    {
        x = _x;
        y = _y;
        NextPoint = _nextPoint;
        LastPoint = _lastPoint;
    }
    
    public func equals(_obj:MovingBoxMapPoint)->Bool
    {
        if((_obj.x == self.x)&&(_obj.y == self.y))
        {
            return true;
        }
        return false;
    }
}
