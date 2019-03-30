import Foundation
import SwiftPerfTool
import MapReduceAlgo

func readArray(_ fn: String) -> [Int] {
    print("Open file")
    let data = try! String(contentsOfFile: fn, encoding: .ascii)
    print("Splitting by lines")
    let lines = data.components(separatedBy: .newlines)
    return lines.compactMap { Int($0) }
}


func testHistogramPerformance() {
    let n = 10000000
    
    print("Test histogram performance")
    
    print("Generate test data")
    let arr = (1...n).map { _ in Int.random(in: 1...5) }.shuffled()
    
    var expected: [Int: Int] = [:]
    arr.forEach { expected[$0] = 1 }
    
    func runHistogram(name: String, calc: @escaping () -> [Int: Int]) {
        print("\(name) - started")
        var hist: [Int: Int] = [:]
        let metrics = runMeasure(with: SPTConfig(iterations: 1, trials: [{ hist = calc() }] ))
        print("\(name) done. Correct = \(expected == hist), time = \(metrics.timeMean)")
    }
    
    runHistogram(name: "Singe thread", calc: { return arr.histogram() })
    runHistogram(name: "2 threads", calc: { return arr.histogramPar(flows: 2) })
    runHistogram(name: "4 threads", calc: { return arr.histogramPar(flows: 4) })
    runHistogram(name: "8 threads", calc: { return arr.histogramPar(flows: 8) })
    runHistogram(name: "16 threads", calc: { return arr.histogramPar(flows: 16) })
}

func testCountPerformance() {
    let n = 10000000
    
    print("Test count performance")
    
    print("Generate test data")
    let arr = (1...n).map { _ in Int.random(in: 1...5) }.shuffled()
    
    let expected = arr.filter { $0 == 2 }.count
    
    func runCount(name: String, calc: @escaping () -> Int) {
        print("\(name) - started")
        var count: Int = -1
        let metrics = runMeasure(with: SPTConfig(iterations: 1, trials: [{ count = calc() }] ))
        print("\(name) done. Correct = \(expected == count), time = \(metrics.timeMean)")
    }
    
    runCount(name: "Singe thread", calc: { return arr.count(where: { $0 == 2 }) })
    runCount(name: "2 threads", calc: { return arr.countPar(where: { $0 == 2 }, flows: 2) })
    runCount(name: "4 threads", calc: { return arr.countPar(where: { $0 == 2 }, flows: 4) })
    runCount(name: "8 threads", calc: { return arr.countPar(where: { $0 == 2 }, flows: 8) })
    runCount(name: "16 threads", calc: { return arr.countPar(where: { $0 == 2 }, flows: 16) })
}

func testSumsCounterPerformance() {
    let fn = "../../../test-data/two-sum/test/input_random_49_40000.txt"
    
    print("testSumsCounterPerformance: \(fn)")
    
    let arr = readArray(fn)
    let range = -10000...10000
    
    print("Array prepared")
    
    let testCases = [1, 2, 4, 8, 16, 32]
    
    for flows in testCases {
        if flows == 1 {
            var count = 0
            let metrics = runMeasure(with: SPTConfig(iterations: 1, trials: [{ count = SumsCounter.count(for: arr, in: range)}] ))
            print("Singe thread version done. Count = \(count), time = \(metrics.timeMean)")
        } else {
            var count = 0
            let metrics = runMeasure(with: SPTConfig(iterations: 1, trials: [{ count = SumsCounter.countPar(for: arr, in: range, flows: flows)}] ))
            print("\(flows) threads version done. Count = \(count), time = \(metrics.timeMean)")
        }
    }
}


print("MapReduceRunner")

testHistogramPerformance()
testCountPerformance()
testSumsCounterPerformance()
