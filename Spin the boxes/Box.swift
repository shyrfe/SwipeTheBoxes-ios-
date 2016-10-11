//
//  Box.swift
//  Spin the boxes
//
//  Created by Vladislav on 10.10.16.
//  Copyright © 2016 Vladislav. All rights reserved.
//

import Foundation

class Box
{
    private var mY:Int;
    private var mX:NSInteger;
    private var mWidth:NSInteger;
    private var mHeight:NSInteger;
    private var mColor:NSInteger;
    private var mNumber:NSInteger;
    
    public var Force = 0;
    
    init(_x:NSInteger, _y:NSInteger, _width:NSInteger, _height:NSInteger, _color:NSInteger, _number:NSInteger)
    {
        mX = _x;
        mY = _y;
        mWidth = _width;
        mHeight = _height;
        mColor = _color;
        mNumber = _number;
        
    }
    convenience init(_x:NSInteger, _y:NSInteger, _width:NSInteger, _height:NSInteger, _color:NSInteger)
    {
        self.init(_x: _x,_y: _y,_width: _width,_height: _height,_color: _color,_number: 0);
    }
    convenience init(_x:NSInteger, _y:NSInteger, _width:NSInteger, _height:NSInteger)
    {
        self.init(_x:_x,_y:_y,_width:_width,_height:_height,_color: 0,_number: 0);
    }
    convenience init(_x:NSInteger, _y:NSInteger)
    {
        self.init(_x:_x,_y:_y,_width:0,_height:0,_color: 0,_number: 0)
    }
    convenience init()
    {
        self.init(_x:0,_y:0,_width:0,_height:0,_color: 0,_number: 0)
    }
    
    func setX(_x:Int)
    {
        mX = _x;
    }
    func setY(_y:Int)
    {
        mY = _y;
    }
    func setWidth(_width:Int)
    {
        mWidth = _width;
    }
    func setHeight(_height:Int)
    {
        mHeight=_height;
    }
    func setColor(_color:Int)
    {
        mColor = _color;
    }
    func setNumber(_number:Int)
    {
        mNumber = _number;
    }
    
    func getX()->Int
    {
        return mX;
    }
    func getY()->Int
    {
        return mY;
    }
    func getWidth()->Int
    {
        return mWidth;
    }
    func getHeight()->Int
    {
        return mHeight;
    }
    func getColor()->Int
    {
        return mColor;
    }
    func getNumber()->Int
    {
        return mNumber;
    }
    
    func equals (_obj:Box) ->Bool
    {
        if ((mX != _obj.getX()) || (mY != _obj.getY()))
        {
            return false;
        }
        
        if ((mWidth != _obj.getWidth()) || (mHeight != _obj.getHeight()))
        {
            return false;
        }
        
        if (mColor != _obj.getColor())
        {
            return false;
        }
        
        if (mNumber != _obj.getNumber())
        {
            return false;
        }
        return true;
    }
}
