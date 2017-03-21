//
//  ViewController.swift
//  RxSwiftEx1
//
//  Created by Waratnan Suriyasorn on 3/21/2560 BE.
//  Copyright © 2560 Waratnan Suriyasorn. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var greenSwitch: UISwitch!

    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var lbl4: UILabel!
    @IBOutlet weak var lbl5: UILabel!
    @IBOutlet weak var lbl6: UILabel!
    
    let disposeBag = DisposeBag()
    var buttonTapCount: Variable<Int> = Variable(0)
    var publisher: PublishSubject<Void> = PublishSubject()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
    }

    func bindView() {
        
        textField1.rx.text
            .asObservable()
            .bindTo(lbl1.rx.text)
            .disposed(by: disposeBag)
        
        textField2.rx.text.orEmpty
            .asObservable()
            .map { "textfield2: \($0)" }
            .bindTo(lbl2.rx.text)
            .disposed(by: disposeBag)
        
        slider.rx.value.asObservable()
            .throttle(0.5, scheduler: MainScheduler.instance)
            .subscribe(onNext: { value in
                self.lbl3.text = String(value)
            })
            .disposed(by: disposeBag)
        
        segment.rx.value
            .asObservable()
            .subscribe(onNext: { selected in
                self.lbl4.text = "selected: \(selected)"
            })
            .disposed(by: disposeBag)
        
        greenSwitch.rx.value
            .asObservable()
            .do(onNext: { isOn in
                self.lbl5.text = "Switch isOn: \(isOn)"
            })
            .bindTo(slider.rx.isEnabled)
            .disposed(by: disposeBag)
        
        let textField1Validate = textField1.rx.text.orEmpty
            .asObservable()
            .map { !$0.isEmpty }

        let textField2Validate = textField2.rx.text.orEmpty
            .asObservable()
            .map { $0.characters.count > 4 }
        
        Observable.combineLatest(textField1Validate, textField2Validate) {
                $0 && $1
            }
            .bindTo(button.rx.isEnabled)
            .disposed(by: disposeBag)
        
        button.rx.controlEvent(UIControlEvents.touchUpInside)
            .asObservable()
            .subscribe(onNext: {
                print("button tapped")
                self.buttonTapCount.value += 1
                self.publisher.onNext()
//                self.publisher.onCompleted()
            })
            .disposed(by: disposeBag)
        
        buttonTapCount.asObservable()
            .skip(0)
            .map { "Button Tapped: \($0)" }
            .bindTo(lbl6.rx.text)
            .disposed(by: disposeBag)
        
        publisher.asObservable()
            .subscribe { event in
                print(event)
            }
            .disposed(by: disposeBag)
    }
}

