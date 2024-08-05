//
//  SignUpViewController.swift
//  SeSACRxThreads
//
//  Created by 박성민 on 8/1/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
enum Errors: Error {
    case invalidEmail
    case invalidPassword
}

final class SignUpViewController: UIViewController {
    private let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    private let validationButton = UIButton()
    private let nextButton = PointButton(title: "다음")
    
    private let emailData = PublishSubject<String>()
    private let basicColor = BehaviorSubject(value: UIColor.systemGreen)
    
    private let disposeBag = DisposeBag()
    private let vm = SignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        configureLayout()
        configure()
        bind()
    }
    func bind() {
        let input = SignUpViewModel.Input(emailText: emailTextField.rx.text.orEmpty, tap: nextButton.rx.tap)
        let output = vm.transform(input)
        
        output.textCountBool
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.textCountBool.bind(with: self) { owner, bool in
            let color = bool ? UIColor.systemGreen : UIColor.systemRed
            owner.nextButton.backgroundColor = color
            owner.emailTextField.textColor = color
            owner.emailTextField.tintColor = color
            owner.validationButton.isEnabled = !bool
        }.disposed(by: disposeBag)
        
        output.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(PasswordViewController(), animated: true)
            }.disposed(by: disposeBag)

    }

    func configure() {
        validationButton.setTitle("중복확인", for: .normal)
        validationButton.setTitleColor(Color.black, for: .normal)
        validationButton.layer.borderWidth = 1
        validationButton.layer.borderColor = Color.black.cgColor
        validationButton.layer.cornerRadius = 10
    }
    
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(validationButton)
        view.addSubview(nextButton)
        
        validationButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.equalTo(100)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.trailing.equalTo(validationButton.snp.leading).offset(-8)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    

}
