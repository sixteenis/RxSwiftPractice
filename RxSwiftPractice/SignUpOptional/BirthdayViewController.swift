//
//  BirthdayViewController.swift
//  SeSACRxThreads
//
//  Created by 박성민 on 8/1/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class BirthdayViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.black
        label.text = "만 17세 이상만 가입 가능합니다."
        return label
    }()
    private let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10
        return stack
    }()
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.text = "2023년"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    private let monthLabel: UILabel = {
        let label = UILabel()
        label.text = "33월"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.text = "99일"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    private let nextButton = PointButton(title: "가입하기")
    
    private let vm = BirthdayViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.white
        configureLayout()
        bind()
    }
    private func bind() {
        let input = BirthdayViewModel.Input(pickerDate: birthDayPicker.rx.date, tap: nextButton.rx.tap)
        let output = vm.transform(input)
        output.date
            .bind(with: self) { owner, model in
                owner.yearLabel.text = "\(model.year)년"
                owner.monthLabel.text = "\(model.month)월"
                owner.dayLabel.text = "\(model.day)일"
                let isAdult = model.getIsAdult()
                owner.infoLabel.text = isAdult ? "가입 가능 하십니다." : "만 17세 이상만 가입 가능합니다."
                owner.infoLabel.textColor = isAdult ? .systemBlue : .systemRed
                owner.nextButton.isEnabled = isAdult
            }.disposed(by: disposeBag)
        
        output.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(SearchViewController(), animated: true)
            }.disposed(by: disposeBag)
    }
    
    func configureLayout() {
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
        
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
}
