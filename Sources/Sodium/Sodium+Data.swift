//
//  Sodium+Data.swift
//
//
//  Created by Jaehong Kang on 8/13/24.
//

extension Sodium {
    public protocol Data: Collection, Equatable, Hashable, Sendable where Element == UInt8 {
        associatedtype Element

        init<S: Sequence>(_ elements: S) where S.Element == Element
    }
}

extension Array: Sodium.Data where Element == UInt8 { }
extension ArraySlice: Sodium.Data where Element == UInt8 { }
extension ContiguousArray: Sodium.Data where Element == UInt8 { }
