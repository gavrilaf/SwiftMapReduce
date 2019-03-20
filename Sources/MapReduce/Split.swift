import Foundation

extension Collection {
    public func split(on parts: Int, minElements: Int = 1) -> [Self.SubSequence] {
        var bunchSize = self.count / parts
        if bunchSize < minElements {
            bunchSize = Swift.min(minElements, self.count)
        }
        //if bunchSize == 0 {
        //    bunchSize =
        //}
        
        var res = [Self.SubSequence]()
        
        var processed = 0
        var bunchStart = self.startIndex
        var bunchEnd = self.index(bunchStart, offsetBy: bunchSize)
        
        while processed < parts - 1{
            res.append(self[bunchStart..<bunchEnd])
            
            bunchStart = bunchEnd
            bunchEnd = self.index(bunchStart, offsetBy: bunchSize)
            
            processed += 1
            if processed == parts - 1 {
                res.append(self[bunchStart..<self.endIndex])
            }
        }
        
        return res
    }
}
