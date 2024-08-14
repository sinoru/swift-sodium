//
//  XSalsa20Poly1305+SecretBox.swift
//
//
//  Created by Jaehong Kang on 8/13/24.
//

import Clibsodium

extension XSalsa20Poly1305: SecretBoxCipher {
    public static var secretBoxKeySize: Sodium.DataSize {
        .init(byteCount: crypto_secretbox_xsalsa20poly1305_KEYBYTES)
    }

    public static var secretBoxNonceSize: Sodium.DataSize {
        .init(byteCount: crypto_secretbox_xsalsa20poly1305_NONCEBYTES)
    }

    public static var secretBoxMACSize: Sodium.DataSize {
        .init(byteCount: crypto_secretbox_xsalsa20poly1305_MACBYTES)
    }
    public static func secretBoxGenerateKey() -> [UInt8] {
        Array<UInt8>.init(
            unsafeUninitializedCapacity: Self.secretBoxKeySize.byteCount
        ) { buffer, initializedCount in
            crypto_secretbox_keygen(buffer.baseAddress!)
            initializedCount = Self.secretBoxKeySize.byteCount
        }
    }

    public func secretBoxSeal(_ data: [UInt8], key: [UInt8], nonce: [UInt8]) throws -> [UInt8] {
        let estimatedCount = Self.secretBoxMACSize.byteCount + data.count

        return try Array<UInt8>(
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
    }

    public func secretBoxOpen(_ data: [UInt8], key: [UInt8], nonce: [UInt8]) throws -> [UInt8] {
        let estimatedCount = data.count - Self.secretBoxMACSize.byteCount

        return try Array<UInt8>(
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
    }
}
