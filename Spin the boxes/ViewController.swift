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
    
    //var displayLink:CADisplayLink?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        drawBox = DrawBoxView(frame: self.view.bounds);
        drawBox?.initDisplayLink();
        self.view.addSubview(drawBox!);
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

