import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(CounterTests.allTests),
        testCase(SplitTests.allTests),
    ]
}
#endif
