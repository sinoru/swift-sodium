//
//  SecretBoxCipher.swift
//
//
//  Created by Jaehong Kang on 8/13/24.
//

import Clibsodium

public protocol SecretBoxCipher: AEADCipher {
    static var keySize: DataSize { get }
    static var nonceSize: DataSize { get }
    static var macSize: DataSize { get }

    static func generateKey() -> Sodium.Data

    init()

    func seal(
        _ data: Sodium.Data,
        key: Sodium.Data,
        nonce: Sodium.Data
    ) throws -> Sodium.Data

    func open(
        _ data: Sodium.Data,
        key: Sodium.Data,
        nonce: Sodium.Data
    ) throws -> Sodium.Data
}
