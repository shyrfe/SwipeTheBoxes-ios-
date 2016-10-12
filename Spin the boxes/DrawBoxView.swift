	//
//  DrawBoxView.swift
//  Spin the boxes
//
//  Created by Vladislav on 10.10.16.
//  Copyright © 2016 Vladislav. All rights reserved.
//

import UIKit
import Foundation

class DrawBoxView: UIView {
    
    
    var displayLink:CADisplayLink?;
    var animationRunning = false;
    
    var test = 1;
    
    
    override init (frame:CGRect)
    {
        super.init(frame: frame);
        self.backgroundColor = UIColor.white;
    }
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func initDisplayLink()
    {
        displayLink = CADisplayLink(target: self, selector: #selector(CALayer.setNeedsDisplay));
    }
    
    private func hexToUIColor(inputHex:String)->UIColor
    {
        var hex:String = inputHex;
        if (hex.hasPrefix("#"))
        {
            hex = hex.substring(from: hex.index(hex.startIndex, offsetBy: 1));
        }
        
        
        hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        //if (cString.characters.count != 6)
        //{
        //    return UIColor.gray;
        //}
        
        //var red = cString.substring(to: cString.index(cString.startIndex,offsetBy: 2));
        //var green = cString.substring(from: cString.index(cString.startIndex,offsetBy: 2)).substring(to: cString.index(cString.startIndex,offsetBy: 2));
        //var blue = cString.substring(from: cString.index(cString.startIndex,offsetBy: 4)).substring(to: cString.index(cString.startIndex,offsetBy: 2))
        
        //var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        
        //Scanner.scannerWithString(red).scanHexInt32(&r);
        return UIColor(red: CGFloat(r)/255, green: CGFloat(g)/255,blue: CGFloat(b)/255, alpha: CGFloat(a)/255);
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
        
        //context?.setFillColor(CGColor.)
        //context?.setStrokeColor(UIColor.gray.cgColor);
        //context?.setStrokeColor(hexToUIColor(inputHex: "#BDE0EB").cgColor);
        
        parseBox(box: Box.init(_x:40,_y:40,_width:50,_height:50
            ,_color:hexToUIColor(inputHex: "#BDE0EB"),_number:0), context: context!);
        //context?.move(to:CGPoint.init(x: test, y: 0));
        //context?.addLine(to: CGPoint.init(x: 200, y: 200));
        
        context?.strokePath();
        
        setNeedsDisplay();
    }
    
    func parseBox(box:Box,context:CGContext)
    {
        let boxWidth = box.getWidth();
        let boxHeight = box.getHeight();
        
        
        let rect = CGRect(x: box.getX(), y: box.getY(), width: boxWidth, height: boxHeight);
        context.setFillColor(box.getColor().cgColor);
        context.fill(rect);
        
        context.setStrokeColor(UIColor.black.cgColor);
        //context.setLineWidth(CGFloat.init(integerLiteral: 2));
        context.stroke(rect, width: CGFloat.init(integerLiteral: 1));
        
        let fontSize:CGFloat = 9.0;
        let text:NSString = NSString.localizedStringWithFormat("%d", box.getNumber());
        let font = UIFont(name:"Helvetica",size: fontSize);
        let textRect: CGRect = CGRect.init(x: box.getX(), y: box.getY()+(boxHeight/2)-Int(fontSize)/2, width: boxWidth, height: boxHeight);
        let paragraph = NSMutableParagraphStyle();
        paragraph.alignment = .center;
        let textFontAttributes = [NSFontAttributeName: font!, NSParagraphStyleAttributeName: paragraph];
        text.draw(in: textRect, withAttributes: textFontAttributes);
        
        
        //context.setFont(CGFont.init("Helvetica" as CFString)!);
        
    }
}
