//
//  SecretBoxTests.swift
//  
//
//  Created by Jaehong Kang on 8/13/24.
//

import XCTest
@testable import SodiumSecretBox

final class SecretBoxTests: XCTestCase {
    func testXSalsa20Poly1305EncryptAndDecrypt() throws {
        let secretBox = try SecretBox<SecretBoxXSalsa20Poly1305>()
        let originalData = Array("text".utf8)
        let encryptedData = try secretBox.seal(Array("text".utf8))
        let decryptedData = try secretBox.open(encryptedData.data, nonce: encryptedData.nonce)

        XCTAssertEqual(originalData, decryptedData)
    }

    func testXChaCha20Poly1305EncryptAndDecrypt() throws {
        let secretBox = try SecretBox<SecretBoxXChaCha20Poly1305>()
        let originalData = Array("text".utf8)
        let encryptedData = try secretBox.seal(Array("text".utf8))
        let decryptedData = try secretBox.open(encryptedData.data, nonce: encryptedData.nonce)

        XCTAssertEqual(originalData, decryptedData)
    }
}
