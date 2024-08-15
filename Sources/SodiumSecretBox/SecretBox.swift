//
//  SecretBox.swift
//
//
//  Created by Jaehong Kang on 8/13/24.
//

import Clibsodium

public struct SecretBox<Cipher: SecretBoxCipher> {
    public var keySize: DataSize {
        Cipher.keySize
    }

    public var nonceSize: DataSize {
        Cipher.nonceSize
    }

    public let key: SymmetricKey

    let cipher = Cipher()

    public init(
        key: SymmetricKey = SymmetricKey(
            keyData: Cipher.generateKey()
        )
    ) throws {
        try Sodium.initialize()

        self.key = key
    }

    public func seal(
        _ data: some Sodium.DataProtocol
    ) throws -> (data: Sodium.Data, nonce: Sodium.Data) {
        let nonce = try Sodium.Data.random(count: Cipher.nonceSize.byteCount)
        let encryptedData = try seal(data, nonce: nonce)

        return (
            data: encryptedData,
            nonce: nonce
        )
    }

    public func seal(
        _ data: some Sodium.DataProtocol,
        nonce: some Sodium.DataProtocol
    ) throws -> Sodium.Data {
        try cipher.seal(.init(data), key: key.keyData, nonce: .init(nonce))
    }

    public func open(
        _ data: some Sodium.DataProtocol,
        nonce: some Sodium.DataProtocol
    ) throws -> Sodium.Data {
        try cipher.open(.init(data), key: key.keyData, nonce: .init(nonce))
    }
}
