//
//  ViewController.swift
//  RxReport
//
//  Created by CJ Lin on 2018/9/8.
//  Copyright © 2018年 cj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var checkbox1: UIButton!

    @IBOutlet weak var checkbox2: UIButton!

    @IBOutlet weak var agreeButton: UIButton!

    @IBAction func tapCheckbox1(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        updateButtonState()
    }

    @IBAction func tapCheckbox2(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        updateButtonState()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateButtonState()
    }

    func updateButtonState() {
        agreeButton.isEnabled = checkbox1.isSelected && checkbox2.isSelected
    }

    func setupUI() {
        checkbox1.setTitle("unchecked", for: .normal)
        checkbox1.setTitle("checked", for: .selected)
        checkbox2.setTitle("unchecked", for: .normal)
        checkbox2.setTitle("checked", for: .selected)
    }
}

