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
        _ data: some Sodium.Data
    ) throws -> (data: [UInt8], nonce: [UInt8]) {
        let nonce = Array<UInt8>.random(count: Cipher.secretBoxNonceSize.byteCount)
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
