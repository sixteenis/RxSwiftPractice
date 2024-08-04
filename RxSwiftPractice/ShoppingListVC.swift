//
//  ShoppingListVC.swift
//  RxSwiftPractice
//
//  Created by 박성민 on 8/4/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Then
struct ShoppingModel {
    var check: Bool
    var title: String
    var likes: Bool
}

class ShoppingListVC: UIViewController {
    let searchTextFiled = UITextField().then {
        $0.placeholder = "무엇을 구매하실 건가요?"
        $0.textColor = .black
        $0.backgroundColor = .lightGray
    }
    let addButton = UIButton().then {
        $0.setTitle("추가", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = .darkGray
    }
    let tableView = UITableView()
    var shoppingData = [ShoppingModel(check: false, title: "그립톡 구매", likes: true), ShoppingModel(check: true, title: "사이다 구매", likes: false), ShoppingModel(check: false, title: "아이패드 케이스 최저가 알아보기", likes: false), ShoppingModel(check: true, title: "양말", likes: true)]
    lazy var shoppingList = BehaviorRelay(value: shoppingData)
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ShoppingTableCell.self, forCellReuseIdentifier: ShoppingTableCell.identifier)
        configureLayout()
        bind()
    }
    func bind() {
        shoppingList
            .bind(to: tableView.rx.items(cellIdentifier: ShoppingTableCell.identifier, cellType: ShoppingTableCell.self)) { (row, element, cell) in
                cell.setUpdata(data: element)
                cell.checkButton.rx.tap
                    .bind(with: self) { owner, bool in
                        owner.shoppingData[row].check.toggle()
                        owner.shoppingList.accept(owner.shoppingData)
                    }.disposed(by: cell.disposeBag)
                cell.likeButton.rx.tap
                    .bind(with: self) { owner, bool in
                        owner.shoppingData[row].likes.toggle()
                        owner.shoppingList.accept(owner.shoppingData)
                    }.disposed(by: cell.disposeBag)
            }.disposed(by: disposeBag)
        searchTextFiled.rx.text.orEmpty
            .bind(with: self) { owner, text in
                print(text)
            }.disposed(by: disposeBag)
        addButton.rx.tap
            .withLatestFrom(searchTextFiled.rx.text.orEmpty)
            .bind(with: self) { owner, text in
                print("???")
                print(text)
                let list = ShoppingModel(check: false, title: text, likes: false)
                owner.shoppingData.insert(list, at: 0)
                owner.shoppingList.accept(owner.shoppingData)
                owner.searchTextFiled.text = ""
            }.disposed(by: disposeBag)
    }
    func configureLayout() {
        view.backgroundColor = .white
        view.addSubview(searchTextFiled)
        searchTextFiled.addSubview(addButton)
        view.addSubview(tableView)
        searchTextFiled.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(70)
        }
        addButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
            make.size.equalTo(40)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchTextFiled.snp.bottom).offset(15)
            make.horizontalEdges.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
        }
        
    }
    
}
