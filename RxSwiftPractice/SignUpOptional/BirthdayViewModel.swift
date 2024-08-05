//
//  BirthdayViewModel.swift
//  RxSwiftPractice
//
//  Created by 박성민 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class BirthdayViewModel {
    private let disposeBag = DisposeBag()
    private var model = BirthdayModel()
    
    struct Input {
        let pickerDate: ControlProperty<Date>
        let tap: ControlEvent<Void>
    }
    struct Output {
        let tap: ControlEvent<Void>
        let date: BehaviorRelay<BirthdayModel>
    }
    
    func transform(_ input: Input) -> Output {
        let choiceDate = BehaviorRelay<BirthdayModel>(value: model)
        input.pickerDate
            .bind(with: self) { owenr, choice in
                self.model.updateDate(choice)
                let results = self.model
                choiceDate.accept(results)
            }.disposed(by: disposeBag)
        
        return Output(tap: input.tap, date: choiceDate)
        
    }
}
