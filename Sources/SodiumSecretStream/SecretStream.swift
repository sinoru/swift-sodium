//
//  SecretStream.swift
//
//
//  Created by Jaehong Kang on 8/13/24.
//

import Clibsodium

public struct SecretStream<Cipher: SecretStreamCipher> {
    public var keySize: DataSize {
        Cipher.keySize
    }

    public let key: SymmetricKey
    public let header: Sodium.Data

    var cipher: Cipher

    public init(
        key: SymmetricKey = SymmetricKey(
            keyData: Cipher.generateKey()
        )
    ) throws {
        try Sodium.initialize()

        self.key = key
        var header: Sodium.Data = []
        self.cipher = Cipher(
            key: key.keyData,
            header: &header
        )
        self.header = header
    }

    public init(
        key: SymmetricKey,
        header: Sodium.Data
    ) {
        self.key = key
        self.header = header
        self.cipher = Cipher(
            key: key.keyData,
            header: header
        )
    }

    public mutating func push(
        _ message: some Sodium.DataProtocol,
        additionalData: (some Sodium.DataProtocol)?,
        tag: Cipher.Tag = .message
    ) throws -> Sodium.Data {
        try cipher.push(
            .init(message),
            additionalData: additionalData.flatMap { Array($0) },
            tag: tag
        )
    }

    public mutating func push(
        _ message: some Sodium.DataProtocol,
        tag: Cipher.Tag = .message
    ) throws -> Sodium.Data {
        try self.push(
            message,
            additionalData: nil as Sodium.Data?,
            tag: tag
        )
    }

    public mutating func pull(
        _ data: some Sodium.DataProtocol,
        additionalData: (some Sodium.DataProtocol)?
    ) throws -> (message: Sodium.Data, tag: Cipher.Tag) {
        try cipher.pull(
            .init(data),
            additionalData: additionalData.flatMap { Array($0) }
        )
    }

    public mutating func pull(
        _ data: some Sodium.DataProtocol
    ) throws -> (message: Sodium.Data, tag: Cipher.Tag) {
        try self.pull(
            data,
            additionalData: nil as Sodium.Data?
        )
    }
}
