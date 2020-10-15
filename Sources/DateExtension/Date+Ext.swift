//
//  Date+Ext.swift
//  CovidApp
//
//  Created by jerome on 29/03/2020.
//  Copyright © 2020 Jerome TONNELIER. All rights reserved.
//

import Foundation

protocol DateFormatterDecodable {
    static var dateFormatter: DateFormatter? { get }
    static var isoDateFormatter: ISO8601DateFormatter? { get }
}

struct CustomDate<E:DateFormatterDecodable>: Codable {
    let value: Date
    init(date: Date) {
        value = date
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let text = try container.decode(String.self)
        guard let date = E.dateFormatter?.date(from: text) ?? E.isoDateFormatter?.date(from: text) else {
            throw CustomDateError.wrongDateFormat
        }
        self.value = date
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        guard let date = E.dateFormatter?.string(from: value) ?? E.isoDateFormatter?.string(from: value) else {
            throw CustomDateError.wrongDateFormat
        }
        try container.encode(date)
    }
    enum CustomDateError: Error {
        case wrongDateFormat
    }
}

struct ISODateFormatterDecodable: DateFormatterDecodable {
    static var isoDateFormatter: ISO8601DateFormatter? {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return dateFormatter
    }
    static var dateFormatter: DateFormatter? {
        return nil
    }
}

public extension DateFormatter {
    static let readableDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.timeStyle = .none
        f.dateStyle = .medium
        return f
    } ()
    
    static let timeOnlyFormatter: DateFormatter = {
        let f = DateFormatter()
        f.timeStyle = .short
        f.dateStyle = .none
        return f
    } ()
    
    static let facebookDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MM/dd/yyyy"
        return f
    } ()
    
    static let apiDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    } ()
}
