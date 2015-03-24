
import Foundation

extension Array {
    func randomElement() -> T {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}