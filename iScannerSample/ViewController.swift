//
//  ViewController.swift
//  iScannerSample
//
//  Created by Adamas Zhu on 14/9/21.
//

import UIKit
import iScanner

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func scan(_ sender: Any) {
        let scanner = iScanner()
        scanner.test(over: self)
    }
}

