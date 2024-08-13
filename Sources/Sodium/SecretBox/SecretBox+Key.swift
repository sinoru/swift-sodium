//
//  SecretBox.swift
//
//
//  Created by Jaehong Kang on 8/13/24.
//

import Clibsodium

extension SecretBox {
    public struct Key {
        public let keyData: [UInt8]

        public init(
            keyData: [UInt8]
        ) {
            self.keyData = keyData
        }

        public init() {
            let keyData = Array<UInt8>.init(
                unsafeUninitializedCapacity: Cipher.secretBoxKeySize
            ) { buffer, initializedCount in
                randombytes_buf(
                    buffer.baseAddress!,
                    Cipher.secretBoxKeySize

                )
                initializedCount = Cipher.secretBoxKeySize
            }
            self.keyData = keyData
        }
    }
}

extension SecretBox.Key: RawRepresentable {
    public typealias RawValue = Sodium.Data

    public var rawValue: any RawValue {
        keyData
    }

    public init?(rawValue: any RawValue) {
        self.init(keyData: .init(rawValue))
    }
}
