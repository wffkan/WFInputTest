//
//  ViewController.swift
//  InputTest
//
//  Created by benny wang on 2021/1/8.
//

import UIKit
import WFInputDemo

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let inputView = WFInputView(frame: CGRect(x: 50, y: 100, width: 300, height: 50))
        view.addSubview(inputView)
    }


}

