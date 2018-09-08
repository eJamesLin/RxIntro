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

    class ViewModel: NSObject {
        var item1checked: Bool = false {
            didSet {
                updateAllAgree()
            }
        }
        var item2checked: Bool = false {
            didSet {
                updateAllAgree()
            }
        }

        // KVO-enabled properties must be @objc dynamic
        @objc dynamic var allAgree: Bool = false

        func updateAllAgree() {
            allAgree = item1checked && item2checked
        }
    }

    let viewModel = ViewModel()

    @IBAction func tapCheckbox1(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        viewModel.item1checked = sender.isSelected
    }

    @IBAction func tapCheckbox2(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        viewModel.item2checked = sender.isSelected
    }

    var observe: NSKeyValueObservation?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        observe =
            viewModel.observe(\.allAgree,
                              options: [.initial, .new]) { [weak self] (vm, _) in
                self?.agreeButton.isEnabled = vm.allAgree
            }
    }

    func setupUI() {
        checkbox1.setTitle("unchecked", for: .normal)
        checkbox1.setTitle("checked", for: .selected)
        checkbox2.setTitle("unchecked", for: .normal)
        checkbox2.setTitle("checked", for: .selected)
    }
}

