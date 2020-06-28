//
//  ViewController.swift
//  Demo
//
//  Created by Lee on 2020/6/28.
//  Copyright © 2020 LEE. All rights reserved.
//

import UIKit

class ViewController<Container: UIView>: UIViewController {

    var container: Container { view as! Container }
    
    override func loadView() {
        super.loadView()
        if view is Container {
            return
        }
        view = Container()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    deinit { print("deinit:\t\(classForCoder)") }
}
