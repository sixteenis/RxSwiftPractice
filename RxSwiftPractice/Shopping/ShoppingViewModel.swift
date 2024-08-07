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
    var recentList = ["고구마","감자","빵","밥먹기","개발하기","잠자기","화장실가기", "똥싸기", "담배피기", "블로그쓰기", "라면먹기", "노래듣기"]
    struct Input {
        let addItem: Observable<ControlProperty<String>.Element>
        let lookText: Observable<ControlProperty<String>.Element>
        let checkButtonTap: PublishRelay<UUID>
        let likeButtonTap: PublishRelay<UUID>
        let recentText: PublishRelay<String>
    }
    struct Output {
        let shoppingList: BehaviorRelay<[ShoppingModel]>
        let recentList: BehaviorRelay<[String]>
        
    }
    func transform(_ input: Input) -> Output {
        let shoppingList = BehaviorRelay<[ShoppingModel]>(value: shoppingData)
        let filterText = BehaviorRelay(value: "")
        let recentList = BehaviorRelay(value: self.recentList)
        // TODO: 나중에 로직 합치는거 다시 도전하자!
//        let combineObservable = Observable.combineLatest(input.addItem, input.lookText, input.checkButtonTap, input.likeButtonTap, input.recentText)
//
//        combineObservable
//            .bind(with: self, onNext: { owner, _ in
//                if filterText.value != ""{
//                    shoppingList.accept(owner.shoppingData.filter { $0.title.contains(filterText.value)})
//                }else{
//                    shoppingList.accept(owner.shoppingData)
//                }
//            }).disposed(by: disposeBag)
        
        input.addItem
            .bind(with: self) { owner, text in
                let item = ShoppingModel(check: false, title: text, likes: false)
                self.shoppingData.insert(item, at: 0)
                shoppingList.accept(owner.shoppingData.filter { $0.title.contains(filterText.value)})
            }.disposed(by: disposeBag)
        
        input.lookText
            .bind(with: self) { owner, filter in
                filterText.accept(filter)
                if filter.isEmpty {
                    shoppingList.accept(owner.shoppingData)
                }else{
                    let result = owner.shoppingData.filter { $0.title.contains(filter)}
                    shoppingList.accept(result)
                }
            }.disposed(by: disposeBag)
        
        
        input.checkButtonTap
            .bind(with: self) { owner, id in
                for i in 0...owner.shoppingData.count-1 {
                    if owner.shoppingData[i].id == id {
                        owner.shoppingData[i].check.toggle()
                        break
                    }
                }
                if filterText.value != ""{
                    shoppingList.accept(owner.shoppingData.filter { $0.title.contains(filterText.value)})
                }else{
                    shoppingList.accept(owner.shoppingData)
                }
            }.disposed(by: disposeBag)
        
        input.likeButtonTap
            .bind(with: self) { owner, id in
                for i in 0...owner.shoppingData.count-1 {
                    if owner.shoppingData[i].id == id {
                        owner.shoppingData[i].likes.toggle()
                        break
                    }
                }
                if filterText.value != ""{
                    shoppingList.accept(owner.shoppingData.filter { $0.title.contains(filterText.value)})
                }else{
                    shoppingList.accept(owner.shoppingData)
                }
            }.disposed(by: disposeBag)
        input.recentText
            .bind(with: self) { owner, value in
                owner.shoppingData.insert(ShoppingModel(check: false, title: "\(value) 메모~~~ :)", likes: false), at: 0)
                if filterText.value != "" {
                    shoppingList.accept(owner.shoppingData.filter { $0.title.contains(filterText.value)})
                }else{
                    shoppingList.accept(owner.shoppingData)
                }
            }.disposed(by: disposeBag)
        
        return Output(shoppingList: shoppingList, recentList: recentList)
    }
}
