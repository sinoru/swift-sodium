//
//  SodiumTests+DataProtocol_Base64.swift
//
//
//  Created by Jaehong Kang on 8/12/24.
//

import XCTest
@testable import SodiumCore

extension SodiumTests {
    func testBase64ToBinary() throws {
        let data: [UInt8] = Array("Hello, World!".utf8)

        self.measure {
            XCTAssertEqual(
                data.base64EncodedString(addingPercentEncoding: false, padding: true),
                "SGVsbG8sIFdvcmxkIQ=="
            )
        }
    }

    func testBinaryToBase64() throws {
        let base64 = "SGVsbG8sIFdvcmxkIQ=="

        XCTAssertEqual(
            try Array(base64Encoded: base64, removingPercentEncoding: false, padding: true),
            Array("Hello, World!".utf8)
        )
    }
}
