//
//  SecretStreamCipher.swift
//
//
//  Created by Jaehong Kang on 8/13/24.
//

public protocol SecretStreamCipher: AEADCipher {
    associatedtype Tag: SecretStreamTag where Tag.RawValue == UInt8

    static var keySize: DataSize { get }
    static var headerSize: DataSize { get }

    static func generateKey() -> Sodium.Data
    
    init(
        key: Sodium.Data,
        header: inout Sodium.Data
    )

    init(
        key: Sodium.Data,
        header: Sodium.Data
    )

    mutating func push(
        _ message: Sodium.Data,
        additionalData: Sodium.Data?,
        tag: Tag
    ) throws -> Sodium.Data

    mutating func pull(
        _ data: Sodium.Data,
        additionalData: Sodium.Data?
    ) throws -> (message: Sodium.Data, tag: Tag)
}
