//
//  SodiumTests+DataProtocol_Random.swift
//
//
//  Created by Jaehong Kang on 8/14/24.
//

import XCTest
@testable import SodiumCore

extension SodiumTests {
    func testRandom() throws {
        let randomSize = DataSize(byteCount: (1..<UInt8.max).randomElement()!)
        let randomData = Array<UInt8>.random(count: randomSize.byteCount)
        let emptyData = Array<UInt8>(repeating: 0, count: randomSize.byteCount)
        

        XCTAssertFalse(randomData.isEmpty)
        XCTAssertEqual(randomData.size, randomSize)
        XCTAssertNotEqual(randomData, emptyData)
        XCTAssertEqual(randomData.count, emptyData.count)
    }
}
