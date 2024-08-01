//
//  PasswordViewController.swift
//  SeSACRxThreads
//
//  Created by 박성민 on 8/1/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PasswordViewController: UIViewController {
   
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    let descriptionLabel = UILabel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        nextButton.rx.tap.bind(with: self) { owner, _ in
            owner.navigationController?.pushViewController(BirthdayViewController(), animated: true)
        }.disposed(by: disposeBag)
        configureLayout()
        descriptionLabel.text = "8자 이상 입력해주세요."
        bind()
    }
    func bind() {
        let validation = passwordTextField.rx.text.orEmpty.map {$0.count >= 8} //bool? //방출 //참이면 8보다 큼
        validation //방출만 하는놈
            .map { $0 ? UIColor.blue : UIColor.systemRed}
            .bind(to: nextButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        validation
            .bind(to: nextButton.rx.isEnabled, descriptionLabel.rx.isHidden)
            .disposed(by: disposeBag)
//            .bind(with: self) { owner, bool in
//                owner.nextButton.backgroundColor = bool ? UIColor.systemBlue : UIColor.systemRed
//            }
            

        
    }
    
    func configureLayout() {
        view.addSubview(passwordTextField)
        view.addSubview(nextButton)
        view.addSubview(descriptionLabel)
         
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.bottom.equalTo(passwordTextField.snp.top).offset(-10)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
