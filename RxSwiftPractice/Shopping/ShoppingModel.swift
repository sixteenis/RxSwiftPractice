//
//  ShoppingModel.swift
//  RxSwiftPractice
//
//  Created by 박성민 on 8/5/24.
//

import Foundation

struct ShoppingModel: Identifiable {
    let id = UUID()
    var check: Bool
    var title: String
    var likes: Bool
    
}
