import XCTest
@testable import Sodium

final class SodiumTests: XCTestCase {
    func testInitialize() throws {
        try Sodium.initialize()
    }
}
