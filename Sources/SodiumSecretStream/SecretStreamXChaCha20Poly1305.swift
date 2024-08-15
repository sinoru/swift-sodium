//
//  SecretStreamCipher+XChaCha20Poly1305.swift
//
//
//  Created by Jaehong Kang on 8/13/24.
//

import protocol SodiumCore.XChaCha20Poly1305
import Clibsodium

public struct SecretStreamXChaCha20Poly1305: SodiumCore.XChaCha20Poly1305, SecretStreamCipher {
    public enum Tag: SecretStreamTag {
        case message
        case final
        case push
        case rekey
    }

    public static var keySize: DataSize {
        .init(byteCount: crypto_secretstream_xchacha20poly1305_KEYBYTES)
    }

    public static var headerSize: DataSize {
        .init(byteCount: crypto_secretstream_xchacha20poly1305_HEADERBYTES)
    }

    public static func generateKey() -> Sodium.Data {
        Sodium.Data(
            unsafeUninitializedCapacity: Self.keySize.byteCount
        ) { buffer, initializedCount in
            crypto_secretstream_xchacha20poly1305_keygen(
                buffer.baseAddress!
            )
            initializedCount = Self.keySize.byteCount
        }
    }

    private var state: crypto_secretstream_xchacha20poly1305_state

    public init(
        key: SodiumCore.Sodium.Data,
        header: inout SodiumCore.Sodium.Data
    ) {
        var state: crypto_secretstream_xchacha20poly1305_state = .init()
        let newHeader = Array<UInt8>(
            unsafeUninitializedCapacity: Self.headerSize.byteCount
        ) { buffer, initializedCount in
            crypto_secretstream_xchacha20poly1305_init_push(
                &state,
                buffer.baseAddress!,
                key
            )
            initializedCount = Self.headerSize.byteCount
        }

        self.state = state

        header = newHeader
    }

    public init(
        key: SodiumCore.Sodium.Data,
        header: SodiumCore.Sodium.Data
    ) {
        var state: crypto_secretstream_xchacha20poly1305_state = .init()

        crypto_secretstream_xchacha20poly1305_init_pull(
            &state,
            header,
            key
        )

        self.state = state
    }

    public mutating func push(
        _ message: SodiumCore.Sodium.Data,
        additionalData: SodiumCore.Sodium.Data?,
        tag: Tag
    ) throws -> SodiumCore.Sodium.Data {
        let estimatedCount = message.count + Int(crypto_secretstream_xchacha20poly1305_ABYTES)

        return try Sodium.Data(
            unsafeUninitializedCapacity: estimatedCount
        ) { buffer, initializedCount in
            var byteCount: UInt64 = 0

            let result = crypto_secretstream_xchacha20poly1305_push(
                &self.state,
                buffer.baseAddress!,
                &byteCount,
                message,
                UInt64(message.count),
                additionalData,
                UInt64(additionalData?.count ?? 0),
                tag.rawValue
            )

            guard result == 0 else {
                throw Sodium.Error.invalidMessageLength
            }

            initializedCount = Int(byteCount)
        }
    }

    public mutating func pull(
        _ data: Sodium.Data,
        additionalData: Sodium.Data?
    ) throws -> (message: Sodium.Data, tag: Tag) {
        let estimatedCount = data.count - Int(crypto_secretstream_xchacha20poly1305_ABYTES)

        var tag: UInt8 = 0
        let message = try Sodium.Data(
            unsafeUninitializedCapacity: estimatedCount
        ) { buffer, initializedCount in
            var byteCount: UInt64 = 0

            let result = crypto_secretstream_xchacha20poly1305_pull(
                &self.state,
                buffer.baseAddress!,
                &byteCount,
                &tag,
                data,
                UInt64(data.count),
                additionalData,
                UInt64(additionalData?.count ?? 0)
            )

            guard result == 0 else {
                throw Sodium.Error.invalidMessageLength
            }

            initializedCount = Int(byteCount)
        }

        guard let tag = Tag(rawValue: tag) else {
            throw Sodium.Error.unknown
        }

        return (message: message, tag: tag)
    }
}

extension XChaCha20Poly1305.Tag: RawRepresentable {
    public typealias RawValue = UInt8

    public init?(rawValue: UInt8) {
        switch rawValue {
        case UInt8(crypto_secretstream_xchacha20poly1305_TAG_MESSAGE):
            self = .message
        case UInt8(crypto_secretstream_xchacha20poly1305_TAG_FINAL):
            self = .final
        case UInt8(crypto_secretstream_xchacha20poly1305_TAG_PUSH):
            self = .push
        case UInt8(crypto_secretstream_xchacha20poly1305_TAG_REKEY):
            self = .rekey
        default:
            return nil
        }
    }

    public var rawValue: UInt8 {
        switch self {
        case .message:
            UInt8(crypto_secretstream_xchacha20poly1305_TAG_MESSAGE)
        case .final:
            UInt8(crypto_secretstream_xchacha20poly1305_TAG_FINAL)
        case .push:
            UInt8(crypto_secretstream_xchacha20poly1305_TAG_PUSH)
        case .rekey:
            UInt8(crypto_secretstream_xchacha20poly1305_TAG_REKEY)
        }
    }
}
