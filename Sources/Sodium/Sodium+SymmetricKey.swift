//
//  Sodium+SymmetricKey.swift
//
//
//  Created by Jaehong Kang on 8/14/24.
//

import Clibsodium

extension Sodium {
    public struct SymmetricKey {
        public let keyData: [UInt8]
        public var keySize: DataSize {
            keyData.size
        }

        public init(
            keyData: [UInt8]
        ) {
            self.keyData = keyData
        }

        public init(
            keySize: DataSize
        ) {
            self.keyData = Array<UInt8>.random(
                count: keySize.byteCount
            )
        }
    }
}

extension Sodium.SymmetricKey: RawRepresentable {
    public typealias RawValue = Sodium.Data

    public var rawValue: any RawValue {
        keyData
    }

    public init?(rawValue: any RawValue) {
        self.init(keyData: .init(rawValue))
    }
}
