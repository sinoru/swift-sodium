//
//  SecretBox.swift
//
//
//  Created by Jaehong Kang on 8/13/24.
//

import Clibsodium

public struct SecretBox<Cipher: SecretBoxCipher> {
    public var keySize: Sodium.DataSize {
        Cipher.secretBoxKeySize
    }

    public var nonceSize: Sodium.DataSize {
        Cipher.secretBoxNonceSize
    }

    public let key: Sodium.SymmetricKey

    var cipher = Cipher()

    public init(
        key: Sodium.SymmetricKey = Sodium.SymmetricKey(
            keyData: Cipher.secretBoxGenerateKey()
        )
    ) throws {
        try Sodium.initialize()

        self.key = key
    }

    public func seal(
        _ data: some Sodium.DataProtocol
    ) throws -> (data: Sodium.Data, nonce: Sodium.Data) {
        let nonce = Sodium.Data.random(count: Cipher.secretBoxNonceSize.byteCount)
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
        try cipher.secretBoxSeal(.init(data), key: key.keyData, nonce: .init(nonce))
    }

    public func open(
        _ data: some Sodium.DataProtocol,
        nonce: some Sodium.DataProtocol
    ) throws -> Sodium.Data {
        try cipher.secretBoxOpen(.init(data), key: key.keyData, nonce: .init(nonce))
    }
}
