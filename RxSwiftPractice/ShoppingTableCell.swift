//
//  ShoppingTableCell.swift
//  RxSwiftPractice
//
//  Created by 박성민 on 8/4/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Then


class ShoppingTableCell: UITableViewCell {
    static let identifier = "ShoppingTableCell"
    var disposeBag = DisposeBag()
    let checkButton = UIButton()
    let title = UILabel().then {
        $0.textColor = .black
        $0.numberOfLines = 1
        $0.textAlignment = .left
    }
    let likeButton = UIButton()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
        bind()
    }
    func setUpView() {
        contentView.addSubview(checkButton)
        contentView.addSubview(title)
        contentView.addSubview(likeButton)
        
        checkButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(15)
            make.size.equalTo(35)
        }
        title.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(checkButton.snp.trailing).offset(15)
        }
        likeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(15)
        }
        checkButton.setTitle("", for: .normal)
        likeButton.setTitle("", for: .normal)
    }
    func setUpdata(data: ShoppingModel) {
        let check = data.check ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "checkmark.square")
        let likes = data.likes ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        checkButton.setImage(check, for: .normal)
        likeButton.setImage(likes, for: .normal)
        title.text = data.title
    }
    func bind() {
        checkButton.rx.tap
            .bind(with: self) { owner, _ in
                print("123123")
            }.disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
