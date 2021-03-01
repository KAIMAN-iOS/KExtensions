//
//  Date+Ext.swift
//  CovidApp
//
//  Created by jerome on 29/03/2020.
//  Copyright © 2020 Jerome TONNELIER. All rights reserved.
//

import Foundation

public protocol DateFormatterDecodable {
    static var dateFormatter: DateFormatter? { get }
    static var isoDateFormatter: ISO8601DateFormatter? { get }
}

public struct CustomDate<E:DateFormatterDecodable>: Codable {
    public let value: Date
    public init(date: Date) {
        value = date
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let text = try container.decode(String.self)
        guard let date = E.dateFormatter?.date(from: text) ?? E.isoDateFormatter?.date(from: text) else {
            throw CustomDateError.wrongDateFormat
        }
        self.value = date
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let date = try dateAsString()
        try container.encode(date)
    }
    
    public enum CustomDateError: Error {
        case wrongDateFormat
    }
    
    public func dateAsString() throws -> String {
        guard let date = E.dateFormatter?.string(from: value) ?? E.isoDateFormatter?.string(from: value) else {
            throw CustomDateError.wrongDateFormat
        }
        return date
    }
}

public struct ISODateFormatterDecodable: DateFormatterDecodable {
    public static var isoDateFormatter: ISO8601DateFormatter? {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return dateFormatter
    }
    public static var dateFormatter: DateFormatter? {
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
    
    @available(iOS 13.0, *)
    static let relativeDateFormatter: RelativeDateTimeFormatter = {
        let f = RelativeDateTimeFormatter()
        f.unitsStyle = .full
        return f
    } ()
    
    @available(iOS 13.0, *)
    static let relativeDayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.timeStyle = .none
        f.dateStyle = .medium
        f.doesRelativeDateFormatting = true
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
