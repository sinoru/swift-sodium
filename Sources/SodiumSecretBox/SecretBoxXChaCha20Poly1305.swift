//
//  SecretBoxXChaCha20Poly1305.swift
//
//
//  Created by Jaehong Kang on 8/13/24.
//

import protocol SodiumCore.XChaCha20Poly1305
import Clibsodium

public struct SecretBoxXChaCha20Poly1305: SodiumCore.XChaCha20Poly1305, SecretBoxCipher {
    public static var keySize: DataSize {
        .init(byteCount: crypto_secretbox_xchacha20poly1305_KEYBYTES)
    }

    public static var nonceSize: DataSize {
        .init(byteCount: crypto_secretbox_xchacha20poly1305_NONCEBYTES)
    }

    public static var macSize: DataSize {
        .init(byteCount: crypto_secretbox_xchacha20poly1305_MACBYTES)
    }

    public static func generateKey() -> Sodium.Data {
        Sodium.Data(
            unsafeUninitializedCapacity: Self.keySize.byteCount
        ) { buffer, initializedCount in
            crypto_secretbox_xsalsa20poly1305_keygen(buffer.baseAddress!)
            initializedCount = Self.keySize.byteCount
        }
    }

    public init() { }

    public func seal(
        _ data: Sodium.Data,
        key: Sodium.Data,
        nonce: Sodium.Data
    ) throws -> Sodium.Data {
        let estimatedCount = Self.macSize.byteCount + data.count

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

    public func open(
        _ data: Sodium.Data,
        key: Sodium.Data,
        nonce: Sodium.Data
    ) throws -> Sodium.Data {
        let estimatedCount = data.count - Self.macSize.byteCount

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
