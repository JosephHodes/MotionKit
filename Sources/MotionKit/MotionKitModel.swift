import Foundation



public struct SensorData {
    public var x: Double
    public var y: Double
    public var z: Double
    
    public init(x: Double = 0, y: Double = 0, z: Double = 0) {
        self.x = x
        self.y = y
        self.z = z
    }
}

public struct Motion {
    public var accelerometer: SensorData
    public var gyroscope: SensorData
    
    public init(accelerometer: SensorData = SensorData(), gyroscope: SensorData = SensorData()) {
        self.accelerometer = accelerometer
        self.gyroscope = gyroscope
    }
}


@available(iOS 13.0.0, *)
public struct Motions {
    public var motions: [CircularBufferQueue<Motion>]  // Array of CircularBufferQueue<Motion>
    
    public init(queueCount: Int, capacity: Int) {
        self.motions = (0..<queueCount).map { _ in CircularBufferQueue<Motion>(capacity) }
    }
}


// Protocol for delegate to handle changes
public protocol MotionsManagerServiceDelegate: AnyObject {
    func didUpdateMotions()
}

@available(iOS 13.0.0, *)
public class MotionsManagerService {
    private var cachedMotions: [Motions]
    private let queueCount: Int
    private let capacity: Int
    public weak var delegate: MotionsManagerServiceDelegate?
    
    public init(queueCount: Int, capacity: Int) {
        self.queueCount = queueCount
        self.capacity = capacity
        self.cachedMotions = []
    }
    
    // Record current motion data
    public func recordMotion(_ motion: Motion) {
        if cachedMotions.isEmpty {
            cachedMotions.append(Motions(queueCount: queueCount, capacity: capacity))
        }
        
        // Enqueue the motion into the first non-full queue
        for i in 0..<cachedMotions[cachedMotions.count - 1].motions.count {
            if !cachedMotions[cachedMotions.count - 1].motions[i].isFull() {
                cachedMotions[cachedMotions.count - 1].motions[i].enqueue(motion)
                delegate?.didUpdateMotions()
                return
            }
        }
        
        // If all queues are full, create a new Motions object
        let newMotions = Motions(queueCount: queueCount, capacity: capacity)
        cachedMotions.append(newMotions)
        cachedMotions[cachedMotions.count - 1].motions[0].enqueue(motion) // Start with the first queue
        delegate?.didUpdateMotions()
    }
    
    // Access cached motions
    public func getCachedMotions() -> [Motions] {
        return cachedMotions
    }
}
