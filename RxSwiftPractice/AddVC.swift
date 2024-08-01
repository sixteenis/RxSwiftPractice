//
//  AddVC.swift
//  RxSwiftPractice
//
//  Created by 박성민 on 8/1/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class AddVC: UIViewController {
    let num1 = UITextField()
    let num2 = UITextField()
    let num3 = UITextField()
    
    let result = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(num1)
        view.addSubview(num2)
        view.addSubview(num3)
        view.addSubview(result)
        
        num1.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        num2.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(num1.snp.bottom).offset(10)
        }
        num3.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(num2.snp.bottom).offset(10)
        }
        result.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(num3.snp.bottom).offset(30)
        }
    }
    func add() {
//        Observable
    }
    
}
