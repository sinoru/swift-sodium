//
//  Sodium+DataProtocol.swift
//
//
//  Created by Jaehong Kang on 8/15/24.
//

extension Sodium {
    public protocol DataProtocol: RandomAccessCollection, Sendable where Element == UInt8, Self.SubSequence: DataProtocol {
        init<S: Sequence>(_ elements: S) where S.Element == Element
    }
}

extension Sodium.DataProtocol {
    public var size: Sodium.DataSize {
        .init(byteCount: count)
    }
}

extension Sodium.Data: Sodium.DataProtocol { }
extension ArraySlice: Sodium.DataProtocol where Element == UInt8 { }
extension ContiguousArray: Sodium.DataProtocol where Element == UInt8 { }
