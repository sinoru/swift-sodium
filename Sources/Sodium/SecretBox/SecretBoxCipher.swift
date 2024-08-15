//
//  SecretBoxCipher.swift
//
//
//  Created by Jaehong Kang on 8/13/24.
//

public protocol SecretBoxCipher: Sodium.AEADCipher {
    static var secretBoxKeySize: Sodium.DataSize { get }
    static var secretBoxNonceSize: Sodium.DataSize { get }
    static var secretBoxMACSize: Sodium.DataSize { get }

    static func secretBoxGenerateKey() -> Sodium.Data

    func secretBoxSeal(
        _ data: Sodium.Data,
        key: Sodium.Data,
        nonce: Sodium.Data
    ) throws -> Sodium.Data

    func secretBoxOpen(
        _ data: Sodium.Data,
        key: Sodium.Data,
        nonce: Sodium.Data
    ) throws -> Sodium.Data
}
