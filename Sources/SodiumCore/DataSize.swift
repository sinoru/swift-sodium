//
//  DataSize.swift
//
//
//  Created by Jaehong Kang on 8/14/24.
//

#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#elseif canImport(Musl)
import Musl
#elseif canImport(ucrt)
import ucrt
#else
#error("Unknown platform")
#endif

public struct DataSize: Equatable, Hashable, Sendable {
    private static let charBit: Int = Int(CHAR_BIT)
    public private(set) var rawValue: UInt16

    public var bitCount: Int {
        Int(rawValue)
    }

    public var byteCount: Int {
        bitCount / Self.charBit
    }

    public init<I: BinaryInteger>(byteCount: I) {
        self.init(rawValue: RawValue(byteCount) * RawValue(Self.charBit))
    }

    public init<I: BinaryInteger>(bitCount: I) {
        self.init(rawValue: RawValue(bitCount))
    }

    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }

    internal init?(rawValue: RawValue?) {
        guard let rawValue else { return nil }
        self.rawValue = rawValue
    }
}

extension DataSize {
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

extension DataSize: RawRepresentable {
    public typealias RawValue = UInt16
}

extension DataSize: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

extension DataSize: AdditiveArithmetic {
    public static func + (lhs: Self, rhs: Self) -> Self {
        .init(rawValue: lhs.rawValue + rhs.rawValue)
    }

    public static func - (lhs: Self, rhs: Self) -> Self {
        .init(rawValue: lhs.rawValue - rhs.rawValue)
    }
}

extension DataSize: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = RawValue

    public init(integerLiteral value: IntegerLiteralType) {
        self.init(rawValue: value)
    }
}

extension DataSize: Numeric {
    public static func * (lhs: Self, rhs: Self) -> Self {
        .init(rawValue: lhs.rawValue * rhs.rawValue)
    }

    public static func *= (lhs: inout Self, rhs: Self) {
        lhs.rawValue *= rhs.rawValue
    }

    public var magnitude: RawValue.Magnitude {
        rawValue.magnitude
    }

    public init?<T>(exactly source: T) where T : BinaryInteger {
        self.init(rawValue: RawValue(exactly: source))
    }
}

extension DataSize: BinaryInteger {
    public typealias Words = RawValue.Words

    public static var isSigned: Bool {
        RawValue.isSigned
    }

    public static func <<= <RHS>(lhs: inout Self, rhs: RHS) where RHS : BinaryInteger {
        lhs.rawValue <<= rhs
    }
    
    public static func >>= <RHS>(lhs: inout Self, rhs: RHS) where RHS : BinaryInteger {
        lhs.rawValue >>= rhs
    }
    
    public static prefix func ~ (x: Self) -> Self {
        .init(rawValue: ~x.rawValue)
    }

    public static func / (lhs: Self, rhs: Self) -> Self {
        .init(rawValue: lhs.rawValue / rhs.rawValue)
    }

    public static func % (lhs: Self, rhs: Self) -> Self {
        .init(rawValue: lhs.rawValue % rhs.rawValue)
    }

    public static func %= (lhs: inout Self, rhs: Self) {
        lhs.rawValue %= rhs.rawValue
    }

    public static func &= (lhs: inout Self, rhs: Self) {
        lhs.rawValue &= rhs.rawValue
    }

    public static func |= (lhs: inout Self, rhs: Self) {
        lhs.rawValue |= rhs.rawValue
    }

    public static func ^= (lhs: inout Self, rhs: Self) {
        lhs.rawValue ^= rhs.rawValue
    }

    public static func /= (lhs: inout Self, rhs: Self) {
        lhs.rawValue /= rhs.rawValue
    }
    
    public init?<T>(exactly source: T) where T : BinaryFloatingPoint {
        self.init(rawValue: RawValue(exactly: source))
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
