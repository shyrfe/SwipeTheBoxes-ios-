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
    public var BoxPool = [Box]();
    public var MovingBoxPool = [MovingBox]();
    
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
    
    let mDrawBoxView:DrawBoxView;
    
    init(_drawBoxView:DrawBoxView)
    {
        mDrawBoxView = _drawBoxView;
        
        
        let thread = Thread(target: self, selector: #selector(boxsInit), object: nil);
        thread.start();
        //boxsInit()
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
    
}
