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

class BirthdayViewController: UIViewController {
    let disposeBag = DisposeBag()
    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.black
        label.text = "만 17세 이상만 가입 가능합니다."
        return label
    }()
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10
        return stack
    }()
    let yearLabel: UILabel = {
        let label = UILabel()
        label.text = "2023년"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    let monthLabel: UILabel = {
        let label = UILabel()
        label.text = "33월"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    let dayLabel: UILabel = {
        let label = UILabel()
        label.text = "99일"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let nextButton = PointButton(title: "가입하기")
    let birthday = Observable.just(Date.now)//Date.now
    let year = BehaviorRelay(value: 0)
    let month = BehaviorRelay(value: 0)
    let day = BehaviorRelay(value: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.white
        birthday
            .bind(with: self) { owner, date in
                let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
                owner.year.accept(component.year!)
                owner.month.accept(component.month!)
                owner.day.accept(component.day!)
            }
            .disposed(by: disposeBag)
        
        configureLayout()
        
        bind()
    }
    
    
    
    private func isAdult(date: Date) -> Bool {
            let calendar = Calendar.current
            let now = Date()
            
            guard let age = calendar.dateComponents([.year], from: date, to: now).year else {
                return false
            }
            
            return age >= 18
        }
    func bind() {
        birthDayPicker.rx.date
            .bind(with: self) { owner, date in
                let component = Calendar.current.dateComponents([.day,.month,.year], from: date)
                owner.year.accept(component.year!)
                owner.month.accept(component.month!)
                owner.day.accept(component.day!)
                let bool = owner.isAdult(date: date)
                owner.nextButton.isEnabled = bool //참이면 18세 이상
                owner.infoLabel.text = bool ? "가입 가능 하십니다." : "만 17세 이상만 가입 가능합니다."
                owner.infoLabel.textColor = bool ? .systemBlue : .systemRed
            }.disposed(by: disposeBag)
        year
            .map {"\($0)년"}
            .bind(to: yearLabel.rx.text)
            .disposed(by: disposeBag)
        month
            .map { "\($0)월"}
            .bind(to: monthLabel.rx.text)
            .disposed(by: disposeBag)
        day
            .map { "\($0)일"}
            .bind(to: dayLabel.rx.text)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
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
