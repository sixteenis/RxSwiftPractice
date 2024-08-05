//
//  PasswordViewModel.swift
//  RxSwiftPractice
//
//  Created by 박성민 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa


class PasswordViewModel {
    let disposeBag = DisposeBag()

    struct Input {
        let textFiledText: ControlProperty<String>
        let tap: ControlEvent<Void>
        
    }
    struct Output {
        let descriptionLabelText: BehaviorRelay<String>
        let buttonEnabled: Observable<Bool>
        let tap: ControlEvent<Void>
    }
    
    func transform(_ input: Input) -> Output {
        let validText = BehaviorRelay(value: "8글자 이상 입력해주세요.")
        let validation = input.textFiledText
            .map { $0.count >= 8 } //참이면 8글자 이상임 ㅇㅇ
            //.share()
        validation
            .bind(with: self) { owner, bool in
                let text = bool ? "가입 가능합니다!" : "8글자 이상 입력해주세요."
                validText.accept(text)
            }.disposed(by: disposeBag)
        
            
        return Output(descriptionLabelText: validText, buttonEnabled: validation, tap: input.tap)
    }
}
