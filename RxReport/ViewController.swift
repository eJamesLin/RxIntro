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

    class ViewModel {
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

        var allAgree: Bool = false {
            didSet {
                allAgreeDidSet?(allAgree)
            }
        }

        var allAgreeDidSet: ((Bool) -> Void)?

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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.allAgreeDidSet = { [weak self] allAgree in
            self?.agreeButton.isEnabled = allAgree
        }
        viewModel.updateAllAgree()
    }

    func setupUI() {
        checkbox1.setTitle("unchecked", for: .normal)
        checkbox1.setTitle("checked", for: .selected)
        checkbox2.setTitle("unchecked", for: .normal)
        checkbox2.setTitle("checked", for: .selected)
    }
}

