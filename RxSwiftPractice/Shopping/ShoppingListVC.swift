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
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    let vm = ShoppingViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ShoppingTableCell.self, forCellReuseIdentifier: ShoppingTableCell.identifier)
        collectionView.register(RecentCollectionViewCell.self, forCellWithReuseIdentifier: RecentCollectionViewCell.identifier)
        configureLayout()
        bind()
    }
    func bind() {
        let checkButtonTap = PublishRelay<UUID>()
        let likeButtonTap = PublishRelay<UUID>()
        let recentText = PublishRelay<String>()
        //셀 뷰모델
        let input = ShoppingViewModel.Input(addItem: addButton.rx.tap.withLatestFrom(searchTextFiled.rx.text.orEmpty), lookText: searchTextFiled.rx.text.orEmpty.distinctUntilChanged(), checkButtonTap: checkButtonTap, likeButtonTap: likeButtonTap, recentText: recentText)
        let output = vm.transform(input)
        
        output.shoppingList //결과 유니캐스팅 멀티캐스팅?
            .bind(to: tableView.rx.items(cellIdentifier: ShoppingTableCell.identifier, cellType: ShoppingTableCell.self)) { (row, element, cell) in
                cell.setUpdata(data: element)
                cell.checkButton.rx.tap
                    .map{element.id}
                    .bind(to: checkButtonTap)
                    .disposed(by: cell.disposeBag)
                cell.likeButton.rx.tap
                    .map{element.id}
                    .bind(to: likeButtonTap)
                    .disposed(by: cell.disposeBag)
            }.disposed(by: disposeBag)
        output.recentList
            .bind(to: collectionView.rx.items(cellIdentifier: RecentCollectionViewCell.identifier, cellType: RecentCollectionViewCell.self)) { (row, element, cell) in
                cell.label.text = element
            }.disposed(by: disposeBag)
        collectionView.rx.modelSelected(String.self)
            .bind(with: self) { owner, value in
                recentText.accept(value)
            }.disposed(by: disposeBag)
        
    }
    func configureLayout() {
        view.backgroundColor = .white
        view.addSubview(searchTextFiled)
        view.addSubview(addButton)
        view.addSubview(tableView)
        view.addSubview(collectionView)
        collectionView.showsHorizontalScrollIndicator = false
        searchTextFiled.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(70)
        }
        addButton.snp.makeConstraints { make in
            make.centerY.equalTo(searchTextFiled)
            make.trailing.equalTo(searchTextFiled).inset(10)
            make.size.equalTo(40)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchTextFiled.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
        }
        
    }
    
}

extension ShoppingListVC {
    static func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 40)
        layout.scrollDirection = .horizontal
        return layout
    }
}
