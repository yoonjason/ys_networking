import XCTest
@testable import ys_networking


final class ys_networkingTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(ys_networking().text, "Hello, World!")
        test()
//        XCTAssertEqual(NetworkManager.shared.test(), "pubic")
    }
    
    func test() {
        NetworkManager.shared.test()
    }
    
}
