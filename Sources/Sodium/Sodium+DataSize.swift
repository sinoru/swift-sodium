//
//  Sodium+DataSize.swift
//
//
//  Created by Jaehong Kang on 8/14/24.
//

#if os(macOS) || os(iOS)
import Darwin
#elseif canImport(Glibc)
import Glibc
#elseif canImport(Musl)
import Musl
#elseif os(Windows)
import ucrt
#else
#error("Unknown platform")
#endif

extension Sodium {
    public struct DataSize: Equatable, Hashable, Comparable, Sendable {
        private static var charBit: Int = Int(CHAR_BIT)
        public private(set) var rawValue: UInt16

        public var bitCount: Int {
            Int(rawValue)
        }

        public var byteCount: Int {
            bitCount / Self.charBit
        }

        public init<I: BinaryInteger>(byteCount: I) {
            self.init(rawValue: RawValue(byteCount) * 8)
        }

        public init<I: BinaryInteger>(bitCount: I) {
            self.init(rawValue: RawValue(bitCount))
        }

        public init(rawValue: RawValue) {
            self.rawValue = rawValue
        }
    }
}

extension Sodium.DataSize {
    public static var bits128: Self {
        return self.init(bitCount: 128)
    }

    public static var bits192: Self {
        return self.init(bitCount: 192)
    }

    public static var bits256: Self {
        return self.init(bitCount: 256)
    }
}

extension Sodium.DataSize: RawRepresentable {
    public typealias RawValue = UInt16
}

extension Sodium.DataSize: AdditiveArithmetic {
    public static func + (lhs: Sodium.DataSize, rhs: Sodium.DataSize) -> Sodium.DataSize {
        .init(bitCount: lhs.rawValue + rhs.rawValue)
    }

    public static func - (lhs: Sodium.DataSize, rhs: Sodium.DataSize) -> Sodium.DataSize {
        .init(bitCount: lhs.rawValue - rhs.rawValue)
    }
}

extension Sodium.DataSize: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = RawValue

    public init(integerLiteral value: IntegerLiteralType) {
        self.init(rawValue: value)
    }
}

extension Sodium.DataSize: Numeric {
    public static func * (lhs: Sodium.DataSize, rhs: Sodium.DataSize) -> Sodium.DataSize {
        .init(rawValue: lhs.rawValue * rhs.rawValue)
    }

    public static func *= (lhs: inout Sodium.DataSize, rhs: Sodium.DataSize) {
        lhs.rawValue *= rhs.rawValue
    }

    public var magnitude: RawValue.Magnitude {
        rawValue.magnitude
    }

    public init?<T>(exactly source: T) where T : BinaryInteger {
        guard let source = RawValue(exactly: source) else { return nil }
        self.init(rawValue: source)
    }
}

extension Sodium.DataSize: BinaryInteger {
    public typealias Words = RawValue.Words

    public static var isSigned: Bool {
        RawValue.isSigned
    }

    public static func <<= <RHS>(lhs: inout Sodium.DataSize, rhs: RHS) where RHS : BinaryInteger {
        lhs.rawValue <<= rhs
    }
    
    public static func >>= <RHS>(lhs: inout Sodium.DataSize, rhs: RHS) where RHS : BinaryInteger {
        lhs.rawValue >>= rhs
    }
    
    public static prefix func ~ (x: Sodium.DataSize) -> Sodium.DataSize {
        .init(rawValue: ~x.rawValue)
    }

    public static func / (lhs: Sodium.DataSize, rhs: Sodium.DataSize) -> Sodium.DataSize {
        .init(rawValue: lhs.rawValue / rhs.rawValue)
    }

    public static func % (lhs: Sodium.DataSize, rhs: Sodium.DataSize) -> Sodium.DataSize {
        .init(rawValue: lhs.rawValue % rhs.rawValue)
    }

    public static func %= (lhs: inout Sodium.DataSize, rhs: Sodium.DataSize) {
        lhs.rawValue %= rhs.rawValue
    }

    public static func &= (lhs: inout Sodium.DataSize, rhs: Sodium.DataSize) {
        lhs.rawValue &= rhs.rawValue
    }

    public static func |= (lhs: inout Sodium.DataSize, rhs: Sodium.DataSize) {
        lhs.rawValue |= rhs.rawValue
    }

    public static func ^= (lhs: inout Sodium.DataSize, rhs: Sodium.DataSize) {
        lhs.rawValue ^= rhs.rawValue
    }

    public static func /= (lhs: inout Sodium.DataSize, rhs: Sodium.DataSize) {
        lhs.rawValue /= rhs.rawValue
    }
    
    public init?<T>(exactly source: T) where T : BinaryFloatingPoint {
        guard let source = RawValue(exactly: source) else { return nil }
        self.init(rawValue: source)
    }
    
    public init<T>(_ source: T) where T : BinaryFloatingPoint {
        self.init(rawValue: RawValue(source))
    }

    public init<T>(_ source: T) where T : BinaryInteger {
        self.init(rawValue: RawValue(source))
    }

    public init<T>(clamping source: T) where T : BinaryInteger {
        self.init(rawValue: RawValue(clamping: source))
    }

    public init<T>(truncatingIfNeeded source: T) where T : BinaryInteger {
        self.init(rawValue: RawValue(truncatingIfNeeded: source))
    }

    public var bitWidth: Int {
        rawValue.bitWidth
    }
    
    public var trailingZeroBitCount: Int {
        rawValue.trailingZeroBitCount
    }

    public var words: RawValue.Words {
        rawValue.words
    }
}
