import MapReduce

extension Collection where Element: Hashable {
    
    public func count(where test: @escaping (Element) -> Bool, flows: Int = 2) -> Int {
        return self.reduce(0) { test($1) ? $0 + 1 : $0 }
    }
    
    public func countPar(where test: @escaping (Element) -> Bool, flows: Int = 2) -> Int {
        let mapper: (Self.SubSequence) -> Int = { (subs) in
            return subs.reduce(0) { test($1) ? $0 + 1 : $0 }
        }
        
        let reducer: ([Int]) -> Int = {
            return $0.reduce(0) { $0 + $1 }
        }
        
        return self.mapReduce(mapper: mapper, reducer: reducer, flows: flows)
    }
    
    public func histogram() -> [Element: Int] {
        return self.reduce(into: [:]) { counts, elem in counts[elem, default: 0] += 1 }
    }
    
    public func histogramPar(flows: Int = 2) -> [Element: Int] {
        let mapper: (Self.SubSequence) -> [Element: Int] = { (subs) in
            return subs.histogram()
        }
        
        let reducer: ([[Element: Int]]) -> [Element: Int] = { (parts) in
            guard var res = parts.first else {
                return [:]
            }
            
            for map in parts[1...] {
                for (key, value) in map {
                    res[key, default: 0] += value
                }
            }
            
            return res
        }
        
        return self.mapReduce(mapper: mapper, reducer: reducer, flows: flows)
    }
}
