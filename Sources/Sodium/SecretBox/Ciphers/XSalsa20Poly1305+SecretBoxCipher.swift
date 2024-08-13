//
//  XSalsa20Poly1305+SecretBox.swift
//
//
//  Created by Jaehong Kang on 8/13/24.
//

import Clibsodium

extension XSalsa20Poly1305: SecretBoxCipher {
    public static var secretBoxKeySize: Int {
        Int(crypto_secretbox_xsalsa20poly1305_KEYBYTES)
    }

    public static var secretBoxNonceSize: Int {
        Int(crypto_secretbox_xsalsa20poly1305_NONCEBYTES)
    }

    public static var secretBoxMACSize: Int {
        Int(crypto_secretbox_xsalsa20poly1305_MACBYTES)
    }

    public static func _encrypt(_ data: [UInt8], key: [UInt8], nonce: [UInt8]) throws -> [UInt8] {
        let estimatedCount = secretBoxMACSize + data.count

        let encryptedData = try Array<UInt8>(
            unsafeUninitializedCapacity: estimatedCount
        ) { buffer, initializedCount in
            let result = crypto_secretbox_easy(
                buffer.baseAddress!,
                data,
                UInt64(data.count),
                nonce,
                key
            )

            guard result == 0 else {
                throw Sodium.Error.invalidMessageLength
            }

            initializedCount = estimatedCount
        }

        return Array(encryptedData)
    }

    public static func _decrypt(_ data: [UInt8], key: [UInt8], nonce: [UInt8]) throws -> [UInt8] {
        let estimatedCount = data.count - secretBoxMACSize

        let decryptedData = try Array<UInt8>(
            unsafeUninitializedCapacity: estimatedCount
        ) { buffer, initializedCount in
            let result = crypto_secretbox_open_easy(
                buffer.baseAddress!,
                data,
                UInt64(data.count),
                nonce,
                key
            )

            guard result == 0 else {
                throw Sodium.Error.invalidData
            }

            initializedCount = estimatedCount
        }

        return Array(decryptedData)
    }
}