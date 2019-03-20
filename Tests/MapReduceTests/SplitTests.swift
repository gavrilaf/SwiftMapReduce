import XCTest
import MapReduce

final class SplitTests: XCTestCase {
    
    func testSplitSeq() {
        let cases = [
            ([1, 2], 2, 0, [[1], [2]]),
            ([1, 2, 3], 2, 1, [[1], [2, 3]]),
            ([1, 2, 3, 4, 5], 2, 2, [[1, 2], [3, 4, 5]]),
            ([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 2, 0, [[1, 2, 3, 4, 5], [6, 7, 8, 9, 10]]),
            ([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 3, 0, [[1, 2, 3], [4, 5, 6], [7, 8, 9, 10]]),
            ([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 4, 0, [[1, 2], [3, 4], [5, 6], [7, 8, 9, 10]]),
        ]
        
        cases.forEach { (cs) in
            let split = cs.0.split(on: cs.1, minElements: cs.2).map { [Int]($0) }
            XCTAssertEqual(split, cs.3)
        }
    }
    
    func testSplitRange() {
        let cases = [
            (1...2, 2, 0, [1...1, 2...2]),
        ]
        
        cases.forEach { (cs) in
            let split = cs.0.split(on: cs.1, minElements: cs.2).map { $0.first!...$0.last! }
            XCTAssertEqual(split, cs.3)
        }
        
    }
    
    static var allTests = [
        ("testSplitSeq", testSplitSeq),
        ("testSplitRange", testSplitRange),
    ]
}

