import UIKit

public extension NSLayoutConstraint {
    class func activate(_ constraints: [[NSLayoutConstraint]]) {
        NSLayoutConstraint.activate(constraints.flatMap { $0 })
    }

    func with(priority: Float) -> NSLayoutConstraint {
        self.priority = UILayoutPriority(priority)
        return self
    }
}
