//
//  ViewController.swift
//  RxReport
//
//  Created by CJ Lin on 2018/9/8.
//  Copyright © 2018年 cj. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var checkbox1: UIButton!

    @IBOutlet weak var checkbox2: UIButton!

    @IBOutlet weak var agreeButton: UIButton!

    class ViewModel {
        var item1checked = BehaviorRelay<Bool>(value: false)
        var item2checked = BehaviorRelay<Bool>(value: false)
        var allAgree: Observable<Bool>
        init() {
            allAgree = Observable.combineLatest(item1checked, item2checked) {
                $0 && $1
            }
        }
    }

    let viewModel = ViewModel()

    @IBAction func tapCheckbox1(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        viewModel.item1checked.accept(sender.isSelected)
    }

    @IBAction func tapCheckbox2(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        viewModel.item2checked.accept(sender.isSelected)
    }

    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        viewModel.allAgree.subscribe(
            onNext: { [weak self] (allAgree) in
                self?.agreeButton.isEnabled = allAgree
            })
            .disposed(by: disposeBag)

        /*
        viewModel.allAgree
            .bind(to: agreeButton.rx.isEnabled)
            .disposed(by: disposeBag)
        */
    }

    func setupUI() {
        checkbox1.setTitle("unchecked", for: .normal)
        checkbox1.setTitle("checked", for: .selected)
        checkbox2.setTitle("unchecked", for: .normal)
        checkbox2.setTitle("checked", for: .selected)
    }
}

