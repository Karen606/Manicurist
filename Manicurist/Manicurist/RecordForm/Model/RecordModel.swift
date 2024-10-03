//
//  RecordModel.swift
//  Manicurist
//
//  Created by Karen Khachatryan on 27.09.24.
//

import Foundation

struct RecordModel {
    var status: Status = .active
    var id: UUID?
    var name: String?
    var email: String?
    var phoneNumber: String?
    var type: String?
    var design: String?
    var date: Date?
    var time: Date?
    var price: Double?
}

enum Status {
    case active
    case canceled
    case completed
    
    var id: String {
        switch self {
        case .active:
            return "active"
        case .canceled:
            return "canceled"
        case .completed:
            return "completed"
        }
    }
    
    static func status(value: String) -> Self {
        switch value {
        case "active":
            return .active
        case "canceled":
            return .canceled
        case "completed":
            return .completed
        default:
            return .active
        }
    }
}
