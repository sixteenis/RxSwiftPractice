//
//  PhoneViewController.swift
//  SeSACRxThreads
//
//  Created by 박성민 on 8/1/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PhoneViewController: UIViewController {
    let disposeBag = DisposeBag()
    let phoneTextField = SignTextField(placeholderText: "전화번호를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    
    //let phoneNum = BehaviorSubject(value: "010")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.white
        phoneTextField.keyboardType = .numberPad
        configureLayout()
        phoneTextField.text = "010"
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        bind()
    }
    func bind() {
        phoneTextField.rx.text
            .orEmpty
            .bind(with: self) { owner, num in
                //if num.count >= 9 && num.count <= 10 {
                if 9...10 ~= num.count{
                    owner.nextButton.isEnabled = true
                    owner.nextButton.backgroundColor = .systemBlue
                }else {
                    owner.nextButton.isEnabled = false
                    owner.nextButton.backgroundColor = .systemRed
                }
            }.disposed(by: disposeBag)
        
        
    }
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(NicknameViewController(), animated: true)
    }
    
    
    func configureLayout() {
        view.addSubview(phoneTextField)
        view.addSubview(nextButton)
        
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(phoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
}
