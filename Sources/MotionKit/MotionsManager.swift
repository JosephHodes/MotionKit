import Foundation

@available(iOS 13.0.0, *)
public class MotionsManagerService {
    private var cachedMotions: [Motions]
    private let queueCount: Int
    private let capacity: Int

    public init(queueCount: Int, capacity: Int) {
        self.queueCount = queueCount
        self.capacity = capacity
        self.cachedMotions = []
    }
    
    // Record current motion data
    public func recordMotion(_ motion: Motion) {
        // Ensure there is at least one Motions object
        if cachedMotions.isEmpty {
            cachedMotions.append(Motions(queueCount: queueCount, capacity: capacity))
        }

        // Safely access the last motions object in cachedMotions
        if var lastMotions = cachedMotions.last {
            // Try to enqueue the motion into the first non-full queue
            for index in lastMotions.motions.indices {
                if !lastMotions.motions[index].isFull() {
                    lastMotions.motions[index].enqueue(motion)
                    cachedMotions[cachedMotions.count - 1] = lastMotions // Update the cachedMotions with the modified lastMotions
                    return
                }
            }

            // All queues are full; create a new Motions object
            var newMotions = Motions(queueCount: queueCount, capacity: capacity)
            newMotions.motions[0].enqueue(motion) // Start with the first queue
            cachedMotions.append(newMotions)
        } else {
            fatalError("Unexpectedly nil cachedMotions")
        }
    }
    
    // Access cached motions
    public func getCachedMotions() -> [Motions] {
        return cachedMotions
    }
}
