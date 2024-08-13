//
//  SecretBoxTests.swift
//  
//
//  Created by Jaehong Kang on 8/13/24.
//

import XCTest
@testable import Sodium

final class SecretBoxTests: XCTestCase {
    func testXSalsa20Poly1305EncryptAndDecrypt() throws {
        let secretBox = try SecretBox<XSalsa20Poly1305>()
        let originalData = Array("text".utf8)
        let encryptedData = try secretBox.encrypt(Array("text".utf8))
        let decryptedData = try secretBox.decrypt(encryptedData.data, nonce: encryptedData.nonce)

        XCTAssertEqual(originalData, decryptedData)
    }

    func testXChaCha20Poly1305EncryptAndDecrypt() throws {
        let secretBox = try SecretBox<XChaCha20Poly1305>()
        let originalData = Array("text".utf8)
        let encryptedData = try secretBox.encrypt(Array("text".utf8))
        let decryptedData = try secretBox.decrypt(encryptedData.data, nonce: encryptedData.nonce)

        XCTAssertEqual(originalData, decryptedData)
    }
}
