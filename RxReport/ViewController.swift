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

        demoConcurrentAPICall()
        demoSerialAPICall()
    }

    func demoConcurrentAPICall() {
        let api1: Observable<String> = Observable.create { observer in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                observer.onNext("1")
                observer.onCompleted()
            })
            return Disposables.create()
        }

        let api2: Observable<String> = Observable.create { observer in
            observer.onNext("2")
            observer.onCompleted()
            return Disposables.create()
        }

        _ = Observable.combineLatest(api1, api2) { (r1, r2) in
            return r1 + r2
            }.subscribe(onNext: {
                print("concurrent result " + $0)
            })
    }

    func demoSerialAPICall() {
        let api1: Observable<String> = Observable.create { observer in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                observer.onNext("A")
                observer.onCompleted()
            })
            return Disposables.create()
        }

        func api2(input: String) -> Observable<String> {
            return Observable<String>.create { (observer) -> Disposable in
                observer.onNext(input + "B")
                observer.onCompleted()
                return Disposables.create()
            }
        }

        _ = api1.flatMapLatest {
                api2(input: $0)
            }.subscribe(onNext: {
                print("serial result " + $0)
            })
    }

    func setupUI() {
        checkbox1.setTitle("unchecked", for: .normal)
        checkbox1.setTitle("checked", for: .selected)
        checkbox2.setTitle("unchecked", for: .normal)
        checkbox2.setTitle("checked", for: .selected)
    }
}

