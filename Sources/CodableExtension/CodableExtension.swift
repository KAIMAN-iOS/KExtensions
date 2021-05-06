//
//  File.swift
//  
//
//  Created by GG on 12/01/2021.
//

import Foundation
import Alamofire

public enum MultipartEncodeError: Error {
    case addFailed
}

public extension MultipartFormData {
    func encode(_ value: Encodable, for key: String? = nil) throws {
        guard let valueData = try? value.encoded() else {
            throw MultipartEncodeError.addFailed
        }
        print("🔥 \(String(data: valueData, encoding: .utf8) ?? "") for \(key ?? String(describing: value))")
        append(valueData, withName: key ?? String(describing: value))
    }

    func encode(_ value: String, for key: String? = nil) throws {
        guard let valueData = value.data(using: .utf8) else {
            throw MultipartEncodeError.addFailed
        }
        print("🔥🔥 \(String(data: valueData, encoding: .utf8) ?? "") for \(key ?? String(describing: value))")
        append(valueData, withName: key ?? String(describing: value))
    }
}

public extension Encodable {
    func encoded() throws -> Data {
        return try JSONEncoder().encode(self)
    }
}

public extension Data {
    func decoded<T: Decodable>() throws -> T {
        return try JSONDecoder().decode(T.self, from: self)
    }
}

public enum DecodableDefault {}
public protocol DecodableDefaultSource {
    associatedtype Value: Codable
    static var defaultValue: Value { get }
}

public extension DecodableDefault {
    @propertyWrapper
    struct Wrapper<Source: DecodableDefaultSource> {
        public typealias Value = Source.Value
        public var wrappedValue = Source.defaultValue
        
        public  init() {}
    }
}

extension DecodableDefault.Wrapper: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = try container.decode(Value.self)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}

public extension KeyedDecodingContainer {
    func decode<T>(_ type: DecodableDefault.Wrapper<T>.Type,
                   forKey key: Key) throws -> DecodableDefault.Wrapper<T> {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
}

public extension DecodableDefault {
    typealias Source = DecodableDefaultSource
    typealias List = Codable & ExpressibleByArrayLiteral
    typealias Map = Codable & ExpressibleByDictionaryLiteral

    enum Sources {
        public enum True: Source {
            public static var defaultValue: Bool { true }
        }

        public enum False: Source {
            public static var defaultValue: Bool { false }
        }

        public enum EmptyString: Source {
            public static var defaultValue: String { "" }
        }

        public enum EmptyList<T: List>: Source {
            public static var defaultValue: T { [] }
        }

        public enum EmptyMap<T: Map>: Source {
            public static var defaultValue: T { [:] }
        }
    }
}

public extension DecodableDefault {
    typealias True = Wrapper<Sources.True>
    typealias False = Wrapper<Sources.False>
    typealias EmptyString = Wrapper<Sources.EmptyString>
    typealias EmptyList<T: List> = Wrapper<Sources.EmptyList<T>>
    typealias EmptyMap<T: Map> = Wrapper<Sources.EmptyMap<T>>
}

// USAGE
//struct Article: Decodable {
//    var title: String
//    @DecodableDefault.EmptyString var body: String
//    @DecodableDefault.False var isFeatured: Bool
//    @DecodableDefault.True var isActive: Bool
//    @DecodableDefault.EmptyList var comments: [Comment]
//    @DecodableDefault.EmptyMap var flags: [String : Bool]
//}

@propertyWrapper
public struct Clamped<Value: Comparable & Codable> {
    public var value: Value
    public var range: ClosedRange<Value>
    
    public init(wrappedValue: Value, range: ClosedRange<Value>) {
        value = wrappedValue
        self.range = range
    }
    
    public var wrappedValue: Value {
        get { value }
        set { value = min(max(range.lowerBound, newValue), range.upperBound) }
    }
}

// MARK: - Loosy Lists
extension LossyCodableList: Decodable where Element: Decodable {
    private struct ElementWrapper: Decodable {
        var element: Element?
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            element = try? container.decode(Element.self)
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let wrappers = try container.decode([ElementWrapper].self)
        elements = wrappers.compactMap(\.element)
    }
}

extension LossyCodableList: Encodable where Element: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        
        for element in elements {
            try? container.encode(element)
        }
    }
}

/**
 usage : @LossyCodableList var items: [Item].
 
 Now any Item that is malformed won't be decompressed by the JSONDecoder but the whole structure willre main valid
  */
@propertyWrapper
public struct LossyCodableList<Element> {
    public var elements: [Element]
    
    public var wrappedValue: [Element] {
        get { elements }
        set { elements = newValue }
    }
}
