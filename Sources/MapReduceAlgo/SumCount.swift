import Foundation
import MapReduce

struct SumCount {
    
    func cnumbersSet(from numbers: [Int]) -> Dictionary<Int, Bool> {
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

}
