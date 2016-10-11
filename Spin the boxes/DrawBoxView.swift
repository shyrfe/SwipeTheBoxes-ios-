	//
//  DrawBoxView.swift
//  Spin the boxes
//
//  Created by Vladislav on 10.10.16.
//  Copyright © 2016 Vladislav. All rights reserved.
//

import UIKit

class DrawBoxView: UIView {
    
    
    var displayLink:CADisplayLink?;
    var animationRunning = false;
    
    var test = 1;
    
    
    override init (frame:CGRect)
    {
        super.init(frame: frame);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func initWithFrame()
    {
        displayLink = CADisplayLink(target: self, selector: #selector(CALayer.setNeedsDisplay));
    }
    
    public func update()
    {
        setNeedsDisplay();
    }
    
    override func draw(_ rect: CGRect)
    {
        if (!animationRunning)
        {
            displayLink?.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode);
            animationRunning = true;
            return;
        }
        
        let context = UIGraphicsGetCurrentContext();
        
        if(test == 100)
        {
            test = 1;
        }
        
        context?.setStrokeColor(UIColor.gray.cgColor);
        context?.move(to:CGPoint.init(x: test, y: 0));
        context?.addLine(to: CGPoint.init(x: 200, y: 200));
        context?.strokePath();
        
        print("Test: 1");
        test += 1;
        setNeedsDisplay();
    }

}
