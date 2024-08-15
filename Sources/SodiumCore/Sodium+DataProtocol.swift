//
//  Sodium+DataProtocol.swift
//
//
//  Created by Jaehong Kang on 8/15/24.
//

#if swift(>=5.10)
extension Sodium {
    public protocol DataProtocol: RandomAccessCollection, Sendable where Element == UInt8, Self.SubSequence: DataProtocol {
        init<S: Sequence>(_ elements: S) where S.Element == Element
    }
}
#else
public protocol SodiumDataProtocol: RandomAccessCollection, Sendable where Element == UInt8, Self.SubSequence: DataProtocol {
    init<S: Sequence>(_ elements: S) where S.Element == Element
}

extension Sodium {
    public typealias DataProtocol = SodiumDataProtocol
}
#endif

extension Sodium.DataProtocol {
    public var size: DataSize {
        .init(byteCount: count)
    }
}

extension Sodium.Data: Sodium.DataProtocol { }
extension ArraySlice: Sodium.DataProtocol where Element == UInt8 { }
extension ContiguousArray: Sodium.DataProtocol where Element == UInt8 { }
