//
//  BoxController.swift
//  Spin the boxes
//
//  Created by Vladislav on 12.10.16.
//  Copyright © 2016 Vladislav. All rights reserved.
//

import Foundation
import UIKit

class BoxController
{
    public static let INPUT_TYPE_LONGPRESS_START = "LongPressStart";
    public static let INPUT_TYPE_LONGPRESS_END = "LongPressEnd";
    public static let INPUT_TYPE_TAP = "Tap";
    //public static let INPUT_TYPE_SWIPE = "Swipe";
    public static let INPUT_TYPE_PAN = "Pan";
    public static let INPUT_TYPE_TOUCH_BEGAN = "TouchBegan";
    public static let INPUT_TYPE_TOUCH_ENDED = "TouchEnded";
    public static let INPUT_TYPE_TOUCH_MOVED = "TouchMoved";
    
    public var BoxPool = [Box]();
    public var MovingBoxPool = [MovingBox]();
    
    private var mLastTime = Date().timeIntervalSince1970;
    private var mForce = 0;
    private var mForceFinished = true;
    private var mScrollRun = false;
    private var mForceStep = 0;
    private var mForceStepNumber = 0;
    private var mForceNumberOfSteps = 20;
    
    private var mScreenWidth:Int?;
    private var mScreenHeight:Int?;
    private let BOX_WIDTH_NUMBER = 3;
    private let BOX_HEIGHT_NUMBER = 3;
    
    private var mMinX:Int?;
    private var mMaxX:Int?;
    private var mMinY:Int?;
    private var mMaxY:Int?;
    
    private var mBoxXDistance:Int?;
    private var mBoxYDistance:Int?;
    
    private var mFirstTouchPositionX = 0;
    private var mFirstTouchPositionY = 0;
    
    private var mLongPressNumber:Int?;
    
    let mDrawBoxView:DrawBoxView;
    
    
    init(_drawBoxView:DrawBoxView)
    {
        
        mDrawBoxView = _drawBoxView;

        let thread = Thread(target: self, selector: #selector(boxsInit), object: nil);
        thread.start();
    }
    
    @objc func boxsInit()
    {
        while(true)
        {
            if (mDrawBoxView.ScreenWidth != nil && mDrawBoxView.ScreenHeight != nil)
            {
                mScreenWidth = mDrawBoxView.ScreenWidth;
                mScreenHeight = mDrawBoxView.ScreenHeight;
                break;
            }
        }
        mDrawBoxView.LocalBoxController = self;
        
        let PADDING = 4;
        let padding_step_w = PADDING;
        let padding_step_h = PADDING;
        let TOTAL_PADDING_WIDTH = PADDING * (BOX_WIDTH_NUMBER + 1);
        let TOTAL_PADDING_HEIGHT = PADDING * (BOX_HEIGHT_NUMBER + 1);
        
        var mReferenceCoord:[Int]?;
        
        let first_width_margin = ((mScreenWidth! - abs((mScreenWidth! - TOTAL_PADDING_WIDTH) / BOX_WIDTH_NUMBER)*BOX_WIDTH_NUMBER))/2;
        let boxsSpaceWidth = (mScreenWidth! - (first_width_margin*2) - TOTAL_PADDING_WIDTH);
        
        let first_height_margin = (mScreenHeight! - boxsSpaceWidth)/2;
        let boxsSpaceHeight = (mScreenHeight! - (first_height_margin * 2) - TOTAL_PADDING_HEIGHT);
        
        let box_width = abs(boxsSpaceWidth/BOX_WIDTH_NUMBER);
        let box_height = abs(boxsSpaceHeight / BOX_HEIGHT_NUMBER);
        
        var box_numbers: [Int] = [1,2,3,8,-1,4,7,6,5];
        var box_number = 0;
        
        for i in 0...BOX_HEIGHT_NUMBER - 1
        {
            for j in 0...BOX_WIDTH_NUMBER - 1
            {
                if (i == 0 && j == 0)
                {
                    mMinX = j * (box_width + padding_step_w) + (padding_step_w + first_width_margin);
                    mMinY = i * (box_height + padding_step_h) + (padding_step_h + first_height_margin);
                }
                if(i == BOX_HEIGHT_NUMBER - 1 && j == BOX_WIDTH_NUMBER - 1)
                {
                    mMaxX = j * (box_width + padding_step_w) + (padding_step_w + first_width_margin);
                    mMaxY = i * (box_height + padding_step_h) + (padding_step_h + first_height_margin)
                }
                if (i == 1 && j == 1)
                {
                    BoxPool.append(Box.init(_x: j * (box_width + padding_step_w) + (padding_step_w + first_width_margin), _y: i*(box_height + padding_step_h) + (padding_step_h + first_height_margin), _width: box_width, _height: box_height, _color: UIColor.red, _number: box_numbers[box_number]));
                    box_number += 1;
                }
                else
                {
                    BoxPool.append(Box.init(_x: j * (box_width + padding_step_w) + (padding_step_w + first_width_margin), _y: i*(box_height + padding_step_h) + (padding_step_h + first_height_margin), _width: box_width, _height: box_height, _color: mDrawBoxView.hexToUIColor(inputHex: "#BDE0EB"), _number: box_numbers[box_number]));
                    box_number += 1;
                }
                mReferenceCoord?[((i*BOX_HEIGHT_NUMBER + j)*2)] = j*(box_width+padding_step_w) + (padding_step_w + first_width_margin);
                mReferenceCoord?[((i*BOX_HEIGHT_NUMBER + j)*2) + 1] = i*(box_height+padding_step_h) + (padding_step_h+first_height_margin);
            }
        }
        movingBoxPoolInit(_boxPool: BoxPool);
        //poolChanged();
    }
    func movingBoxPoolInit(_boxPool:[Box])
    {
        for i in 0 ... _boxPool.count - 1
        {
            if (i == 0)
            {
                MovingBoxPool.append( MovingBox.init(_box: _boxPool[i],
                                                      _lastXRefCoord: _boxPool[i].getX(),
                                                      _lastYRefCoord: _boxPool[i].getY()));
            }
            else if (i == (_boxPool.count - 1))
            {
                MovingBoxPool.append( MovingBox.init(_box: _boxPool[i],
                                                      _lastXRefCoord: _boxPool[i].getX(),
                                                      _lastYRefCoord: _boxPool[i].getY(),
                                                      _lastBox: (MovingBoxPool[i-1]),
                                                      _nextBox: (MovingBoxPool[0])));
                MovingBoxPool[0].LastBox = MovingBoxPool[i];
            }
            else
            {
                MovingBoxPool.append( MovingBox.init(_box: _boxPool[i],
                                                      _lastXRefCoord: _boxPool[i].getX(),
                                                      _lastYRefCoord: _boxPool[i].getY()));
                MovingBoxPool[i].LastBox = MovingBoxPool[i-1];
                MovingBoxPool[i-1].NextBox = MovingBoxPool[i];
            }
        }
        MovingBoxPool[3].NextBox = MovingBoxPool[0];
        MovingBoxPool[0].LastBox = MovingBoxPool[3];
        
        MovingBoxPool[6].NextBox = MovingBoxPool[3];
        MovingBoxPool[3].LastBox = MovingBoxPool[6];
        
        MovingBoxPool[7].NextBox = MovingBoxPool[6];
        MovingBoxPool[6].LastBox = MovingBoxPool[7];
        
        MovingBoxPool[8].NextBox = MovingBoxPool[7];
        MovingBoxPool[7].LastBox = MovingBoxPool[8];
        
        MovingBoxPool[5].NextBox = MovingBoxPool[8];
        MovingBoxPool[8].LastBox = MovingBoxPool[5];
        
        MovingBoxPool[2].NextBox = MovingBoxPool[5];
        MovingBoxPool[5].LastBox = MovingBoxPool[2];
        
        for i in 0...(MovingBoxPool.count) - 1
        {
            MovingBoxPool[i].ThisPoint = MovingBoxMapPoint.init(_x: MovingBoxPool[i].getX(), _y: MovingBoxPool[i].getY(), _nextPoint: nil, _lastPoint: nil)
        }
        
        for i in 0...(MovingBoxPool.count) - 1
        {
            MovingBoxPool[i].ThisPoint?.LastPoint = MovingBoxPool[i].LastBox?.ThisPoint;
            MovingBoxPool[i].ThisPoint?.NextPoint = MovingBoxPool[i].NextBox?.ThisPoint;
            MovingBoxPool[i].NextPoint = MovingBoxPool[i].NextBox?.ThisPoint;
        }
        
        mBoxXDistance = (MovingBoxPool[0].NextBox?.getX())! - (MovingBoxPool[0].getX());
        mBoxYDistance = (MovingBoxPool[0].LastBox?.getY())! - (MovingBoxPool[0].getY());
    }
    
    func input(_value:String,_recognizer:UIGestureRecognizer?)
    {
        switch _value {
        case "LongPressStart":
            print("LongPressStart");
            longPressStartInput(_recognizer: _recognizer as! UILongPressGestureRecognizer);
            //print("X: " + String.init(describing: _recognizer.location(in: _recognizer.view).x));
            break;
        case "LongPressEnd":
            longPressEndInput(_recognizer: _recognizer as! UILongPressGestureRecognizer);
            //print("LongPressEnd")
            break;
        case "Tap":
            //print("Tap")
            tapInput(_recognizer: _recognizer as! UITapGestureRecognizer)
            break;
        //case "Swipe":
            //print("Swipe")
            //break;
        case "Pan":
            panInput(_recognizer: _recognizer as! UIPanGestureRecognizer);
            break;
        case "TouchBegan":
            //print("TouchBegan");
            mForce = 0;
            mForceFinished = true;
            mScrollRun = true;
            break;
        case "TouchEnded":
            //print("TouchEnded");
            mScrollRun = false;
            break;
        case "TouchMoved":
            break;
        default:
            break;
        }
    }
    private func longPressStartInput(_recognizer:UILongPressGestureRecognizer)
    {
        var localBox:Box?;
        localBox = findBox(_x: Int(_recognizer.location(in: _recognizer.view).x), _y: Int(_recognizer.location(in: _recognizer.view).y));
        if (localBox != nil)
        {
            mLongPressNumber = localBox?.getNumber();
            print("LongPress Start #" + String.init(describing: localBox!.getNumber()));
        }
        else
        {
            print("Box not found");
        }
        
    }
    private func longPressEndInput(_recognizer:UILongPressGestureRecognizer)
    {
        if(mLongPressNumber != nil)
        {
            print("LongPress End #" + String(mLongPressNumber!));
            mLongPressNumber = nil;
        }
    }
    private func panInput(_recognizer:UIPanGestureRecognizer)
    {
        let SWIPE_THRESHOLD = 50;
        let panVelocity = _recognizer.velocity(in: _recognizer.view);
        
        var displayScale = 1;
        if ((UIScreen.main.scale == 2.0)&&(UIScreen.main.responds(to: #selector(NSDecimalNumberBehaviors.scale))))
        {
            displayScale = 2;
        }
        else
        {
            displayScale = 1;
        }
        
        //print("VelX: " + String.init(describing: panVelocity.x));
        //print("VelY: " + String.init(describing: panVelocity.y));
        
        let X = Int(floor(_recognizer.location(in: _recognizer.view).x));// * displayScale;
        let Y = Int(floor(_recognizer.location(in: _recognizer.view).y));// * displayScale;
        
        let forceX = Int(panVelocity.x) / 10;
        let forceY = Int(panVelocity.y) / 10;
        
        
        if ((abs(panVelocity.x) > 1200)||(abs(panVelocity.y) > 1200)) // swipe
        {
            if(abs(Int(_recognizer.translation(in: _recognizer.view).x)) > SWIPE_THRESHOLD)
            {
                if (Y * displayScale > mScreenHeight! / 2)
                {
                    MoveWithForce(_force: (forceX * -1));
                }
                else
                {
                    MoveWithForce(_force: forceX);
                }
                
            }
            else if (abs(Int(_recognizer.translation(in: _recognizer.view).y)) > SWIPE_THRESHOLD)
            {
                if (X * displayScale > mScreenWidth! / 2)
                {
                    MoveWithForce(_force: forceY);
                }
                else
                {
                    MoveWithForce(_force: (forceY * -1));
                }
                
            }
        }
        else //scroll
        {
            var distanceX = 0;//Int(floor(_recognizer.translation(in: _recognizer.view).x)) / displayScale;
            var distanceY = 0;//Int(floor(_recognizer.translation(in: _recognizer.view).y)) / displayScale;
            if (_recognizer.state == .began)
            {
                mFirstTouchPositionX = X * displayScale;
                mFirstTouchPositionY = Y * displayScale;
                //distanceY = 0;
                //distanceX = 0;
            }
            else if (_recognizer.state == .changed)
            {
                distanceX = Int(floor(_recognizer.location(in: _recognizer.view).x)) * displayScale - mFirstTouchPositionX;
                distanceY = Int(floor(_recognizer.location(in: _recognizer.view).y)) * displayScale - mFirstTouchPositionY;
                mFirstTouchPositionX = Int(floor(_recognizer.location(in: _recognizer.view).x)) * displayScale;
                mFirstTouchPositionY = Int(floor(_recognizer.location(in: _recognizer.view).y)) * displayScale;
            }
            
            MoveTo(_box: findBox(_x: X, _y: Y), _distX: distanceX, _distY: distanceY);
        }
    
    }
    private func tapInput(_recognizer:UITapGestureRecognizer)
    {
        var localBox:Box?;
        localBox = findBox(_x: Int(_recognizer.location(in: _recognizer.view).x),
                           _y: Int(_recognizer.location(in: _recognizer.view).y));
        if (localBox != nil)
        {
            if((localBox?.getNumber())! >= 0)
            {
                print("Tap #" + String(describing: localBox!.getNumber()));
            }
        }
    }
    
    func animationUpdate()
    {
        if (mLastTime == 0)
        {
            mLastTime = Date().timeIntervalSince1970;
        }
        
        let time = Date().timeIntervalSince1970;
        let dTime = (time - mLastTime);
        
        if (dTime >= 1/60)
        {
            forceMove();
            syncPosition();
            mLastTime = time;
        }
    }
    
    private func MoveWithForce(_force:Int)
    {
        
        mForce = _force;
        mForceStepNumber = mForceNumberOfSteps;
        mForceStep = abs(mForce) / mForceNumberOfSteps;
        mForceFinished = false;
        
    }
    private func syncPosition()
    {
        if (abs(mForce) <= mForceStep && !mScrollRun)
        {
            mForce = 0;
            var dir = 0;
            
            for i in stride(from: 0, to: MovingBoxPool.count, by: 1)
            {
                if(MovingBoxPool[i].ThisPoint?.x == mMinX && (MovingBoxPool[i].ThisPoint?.y)! == mMinY!)
                {
                    if((((MovingBoxPool[i].ThisPoint?.NextPoint?.x)! - MovingBoxPool[i].getX()) < (((MovingBoxPool[i].ThisPoint?.NextPoint?.x)! - (MovingBoxPool[i].ThisPoint?.x)!)/2)) && ((MovingBoxPool[i].ThisPoint?.y)! == (MovingBoxPool[i].ThisPoint?.NextPoint?.y)!))
                    {
                        dir = 1;
                        break;
                    }
                    else if ((((MovingBoxPool[i].ThisPoint?.LastPoint?.y)! - MovingBoxPool[i].getY()) < (((MovingBoxPool[i].ThisPoint?.LastPoint?.y)! - (MovingBoxPool[i].ThisPoint?.y)!)/2)) && ((MovingBoxPool[i].ThisPoint?.x)! == (MovingBoxPool[i].ThisPoint?.LastPoint?.x)!))
                    {
                        dir = -1;
                        break;
                    }
                }
            }
            if(dir == 1)
            {
                for i in stride(from: 0, to: MovingBoxPool.count, by: 1)
                {
                    if(i != 4)
                    {
                        MovingBoxPool[i].ThisPoint = MovingBoxPool[i].ThisPoint?.NextPoint;
                    }
                }
            }
            else if (dir == -1)
            {
                for i in stride(from: 0, to: MovingBoxPool.count, by: 1)
                {
                    if (i != 4)
                    {
                        MovingBoxPool[i].ThisPoint = MovingBoxPool[i].ThisPoint?.LastPoint;
                    }
                }
            }
            
            for i in stride(from: 0, to: MovingBoxPool.count, by: 1)
            {
                var LocalBox:MovingBox?;
                   LocalBox = MovingBoxPool[i];
                
                if((LocalBox?.getX() != LocalBox?.ThisPoint?.x) || (LocalBox?.getY() != LocalBox?.ThisPoint?.y))
                {
                    if((LocalBox?.getX())! > (LocalBox?.ThisPoint?.x)!)
                    {
                        LocalBox?.setX(_x: (LocalBox?.getX())! - 1);
                    }
                    else if ((LocalBox?.getX())! < (LocalBox?.ThisPoint?.x)!)
                    {
                        LocalBox?.setX(_x: (LocalBox?.getX())! + 1);
                    }
                    
                    if((LocalBox?.getY())! > (LocalBox?.ThisPoint?.y)!)
                    {
                        LocalBox?.setY(_y: (LocalBox?.getY())! - 1);
                    }
                    else if ((LocalBox?.getY())! < (LocalBox?.ThisPoint?.y)!)
                    {
                        LocalBox?.setY(_y: (LocalBox?.getY())! + 1);
                    }
                }
            }
        }
    }
    private func findBox(_x:Int,_y:Int) -> Box?
    {
        var displayScale = 1;
        if ((UIScreen.main.scale == 2.0)&&(UIScreen.main.responds(to: #selector(NSDecimalNumberBehaviors.scale))))
        {
            displayScale = 2;
        }
        else
        {
            displayScale = 1;
        }
        
        let X = _x * displayScale;
        let Y = _y * displayScale;
        
        for i in stride(from: 0, to: BoxPool.count, by: 1)
        {
            var localBox:Box?;
            localBox = BoxPool[i];
            
            if(((localBox?.getX())! <= X) && (X <= ((localBox?.getX())! + (localBox?.getWidth())!)) && ((localBox?.getY())! <= Y) && (Y <= ((localBox?.getY())! + (localBox?.getHeight())!)))
            {
                return localBox;
            }
        }
        return nil;
    }
    
    
    private func MoveTo(_box:Box?,_distX:Int,_distY:Int)
    {
        let X = _distX;
        let Y = _distY;
        
        //print("DistX" + String.init(X));
        //print("DistY" + String.init(Y));
        var LocalBox:Box?;
        LocalBox = _box;
        
        if(LocalBox != nil)
        {
            if(abs(X) > abs(Y))
            {
                if((LocalBox?.getY())! < mScreenHeight!/2)
                {
                    if(X < 0)
                    {
                        for _ in stride(from: 0, to: (X * -1), by: 1)
                        {
                            MoveLeft();
                        }
                    }
                    else if (X > 0)
                    {
                        for _ in stride(from: 0, to: X, by: 1)
                        {
                            MoveRight();
                        }
                    }
                }
                else
                {
                    if(X < 0)
                    {
                        for _ in stride(from: 0, to: (X * -1), by: 1)
                        {
                            MoveRight();
                        }
                    }
                    else if (X > 0)
                    {
                        for _ in stride(from: 0, to: X, by: 1)
                        {
                            MoveLeft();
                        }
                    }
                }
            }
            else //if (abs(X) < abs(Y))
            {
                if((LocalBox?.getX())! < mScreenWidth!/2)
                {
                    if(Y < 0)
                    {
                        for _ in stride(from: 0, to: (Y * -1), by: 1)
                        {
                            MoveRight();
                        }
                    }
                    else if (Y > 0)
                    {
                        for _ in stride(from: 0, to: Y, by: 1)
                        {
                            MoveLeft();
                        }
                    }
                }
                else
                {
                    if (Y < 0)
                    {
                        for _ in stride(from: 0, to: (Y * -1), by: 1)
                        {
                            MoveLeft();
                        }
                    }
                    else if (Y > 0)
                    {
                        for _ in stride(from: 0, to: Y, by: 1)
                        {
                            MoveRight();
                        }
                    }
                }
            }
        }
        else
        {
            //print("Box not found");
        }
        
    }
    private func MoveRight()
    {
        let step = 1;
        for i in stride(from: 0, to: MovingBoxPool.count, by: 1)
        {
            let x = MovingBoxPool[i].getX();
            let y = MovingBoxPool[i].getY();
            
            if(x < mMaxX! && y == mMinY!)
            {
                MovingBoxPool[i].setX(_x: MovingBoxPool[i].getX() + step);
            }
            else if (x > mMinX! && y == mMaxY!)
            {
                MovingBoxPool[i].setX(_x: MovingBoxPool[i].getX() - step);
            }
            else if (x == mMaxX! && y < mMaxY!)
            {
                MovingBoxPool[i].setY(_y: MovingBoxPool[i].getY() + step);
                
                if(MovingBoxPool[i].NextBox?.getX() != MovingBoxPool[i].getX())
                {
                    if ((mMaxY! - MovingBoxPool[i].getY())+(mMaxX! - (MovingBoxPool[i].NextBox?.getX())!) > mBoxXDistance!)
                    {
                        MovingBoxPool[i].setY(_y: MovingBoxPool[i].getY() + step);
                    }
                }
                else if (MovingBoxPool[i].NextBox?.getX() == MovingBoxPool[i].getX())
                {
                    if ((MovingBoxPool[i].NextBox?.getY())! - MovingBoxPool[i].getY() > mBoxYDistance!)
                    {
                        MovingBoxPool[i].setY(_y: MovingBoxPool[i].getY()+step);
                    }
                }
            }
            else if (x == mMinX && y > mMinY!)
            {
                MovingBoxPool[i].setY(_y: MovingBoxPool[i].getY() - step);
                
                if(MovingBoxPool[i].NextBox?.getX() != MovingBoxPool[i].getX())
                {
                    if (((MovingBoxPool[i].NextBox?.getX())! - mMinX!) + (MovingBoxPool[i].getY() - mMinY!) > mBoxXDistance!)
                    {
                        MovingBoxPool[i].setY(_y: MovingBoxPool[i].getY() - step);
                    }
                }
                else if (MovingBoxPool[i].NextBox?.getX() == MovingBoxPool[i].getX())
                {
                    if (MovingBoxPool[i].getY() - (MovingBoxPool[i].NextBox?.getY())! > mBoxYDistance!)
                    {
                        MovingBoxPool[i].setY(_y: MovingBoxPool[i].getY() - step);
                    }
                }
            }
            
            if((MovingBoxPool[i].getX() == MovingBoxPool[i].ThisPoint?.NextPoint?.x)&&(MovingBoxPool[i].getY() == (MovingBoxPool[i].ThisPoint?.NextPoint?.y)!))
            {
                for j in stride(from: 0, to: MovingBoxPool.count, by: 1)
                {
                    if(j != 4)
                    {
                        MovingBoxPool[j].ThisPoint = MovingBoxPool[j].ThisPoint?.NextPoint;
                    }
                }
            }
        }
    }
    private func MoveLeft()
    {
        let step = 1;
        
        for i in stride(from: 0, to: MovingBoxPool.count, by: 1)
        {
            let x = MovingBoxPool[i].getX();
            let y = MovingBoxPool[i].getY();
            
            if (x == mMinX && y < mMaxY!)
            {
                MovingBoxPool[i].setY(_y: MovingBoxPool[i].getY() + step);
                if (MovingBoxPool[i].getX() != MovingBoxPool[i].LastBox?.getX())
                {
                    if((mMaxY! - MovingBoxPool[i].getY()) + ((MovingBoxPool[i].LastBox?.getX())! - mMinX!) > mBoxXDistance!)
                    {
                        MovingBoxPool[i].setY(_y: (MovingBoxPool[i].getY()) + step);
                    }
                }
                else if (MovingBoxPool[i].getX() == MovingBoxPool[i].LastBox?.getX())
                {
                    if(((MovingBoxPool[i].LastBox?.getY())! - MovingBoxPool[i].getY()) > mBoxYDistance!)
                    {
                        MovingBoxPool[i].setY(_y: MovingBoxPool[i].getY() + step)
                    }
                }
            }
            else if (x == mMaxX && y > mMinY!)
            {
                MovingBoxPool[i].setY(_y: MovingBoxPool[i].getY() - step);
                if(MovingBoxPool[i].getX() != MovingBoxPool[i].LastBox?.getX())
                {
                    if((mMaxX! - (MovingBoxPool[i].LastBox?.getX())!)+(MovingBoxPool[i].getY() - mMinY!) > mBoxXDistance!)
                    {
                        MovingBoxPool[i].setY(_y: MovingBoxPool[i].getY() - step);
                    }
                }
                else if (MovingBoxPool[i].getX() == MovingBoxPool[i].LastBox?.getX())
                {
                    if(MovingBoxPool[i].getY() - (MovingBoxPool[i].LastBox?.getY())! > mBoxYDistance!)
                    {
                        MovingBoxPool[i].setY(_y: MovingBoxPool[i].getY() - step);
                    }
                }
            }
            else if (x < mMaxX! && y == mMaxY!)
            {
                MovingBoxPool[i].setX(_x: MovingBoxPool[i].getX() + step);
            }
            else if (x > mMinX! && y == mMinY!)
            {
                MovingBoxPool[i].setX(_x: MovingBoxPool[i].getX() - step);
            }
            if ((MovingBoxPool[i].getX() == MovingBoxPool[i].ThisPoint?.LastPoint?.x)&&(MovingBoxPool[i].getY() == (MovingBoxPool[i].ThisPoint?.LastPoint?.y)!))
            {
                for j in stride(from: 0, to: MovingBoxPool.count, by: 1)
                {
                    if(j != 4)
                    {
                        MovingBoxPool[j].ThisPoint = MovingBoxPool[j].ThisPoint?.LastPoint;
                    }
                }
            }
        }
    }
    private func Move(_direction:Int)
    {
        if (_direction > 0)
        {
            MoveRight();
        }
        else if (_direction < 0)
        {
            MoveLeft();
        }
    }
    private func forceMove()
    {
//        print("StepNumber:")
//        print(mForceStepNumber);
//        print("Force")
//        print(mForce)
//        print("number * force step")
//        print(mForceStep * mForceStepNumber)
        //if (mForce == 10 || mForce == -10)
        if(mForceStepNumber == 1)
        {
            mForce = 0;
            mForceFinished = true;
        }
        else
        {
            
            if(abs(mForce) < mForceStepNumber * mForceStep)
            {
                mForceStepNumber -= 1;
            }
            
            if (mForce > 0)
            {
                for _ in stride(from: 0, to: mForceStepNumber * 2 , by: 1)
                {
                    //print(i);
                    Move(_direction: 1);
                }
            }
            else if (mForce < 0)
            {
                for _ in stride(from: 0, to: mForceStepNumber * 2, by: 1)
                {
                    Move(_direction: -1);
                }
            }
            
            if(mForce > 0)
            {
                mForce = mForce - 1;
            }
            else if (mForce < 0)
            {
                mForce = mForce + 1;
            }
        }
    }
    
}
