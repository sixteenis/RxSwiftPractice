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

class SignUpViewController: UIViewController {
    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let validationButton = UIButton()
    let nextButton = PointButton(title: "다음")
    let emailData = PublishSubject<String>()
    let basicColor = BehaviorSubject(value: UIColor.systemGreen)
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        configure()
    
        bind()
        textpublishSubject()
    }
    func textpublishSubject() {
        let example = PublishSubject<String>()
        example.bind(with: self) { owner, value in
            print(value)
        }.disposed(by: disposeBag)
        example.onNext("냠냠")
    }
    func bind() {
        let validation = emailTextField.rx.text
            .orEmpty
            .map { $0.count >= 4 }
        validation.bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        validation.bind(with: self) { owner, value in
            let color: UIColor = value ? .systemGreen : .systemRed
            owner.nextButton.backgroundColor = color
            owner.validationButton.isEnabled = !value
        }.disposed(by: disposeBag)
        
        emailData.bind(to: emailTextField.rx.text)
            .disposed(by: disposeBag)
        validationButton.rx.tap.bind(with: self) { owner, _ in
            owner.emailData.onNext("b@b.com")
        }.disposed(by: disposeBag)
        basicColor.bind(to: nextButton.rx.backgroundColor, emailTextField.rx.textColor, emailTextField.rx.tintColor)
            .disposed(by: disposeBag)
        basicColor.map {$0.cgColor}.bind(to: emailTextField.layer.rx.borderColor)
            .disposed(by: disposeBag)
        nextButton.rx.tap
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
