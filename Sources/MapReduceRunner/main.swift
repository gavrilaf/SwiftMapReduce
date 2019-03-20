import Foundation
import SwiftPerfTool
import MapReduceAlgo

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
}

func testCountPerformance() {
    let n = 100000000
    
    print("Test histogram performance")
    
    print("Generate test data")
    let arr = (1...n).map { _ in Int.random(in: 1...5) }.shuffled()
    
    let expected = arr.filter { $0 == 2 }.count
    
    func runCount(name: String, calc: @escaping () -> Int) {
        print("\(name) - started")
        var count: Int = -1
        let metrics = runMeasure(with: SPTConfig(iterations: 1, trials: [{ count = calc() }] ))
        print("\(name) done. Correct = \(expected == count), time = \(metrics.timeMean)")
    }
    
    runCount(name: "Singe thread", calc: { return arr.count(where: { $0 == 2 }, flows: 2) })
    runCount(name: "2 threads", calc: { return arr.count(where: { $0 == 2 }, flows: 2) })
    runCount(name: "4 threads", calc: { return arr.count(where: { $0 == 2 }, flows: 4) })
    runCount(name: "8 threads", calc: { return arr.count(where: { $0 == 2 }, flows: 8) })
}


print("MapReduceRunner")

//testHistogramPerformance()
testCountPerformance()
