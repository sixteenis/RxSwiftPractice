//
//  ShoppingViewModel.swift
//  RxSwiftPractice
//
//  Created by 박성민 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

class ShoppingViewModel {
    let disposeBag = DisposeBag()
    var shoppingData = [ShoppingModel(check: false, title: "그립톡 구매", likes: true), ShoppingModel(check: true, title: "사이다 구매", likes: false), ShoppingModel(check: false, title: "아이패드 케이스 최저가 알아보기", likes: false), ShoppingModel(check: true, title: "양말", likes: true)]
    
    struct Input {
        let addItem: Observable<ControlProperty<String>.Element>
        let checkButtonTap: PublishRelay<Int>
        let likeButtonTap: PublishRelay<Int>
        //let tap: ControlEvent<Void>
    }
    struct Output {
        let shoppingList: BehaviorRelay<[ShoppingModel]>
        //let tap: ControlEvent<Void>
    }
    func transform(_ input: Input) -> Output {
        let shoppingList = BehaviorRelay<[ShoppingModel]>(value: shoppingData)
        input.addItem
            .bind(with: self) { owner, text in
                let item = ShoppingModel(check: false, title: text, likes: false)
                self.shoppingData.insert(item, at: 0)
                shoppingList.accept(self.shoppingData)
            }.disposed(by: disposeBag)
        input.checkButtonTap
            .bind(with: self) { owner, index in
                owner.shoppingData[index].check.toggle()
                shoppingList.accept(self.shoppingData)
            }.disposed(by: disposeBag)
        input.likeButtonTap
            .bind(with: self) { owner, index in
                owner.shoppingData[index].likes.toggle()
                shoppingList.accept(self.shoppingData)
            }.disposed(by: disposeBag)
        
        return Output(shoppingList: shoppingList)
    }
}
