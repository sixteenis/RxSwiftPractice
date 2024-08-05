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
    let vm = PasswordViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        configureLayout()
        bind()
    }
    func bind() {
        let input = PasswordViewModel.Input(textFiledText: passwordTextField.rx.text.orEmpty, tap: nextButton.rx.tap)
        let output = vm.transform(input)
        
        output.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(BirthdayViewController(), animated: true)
            }.disposed(by: disposeBag)
        
        output.buttonEnabled
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        
        output.buttonEnabled.bind(with: self) { owner, bool in
            owner.nextButton.backgroundColor = bool ? UIColor.blue: UIColor.systemRed
        }.disposed(by: disposeBag)
        
        output.descriptionLabelText
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
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
