//
//  SecretBoxCipher.swift
//
//
//  Created by Jaehong Kang on 8/13/24.
//

public protocol SecretBoxCipher: Sodium.AEADCipher {
    static var secretBoxKeySize: Int { get }
    static var secretBoxNonceSize: Int { get }
    static var secretBoxMACSize: Int { get }

    static func secretBoxGenerateKey() -> [UInt8]
    func secretBoxSeal(_ data: [UInt8], key: [UInt8], nonce: [UInt8]) throws -> [UInt8]
    func secretBoxOpen(_ data: [UInt8], key: [UInt8], nonce: [UInt8]) throws -> [UInt8]
}
