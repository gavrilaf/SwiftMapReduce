import Foundation
import MapReduce

/*
 *
 */

public struct SumsCounter {
    
    public static func count(for numbers: [Int], in range: ClosedRange<Int>) -> Int {
        let map = numbersSet(from: numbers)
        return sumCountWithMap(map, numbers: numbers, in: range)
    }
    
    public static func countPar(for numbers: [Int], in range: ClosedRange<Int>, flows: Int = 2) -> Int {
        let map = numbersSet(from: numbers)

        let mapper: (Slice<ClosedRange<Int>>) -> Int = {
            let r: ClosedRange<Int> = $0.first!...$0.last!
            let rangeCount = sumCountWithMap(map, numbers: numbers, in: r)
            return rangeCount
        }
        
        let reducer: ([Int]) -> Int = {
            return $0.reduce(0) { $0 + $1 }
        }
        
        return range.mapReduce(mapper: mapper, reducer: reducer, flows: flows)
    }

    // MARK: - Internal
    static func numbersSet(from numbers: [Int]) -> Dictionary<Int, Bool> {
        var map = Dictionary<Int, Bool>()
        numbers.forEach {
            if let v = map[$0], v == false {
                map[$0] = true // dublicate
            } else {
                map[$0] = false
            }
        }
        
        return map
    }
    
    static func sumCountWithMap(_ map: Dictionary<Int, Bool>, numbers: [Int], in range: ClosedRange<Int>) -> Int {
        var count = 0
        for t in range {
            var found = false
            for num in numbers {
                let diff = t - num
                if let duplicateExists = map[diff] {
                    if diff != num || (diff == num && duplicateExists) {
                        found = true
                        break
                    }
                }
            }
            
            if found {
                count += 1
            }
        }
        
        return count
    }
}
