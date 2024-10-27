import Foundation

class Debouncer {
    private var workItem: DispatchWorkItem?

    func debounce(delay: TimeInterval, action: @escaping () -> Void) {
        workItem?.cancel()
        workItem = DispatchWorkItem { action() }
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem!)
    }
}
