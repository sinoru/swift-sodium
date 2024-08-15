//
//  SecretStreamTests.swift
//  
//
//  Created by Jaehong Kang on 8/15/24.
//

import XCTest
@testable import SodiumSecretStream

final class SecretStreamTests: XCTestCase {
    func testXChaCha20Poly1305EncryptAndDecrypt() throws {
        let messagePart1 = Array("Arbitrary data to encrypt".utf8)
        let messagePart2 = Array("split into".utf8)
        let messagePart3 = Array("three messages".utf8)


        var encryptionSecretStream = try SecretStream<XChaCha20Poly1305>()
        let cipherTextPart1 = try encryptionSecretStream.push(messagePart1)
        let cipherTextPart2 = try encryptionSecretStream.push(messagePart2)
        let cipherTextPart3 = try encryptionSecretStream.push(messagePart3, tag: .final)

        var decryptionSecretStream = SecretStream<XChaCha20Poly1305>(
            key: encryptionSecretStream.key,
            header: encryptionSecretStream.header
        )

        let decryptedMessagePart1 = try decryptionSecretStream.pull(cipherTextPart1)
        XCTAssertEqual(decryptedMessagePart1.tag, .message)
        XCTAssertEqual(decryptedMessagePart1.message, messagePart1)
        let decryptedMessagePart2 = try decryptionSecretStream.pull(cipherTextPart2)
        XCTAssertEqual(decryptedMessagePart2.tag, .message)
        XCTAssertEqual(decryptedMessagePart2.message, messagePart2)
        let decryptedMessagePart3 = try decryptionSecretStream.pull(cipherTextPart3)
        XCTAssertEqual(decryptedMessagePart3.tag, .final)
        XCTAssertEqual(decryptedMessagePart3.message, messagePart3)
    }
}
