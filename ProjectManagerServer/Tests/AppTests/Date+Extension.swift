//
//  File.swift
//  
//
//  Created by Ryan-Son on 2021/07/09.
//

import Foundation

extension Date {
    func formatted(as dateFormat: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        let stringDate = formatter.string(from: self)
        return formatter.date(from: stringDate)
    }
}
