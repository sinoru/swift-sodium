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
            self.keyData = Cipher.secretBoxGenerateKey()
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
