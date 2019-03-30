import XCTest
import MapReduce
import MapReduceAlgo

final class SumsCounterTests: XCTestCase {
    let cases: [([Int], ClosedRange<Int>, Int)] = [
        ([-3, -1, 1, 2, 9, 11, 7, 6, 2], 3...10, 8),
        ([46099924748, -46099917034, 73636268024, 46099921372, 2190350483, -80066206438, 89786393815, 59624633529, 1178006368, -88867066418], -10000...10000, 2),
        ([-69862608803, 69862616154, 48620564995, -45198603494, 41984466390, -41984471698, -1504206991, 45198606864, 25388342383, -39635158643], -10000...10000, 3),
    ]
    
    func testCounter() {
        cases.forEach {
            let actual = SumsCounter.count(for: $0.0, in: $0.1)
            XCTAssertEqual(actual, $0.2)
        }
    }
    
    func testCounterMapReduce() {
        cases.forEach {
            let actual = SumsCounter.countPar(for: $0.0, in: $0.1)
            XCTAssertEqual(actual, $0.2)
        }
    }
    
    static var allTests = [
        ("testCounter", testCounter),
        ("testCounterMapReduce", testCounterMapReduce),
    ]
}
