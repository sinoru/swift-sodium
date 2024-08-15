import XCTest
@testable import SodiumCore

final class SodiumTests: XCTestCase {
    func testInitialize() throws {
        try Sodium.initialize()
    }
}
