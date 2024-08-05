//
//  BirthdatModel.swift
//  RxSwiftPractice
//
//  Created by 박성민 on 8/5/24.
//

import Foundation

struct BirthdayModel {
    static let nowDate = Date.now
    var year: Int
    var month: Int
    var day: Int
    var choiceDate: Date
    init() {
        let now = Date.now
        let component = Calendar.current.dateComponents([.year, .month, .day], from: now)
        self.year = component.year!
        self.month = component.month!
        self.day = component.day!
        self.choiceDate = now
    }
    mutating func updateDate(_ date: Date) {
        let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
        self.year = component.year!
        self.month = component.month!
        self.day = component.day!
        self.choiceDate = date
    }
    func getIsAdult() -> Bool {
        let calendar = Calendar.current
        let now = Self.nowDate
        
        guard let age = calendar.dateComponents([.year], from: self.choiceDate, to: now).year else {
            return false
        }
        return age >= 18
    }
}
