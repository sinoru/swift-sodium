//
//  XChaCha20Poly1305+SecretBoxCipher.swift
//
//
//  Created by Jaehong Kang on 8/13/24.
//

import Clibsodium

extension XChaCha20Poly1305: SecretBoxCipher {
    public static var secretBoxKeySize: Sodium.DataSize {
        .init(byteCount: crypto_secretbox_xchacha20poly1305_KEYBYTES)
    }

    public static var secretBoxNonceSize: Sodium.DataSize {
        .init(byteCount: crypto_secretbox_xchacha20poly1305_NONCEBYTES)
    }

    public static var secretBoxMACSize: Sodium.DataSize {
        .init(byteCount: crypto_secretbox_xchacha20poly1305_MACBYTES)
    }

    public static func secretBoxGenerateKey() -> Sodium.Data {
        Sodium.Data(
            unsafeUninitializedCapacity: Self.secretBoxKeySize.byteCount
        ) { buffer, initializedCount in
            crypto_secretbox_xsalsa20poly1305_keygen(buffer.baseAddress!)
            initializedCount = Self.secretBoxKeySize.byteCount
        }
    }

    public func secretBoxSeal(
        _ data: Sodium.Data,
        key: Sodium.Data,
        nonce: Sodium.Data
    ) throws -> Sodium.Data {
        let estimatedCount = Self.secretBoxMACSize.byteCount + data.count

        return try Sodium.Data(
            unsafeUninitializedCapacity: estimatedCount
        ) { buffer, initializedCount in
            let result = crypto_secretbox_xchacha20poly1305_easy(
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

    public func secretBoxOpen(
        _ data: Sodium.Data,
        key: Sodium.Data,
        nonce: Sodium.Data
    ) throws -> Sodium.Data {
        let estimatedCount = data.count - Self.secretBoxMACSize.byteCount

        return try Sodium.Data(
            unsafeUninitializedCapacity: estimatedCount
        ) { buffer, initializedCount in
            let result = crypto_secretbox_xchacha20poly1305_open_easy(
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
