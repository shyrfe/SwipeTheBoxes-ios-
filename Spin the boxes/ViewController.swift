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
    @IBOutlet weak var drawBox: DrawBoxView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawBox.update();
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
}

