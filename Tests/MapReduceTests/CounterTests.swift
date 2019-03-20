import XCTest
import MapReduce
import MapReduceAlgo

final class CounterTests: XCTestCase {
    
    let countCases = [
        ([1, 2], 2, 1),
        ([1, 2, 3, 4, 5, 6, 7], 2, 1),
        ([1, 1, 3, 4, 5, 6, 7], 2, 0),
        ([1, 1, 3, 4, 5, 6, 7, 87, 90, 101, 1, 1], 1, 4),
    ]
    
    let histogramCases = [
        ([1, 2], [1: 1, 2: 1]),
        ([1, 2, 3, 4, 5, 6, 7], [1: 1, 2: 1, 3: 1, 4: 1, 5: 1, 6: 1, 7: 1]),
        ([1, 1, 3, 7, 7, 7, 7, 87, 90, 90, 1, 1], [1: 4, 3: 1, 7: 4, 87: 1, 90: 2]),
        ([1, 1, 1, 1, 1, 1, 1, 1, 1, 1], [1: 10]),
    ]
    
    func testCount() {
        countCases.forEach { (tc) in
            let count = tc.0.count(where: { $0 == tc.1 })
            XCTAssertEqual(count, tc.2)
        }
    }
    
    func testCountPar() {
        countCases.forEach { (tc) in
            let count = tc.0.countPar(where: { $0 == tc.1 })
            XCTAssertEqual(count, tc.2)
        }
    }
    
    func testHistogram() {
        histogramCases.forEach { (tc) in
            let hist = tc.0.histogram()
            XCTAssertEqual(hist, tc.1)
        }
    }

    func testHistogramPar() {
        histogramCases.forEach { (tc) in
            let hist = tc.0.histogramPar()
            XCTAssertEqual(hist, tc.1)
        }
    }

    static var allTests = [
        ("testCount", testCount),
        ("testCountPar", testCountPar),
        ("testHistogram", testHistogram),
        ("testHistogramPar", testHistogramPar),
    ]
}
