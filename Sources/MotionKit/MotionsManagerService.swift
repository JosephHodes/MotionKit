//
//  File.swift
//  MotionKit
//
//  Created by Null Pointer on 8/26/24.
//

import Foundation

@available(iOS 13.0, *)
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
    
    public func recordMotion(accelerometer: SensorData, gyroscope: SensorData) {
        let motion = Motion(accelerometer: accelerometer, gyroscope: gyroscope)
        if cachedMotions.isEmpty {
            cachedMotions.append(Motions(queueCount: queueCount, capacity: capacity))
        }
        
        for i in 0..<cachedMotions[cachedMotions.count - 1].motions.count {
            if !cachedMotions[cachedMotions.count - 1].motions[i].isFull() {
                cachedMotions[cachedMotions.count - 1].motions[i].enqueue(motion)
                delegate?.didUpdateMotions()
                return
            }
        }
        
        let newMotions = Motions(queueCount: queueCount, capacity: capacity)
        cachedMotions.append(newMotions)
        cachedMotions[cachedMotions.count - 1].motions[0].enqueue(motion)
        delegate?.didUpdateMotions()
    }
    
    public func getCachedMotions() -> [Motions] {
        return cachedMotions
    }
}
