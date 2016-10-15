//
//  ViewController.swift
//  Spin the boxes
//
//  Created by Vladislav on 07.10.16.
//  Copyright © 2016 Vladislav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var FirstButton: UIButton!
    //@IBOutlet weak var drawBox: DrawBoxView!
    
    var drawBox: DrawBoxView?;
    private var mBoxController:BoxController?;
    
    @objc private func mInputLongPress(_ gestureRecognizer: UILongPressGestureRecognizer)
    {
        if (gestureRecognizer.state == UIGestureRecognizerState.began)
        {
            mBoxController?.input(_value: BoxController.INPUT_TYPE_LONGPRESS_START,_recognizer: gestureRecognizer)
        }
        else if (gestureRecognizer.state == UIGestureRecognizerState.ended)
        {
            mBoxController?.input(_value: BoxController.INPUT_TYPE_LONGPRESS_END,_recognizer: gestureRecognizer)
        }
    }
    
    @objc private func mInputTap(_ gestureRecognizer: UITapGestureRecognizer)
    {
        mBoxController?.input(_value: BoxController.INPUT_TYPE_TAP, _recognizer: gestureRecognizer);
    }
    
    @objc private func mInputPan(_ gestureRecognizer: UIPanGestureRecognizer)
    {
        mBoxController?.input(_value: BoxController.INPUT_TYPE_PAN, _recognizer: gestureRecognizer);
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        mBoxController?.input(_value: BoxController.INPUT_TYPE_TOUCH_BEGAN, _recognizer: nil);
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        mBoxController?.input(_value: BoxController.INPUT_TYPE_TOUCH_ENDED, _recognizer: nil);
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        mBoxController?.input(_value: BoxController.INPUT_TYPE_TOUCH_MOVED, _recognizer: nil);
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        drawBox = DrawBoxView(frame: self.view.bounds);
        drawBox?.initDisplayLink();
        self.view.addSubview(drawBox!);
        
        mBoxController = BoxController(_drawBoxView: drawBox!);
        
        let mLongPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(mInputLongPress(_:)));
        view.addGestureRecognizer(mLongPressRecognizer);
        
        let mTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(mInputTap(_:)));
        view.addGestureRecognizer(mTapRecognizer);
        
        let mPanRecognizer = UIPanGestureRecognizer(target: self, action: #selector(mInputPan(_:)));
        view.addGestureRecognizer(mPanRecognizer);
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

