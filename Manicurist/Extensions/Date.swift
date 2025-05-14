//
//  Date.swift
//  Manicurist
//
//  Created by Karen Khachatryan on 27.09.24.
//

import Foundation

extension Date {
    func dateFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
    
    func timeFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH.mm"
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
}
