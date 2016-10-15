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
            //gestureRecognizer.location(in: gestureRecognizer.view)
            //print("Longpress Start!");
        }
        else if (gestureRecognizer.state == UIGestureRecognizerState.ended)
        {
            mBoxController?.input(_value: BoxController.INPUT_TYPE_LONGPRESS_END,_recognizer: gestureRecognizer)
            //print("Longpress End!");
        }
    }
    
    @objc private func mInputTap(_ gestureRecognizer: UITapGestureRecognizer)
    {
        mBoxController?.input(_value: BoxController.INPUT_TYPE_TAP, _recognizer: gestureRecognizer);
    }
    
//    @objc private func mInputSwipe(_ gestureRecognizer: UISwipeGestureRecognizer)
//    {
//        mBoxController?.input(_value: BoxController.INPUT_TYPE_SWIPE, _recognizer: gestureRecognizer);
//        //print("SWIPE");
//    }
    
    @objc private func mInputPan(_ gestureRecognizer: UIPanGestureRecognizer)
    {
        mBoxController?.input(_value: BoxController.INPUT_TYPE_PAN, _recognizer: gestureRecognizer);
        //let vel = gestureRecognizer.velocity(in: gestureRecognizer.view);
        //print("Velocity: X: " + String.init(describing: vel.x) + "Y: "  + String.init(describing: vel.y));
        
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
        
//        let mRightDirectionSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(mInputSwipe(_:)));
//        let mLeftDirectionSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(mInputSwipe(_:)));
//        let mUpDirectionSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(mInputSwipe(_:)));
//        let mDownDirectionSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(mInputSwipe(_:)));
//
//        mRightDirectionSwipeRecognizer.direction = .right;
//        mLeftDirectionSwipeRecognizer.direction = .left;
//        mUpDirectionSwipeRecognizer.direction = .up;
//        mDownDirectionSwipeRecognizer.direction = .down;
//        
//        view.addGestureRecognizer(mRightDirectionSwipeRecognizer);
//        view.addGestureRecognizer(mLeftDirectionSwipeRecognizer);
//        view.addGestureRecognizer(mUpDirectionSwipeRecognizer);
//        view.addGestureRecognizer(mDownDirectionSwipeRecognizer);
        
        let mPanRecognizer = UIPanGestureRecognizer(target: self, action: #selector(mInputPan(_:)));
//        mPanRecognizer.require(toFail: mRightDirectionSwipeRecognizer);
//        mPanRecognizer.require(toFail: mLeftDirectionSwipeRecognizer);
//        mPanRecognizer.require(toFail: mUpDirectionSwipeRecognizer);
//        mPanRecognizer.require(toFail: mDownDirectionSwipeRecognizer);
        view.addGestureRecognizer(mPanRecognizer);
        
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

