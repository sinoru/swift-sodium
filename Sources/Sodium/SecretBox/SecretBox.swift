//
//  SecretBox.swift
//
//
//  Created by Jaehong Kang on 8/13/24.
//

import Clibsodium

public struct SecretBox<Cipher: SecretBoxCipher> {
    public var nonceSize: Int {
        Cipher.secretBoxNonceSize
    }

    public let key: Key

    public init(key: Key = .init()) throws {
        try Sodium.initialize()

        self.key = key
    }

    public func encrypt(
        _ data: some Sodium.Data
    ) throws -> (data: [UInt8], nonce: [UInt8]) {
        let nonce = [UInt8].random(count: Cipher.secretBoxNonceSize)
        let encryptedData = try encrypt(data, nonce: nonce)

        return (
            data: encryptedData,
            nonce: nonce
        )
    }

    public func encrypt(
        _ data: some Sodium.Data,
        nonce: some Sodium.Data
    ) throws -> [UInt8] {
        try Cipher.secretBoxEncrypt(.init(data), key: key.keyData, nonce: .init(nonce))
    }

    public func decrypt(
        _ data: some Sodium.Data,
        nonce: some Sodium.Data
    ) throws -> [UInt8] {
        try Cipher.secretBoxDecrypt(.init(data), key: key.keyData, nonce: .init(nonce))
    }
}
