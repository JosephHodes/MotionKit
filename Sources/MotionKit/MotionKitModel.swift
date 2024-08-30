import Foundation
import CoreMotion

public struct SensorData {
    public var x: Double = 0.0
    public var y: Double = 0.0
    public var z: Double = 0.0
    public var xTheta: Double = 0.0
    public var yTheta: Double = 0.0
    public var zTheta: Double = 0.0
    public var xField: Double = 0.0
    public var yField: Double = 0.0
    public var zField: Double = 0.0
    
    public init() {}  // Added public initializer
}

public struct Motion {
    public var data: SensorData? = nil
    
    public init() {}  // Added public initializer
    
    public mutating func updateAccelerometerData(x: Double, y: Double, z: Double) {
        if data == nil { data = SensorData() }
        data?.x = x
        data?.y = y
        data?.z = z
    }
    
    public mutating func updateGyroData(xTheta: Double, yTheta: Double, zTheta: Double) {
        if data == nil { data = SensorData() }
        data?.xTheta = xTheta
        data?.yTheta = yTheta
        data?.zTheta = zTheta
    }
    
    public mutating func updateMagnetometerData(xField: Double, yField: Double, zField: Double) {
        if data == nil { data = SensorData() }
        data?.xField = xField
        data?.yField = yField
        data?.zField = zField
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
