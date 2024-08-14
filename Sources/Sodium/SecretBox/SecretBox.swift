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

    let cipher = Cipher()
    public let key: Sodium.SymmetricKey

    public init(
        key: Sodium.SymmetricKey = Sodium.SymmetricKey(
            keyData: Cipher.secretBoxGenerateKey()
        )
    ) throws {
        try Sodium.initialize()

        self.key = key
    }

    public func seal(
        _ data: some Sodium.Data
    ) throws -> (data: [UInt8], nonce: [UInt8]) {
        let nonce = [UInt8].random(count: Cipher.secretBoxNonceSize)
        let encryptedData = try seal(data, nonce: nonce)

        return (
            data: encryptedData,
            nonce: nonce
        )
    }

    public func seal(
        _ data: some Sodium.Data,
        nonce: some Sodium.Data
    ) throws -> [UInt8] {
        try cipher.secretBoxSeal(.init(data), key: key.keyData, nonce: .init(nonce))
    }

    public func open(
        _ data: some Sodium.Data,
        nonce: some Sodium.Data
    ) throws -> [UInt8] {
        try cipher.secretBoxOpen(.init(data), key: key.keyData, nonce: .init(nonce))
    }
}
