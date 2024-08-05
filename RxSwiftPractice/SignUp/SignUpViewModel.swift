//
//  SignUpViewModel.swift
//  RxSwiftPractice
//
//  Created by 박성민 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SignUpViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let emailText: ControlProperty<String>
        let tap: ControlEvent<Void>
    }
    struct Output {
        let tap: ControlEvent<Void>
        let textCountBool: Observable<Bool>
        
    }
    func transform(_ input: Input) -> Output {
        let validation = input.emailText
            .map { $0.count >= 4 }
            .share()
        return Output(tap: input.tap, textCountBool: validation)
        
    }
}
