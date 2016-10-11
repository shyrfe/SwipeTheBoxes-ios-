	//
//  DrawBoxView.swift
//  Spin the boxes
//
//  Created by Vladislav on 10.10.16.
//  Copyright © 2016 Vladislav. All rights reserved.
//

import UIKit

class DrawBoxView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var test = 1;
    
    public func update()
    {
        setNeedsDisplay();
    }
    
    override func draw(_ rect: CGRect)
    {
        let context = UIGraphicsGetCurrentContext();
        
        if(test == 100)
        {
            test = 1;
        }
        
        context?.setStrokeColor(UIColor.gray.cgColor);
        context?.move(to:CGPoint.init(x: test, y: 0));
        context?.addLine(to: CGPoint.init(x: 200, y: 200));
        context?.strokePath();
        
        print("Test: /test");
        test += 1;
        
    }

}
