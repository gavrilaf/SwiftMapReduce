import Foundation

extension Collection {
    public func mapReduce<V, T>(mapper: @escaping (Self.SubSequence) -> V, reducer: ([V]) -> T, flows: Int) -> T {
        let split = self.split(on: flows)
        
        var results = Array<V?>(repeating: nil, count: flows)
        let group = DispatchGroup()
        
        let queue = DispatchQueue(label: "map-reduce-queue", qos: .userInteractive, attributes: [.concurrent])
        
        let mapBlock: (Self.SubSequence, Int) -> Void = { (sub, indx) in
            group.enter()
            queue.async(group: group) {
                results[indx] = mapper(sub)
                group.leave()
            }
        }
        
        split.enumerated().forEach { (indx, sub) in
            mapBlock(sub, indx)
        }
        
        group.wait()
        
        // Reduce
        return reducer(results.compactMap { $0 })
    }
}
