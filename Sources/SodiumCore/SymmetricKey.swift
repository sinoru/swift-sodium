//
//  Sodium+SymmetricKey.swift
//
//
//  Created by Jaehong Kang on 8/14/24.
//

public struct SymmetricKey {
    public let keyData: Sodium.Data
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
        self.keyData = Sodium.Data.random(
            count: keySize.byteCount
        )
    }
}

extension SymmetricKey: RawRepresentable {
    public typealias RawValue = Sodium.Data

    public var rawValue: RawValue {
        keyData
    }

    public init?(rawValue: RawValue) {
        self.init(keyData: .init(rawValue))
    }
}
